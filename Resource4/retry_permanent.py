#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
retry_permanent.py - 专门处理永久失败词的重试脚本

功能：
- 读取 failed_permanent.json 中的永久失败词
- 使用最新优化的模板重新尝试生成
- 成功的词从永久失败清单移除并加入词库
- 仍失败的词保留在永久失败清单中
"""

import os
import json
import time
from datetime import datetime
from tqdm import tqdm

# 重用 pipeline.py 的核心函数和配置
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pipeline import (
    PERM_FAILED_FILE, WORDS_REPO, DEEPSEEK_API_KEY,
    RETRY_BATCH_SIZE, RETRY_MAX_RETRY, FUNCTION_WORDS,
    _load_repo_dict, _save_repo, repo_lock,
    call_glm, extract_json_block, quality_checks, check_coverage,
    validate, SCHEMA, split_batches, run_batch_adaptive,
    load_function_words, create_smart_retry_prompt,
    _count_repo
)

# 专用于永久失败词的超宽松模板
PERMANENT_RETRY_PROMPT = """
为以下永久失败的英语单词生成 JSON 数组（仅输出 JSON，无其他文字）：

严格按照以下格式示例：
[
  {{
    "word": "example",
    "parts_of_speech": ["noun"],
    "pos_meanings": [
      {{"pos": "noun", "cn": "例子，示例"}}
    ],
    "phrases": [],
    "sentences": [],
    "pronunciation": {{"US": {{"ipa": null, "audio": null}}}}
  }}
]

关键要求：
1. pos_meanings 必须是对象数组！格式：[{{"pos": "词性", "cn": "中文"}}]
2. 功能词、数字词可以 phrases 留空：[]
3. 每个对象都必须包含所有必需字段
4. 严格遵循 JSON 格式，注意引号和逗号

单词列表：{words}
"""

def load_permanent_failed():
    """加载永久失败词清单"""
    if not os.path.exists(PERM_FAILED_FILE):
        print(f"❌ 没有找到 {PERM_FAILED_FILE} 文件")
        return []
    
    try:
        with open(PERM_FAILED_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
        print(f"📋 加载永久失败词：{len(data)} 个")
        return data
    except Exception as e:
        print(f"❌ 读取 {PERM_FAILED_FILE} 失败：{e}")
        return []

def save_permanent_failed(failed_words):
    """更新永久失败词清单"""
    try:
        with open(PERM_FAILED_FILE, "w", encoding="utf-8") as f:
            json.dump(sorted(list(set(failed_words))), f, ensure_ascii=False, indent=2)
        print(f"📌 更新永久失败词清单：{len(failed_words)} 个")
    except Exception as e:
        print(f"❌ 写入 {PERM_FAILED_FILE} 失败：{e}")

def deduplicate_failed_words(failed_words, repo_dict):
    """
    去重永久失败词：检查是否已存在于词库中
    Args:
        failed_words: 永久失败词列表
        repo_dict: 现有词库字典
    Returns:
        tuple: (需要重试的词, 已存在的词, 真正丢失的词)
    """
    words_to_retry = []  # 确实不在词库中，需要重试的词
    already_exists = []  # 已经存在于词库中的词
    
    print("🔍 开始去重检查永久失败词...")
    
    for word in failed_words:
        word_lower = word.lower().strip()
        if word_lower in repo_dict:
            already_exists.append(word)
            print(f"✅ 词汇 '{word}' 已存在于词库中，将从失败列表移除")
        else:
            words_to_retry.append(word)
    
    print(f"📊 去重结果：")
    print(f"   - 需要重试的词：{len(words_to_retry)} 个")
    print(f"   - 已存在的词：{len(already_exists)} 个")
    
    if already_exists:
        print(f"📝 已存在的词汇：{already_exists[:10]}{'...' if len(already_exists) > 10 else ''}")
    
    return words_to_retry, already_exists

def build_permanent_prompt(words):
    """构建永久失败词专用Prompt"""
    words_str = ", ".join(words)
    return PERMANENT_RETRY_PROMPT.format(words=words_str)

def retry_permanent_batch(repo_dict, words):
    """重试一批永久失败词"""
    try:
        prompt = build_permanent_prompt(words)
        raw = call_glm(prompt)
        
        # 调试输出
        print(f"🔍 AI原始回复（前200字符）：{raw[:200]}")
        
        json_block = extract_json_block(raw)
        print(f"🔍 提取的JSON（前200字符）：{json_block[:200]}")
        
        data = json.loads(json_block)
        print(f"🔍 解析后数据类型：{type(data)}, 长度：{len(data) if isinstance(data, list) else 'N/A'}")
        
        # 检查第一个项目的结构
        if isinstance(data, list) and len(data) > 0:
            first_item = data[0]
            print(f"🔍 第一个项目的键：{list(first_item.keys()) if isinstance(first_item, dict) else 'Not a dict'}")
            if isinstance(first_item, dict) and 'pos_meanings' in first_item:
                pos_meanings = first_item['pos_meanings']
                print(f"🔍 pos_meanings类型：{type(pos_meanings)}, 内容：{pos_meanings}")
                if isinstance(pos_meanings, list) and len(pos_meanings) > 0:
                    print(f"🔍 第一个pos_meanings项：{pos_meanings[0]}")
        
        validate(instance=data, schema=SCHEMA)
        
        # 使用最宽松的质量检查
        bad = quality_checks(data)
        if bad:
            print(f"⚠️ 质量检查发现问题：{bad[:3]}...")
            return False, [], f"quality-check-failed: {len(bad)} issues"
        
        # 覆盖率检查
        ok, diff = check_coverage(words, data)
        if not ok:
            return False, [], f"coverage-failed: missing={diff['missing']}, extras={diff['extras']}"
        
        # 成功：保存到词库
        with repo_lock:
            added = updated = 0
            for item in data:
                w = (item.get("word") or "").lower()
                if w in repo_dict:
                    updated += 1
                else:
                    added += 1
                repo_dict[w] = item
            _save_repo(repo_dict)
        
        return True, [w.lower() for w in words], f"added={added}, updated={updated}"
        
    except Exception as e:
        print(f"🔍 详细错误信息：{repr(e)}")
        import traceback
        print(f"🔍 完整堆栈：{traceback.format_exc()}")
        return False, [], f"exception: {repr(e)}"

def main():
    print("🔄 永久失败词重试脚本启动...")
    
    if not DEEPSEEK_API_KEY:
        print("❌ 请设置 DEEPSEEK_API_KEY")
        return
    
    # 加载数据
    failed_words = load_permanent_failed()
    if not failed_words:
        return
    
    repo_dict = _load_repo_dict()
    print(f"📚 当前词库：{_count_repo(repo_dict)} 词")
    
    # 重新加载最新的功能词白名单
    global FUNCTION_WORDS
    FUNCTION_WORDS = load_function_words()
    print(f"🛡️ 功能词白名单：{len(FUNCTION_WORDS)} 个")
    
    # 去重：检查永久失败词是否已存在于词库中
    words_to_retry, already_exists = deduplicate_failed_words(failed_words, repo_dict)
    
    # 如果有词已存在，立即更新永久失败清单
    if already_exists:
        print(f"🗑️  发现 {len(already_exists)} 个词已存在于词库中，立即从永久失败清单移除")
        save_permanent_failed(words_to_retry)
    
    # 如果没有需要重试的词，直接退出
    if not words_to_retry:
        print("🎉 所有永久失败词都已存在于词库中，无需重试！")
        return
    
    print(f"🎯 实际需要重试的词数：{len(words_to_retry)} 个")
    
    # 分批处理需要重试的词
    batches = split_batches(words_to_retry, RETRY_BATCH_SIZE)
    print(f"🎯 分为 {len(batches)} 个批次，每批 {RETRY_BATCH_SIZE} 词")
    
    succeeded_words = []
    still_failed_words = []
    
    prog = tqdm(total=len(batches), desc="重试永久失败词")
    
    for i, batch_words in enumerate(batches, 1):
        print(f"\n📦 处理批次 {i}/{len(batches)}: {batch_words}")
        
        success, success_words, reason = retry_permanent_batch(repo_dict, batch_words)
        
        if success:
            succeeded_words.extend(success_words)
            print(f"✅ 批次 {i} 成功：{reason}")
        else:
            still_failed_words.extend([w.lower() for w in batch_words])
            print(f"❌ 批次 {i} 仍失败：{reason}")
        
        prog.update(1)
        time.sleep(1.0)  # 防止API限流
    
    prog.close()
    
    # 汇总结果
    print(f"\n🎯 处理结果汇总：")
    print(f"📋 原始永久失败词数：{len(failed_words)} 词")
    print(f"🗑️  已存在于词库：{len(already_exists)} 词")
    print(f"🔄 实际重试词数：{len(words_to_retry)} 词")
    print(f"✅ 成功救回：{len(succeeded_words)} 词")
    print(f"❌ 仍然失败：{len(still_failed_words)} 词")
    print(f"📚 词库总数：{_count_repo(repo_dict)} 词")
    
    if already_exists:
        print(f"🎉 已存在词汇：{already_exists[:10]}{'...' if len(already_exists) > 10 else ''}")
    
    if succeeded_words:
        print(f"🎉 成功词汇：{succeeded_words[:10]}{'...' if len(succeeded_words) > 10 else ''}")
    
    if still_failed_words:
        print(f"🔴 仍失败词汇：{still_failed_words[:10]}{'...' if len(still_failed_words) > 10 else ''}")
    
    # 更新永久失败清单（只保留仍然失败的词）
    if len(still_failed_words) != len(failed_words):
        save_permanent_failed(still_failed_words)
        print(f"📝 永久失败清单已更新")
    
    # 生成报告
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_file = f"retry_permanent_report_{timestamp}.txt"
    
    with open(report_file, "w", encoding="utf-8") as f:
        f.write(f"永久失败词重试报告 - {timestamp}\n")
        f.write(f"=" * 50 + "\n\n")
        f.write(f"原始永久失败词数：{len(failed_words)}\n")
        f.write(f"已存在于词库词数：{len(already_exists)}\n")
        f.write(f"实际重试词数：{len(words_to_retry)}\n")
        f.write(f"成功救回词数：{len(succeeded_words)}\n")
        f.write(f"仍然失败词数：{len(still_failed_words)}\n")
        
        if words_to_retry:
            f.write(f"重试成功率：{len(succeeded_words)/len(words_to_retry)*100:.1f}%\n")
        f.write(f"总体救回率：{(len(already_exists) + len(succeeded_words))/len(failed_words)*100:.1f}%\n\n")
        
        if already_exists:
            f.write("已存在于词库的词汇：\n")
            f.write(", ".join(already_exists) + "\n\n")
        
        if succeeded_words:
            f.write("成功救回的词汇：\n")
            f.write(", ".join(succeeded_words) + "\n\n")
        
        if still_failed_words:
            f.write("仍然失败的词汇：\n")
            f.write(", ".join(still_failed_words) + "\n\n")
    
    print(f"📊 详细报告已保存至：{report_file}")
    print("🏁 永久失败词重试完成！")

if __name__ == "__main__":
    main()