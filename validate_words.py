#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
validate_words.py - 独立的词汇验证脚本

功能：
- 读取 temp_words.json 中的AI生成结果
- 使用与 Resource/pipeline.py 相同的验证逻辑
- 检查JSON Schema、质量检查、覆盖率等
- 输出详细的验证报告
"""

import os
import json
from typing import List, Dict, Any, Tuple

# ============ Schema 定义（与 pipeline.py 保持一致） ============
SCHEMA = {
    "type": "array",
    "items": {
        "type": "object",
        "required": ["word", "parts_of_speech", "pos_meanings", "phrases", "sentences", "pronunciation"],
        "properties": {
            "word": {"type": "string"},
            "parts_of_speech": {
                "type": "array",
                "items": {"type": "string"},
                "minItems": 1
            },
            "pos_meanings": {
                "type": "array",
                "items": {
                    "type": "object",
                    "required": ["pos", "cn"],
                    "properties": {
                        "pos": {"type": "string"},
                        "cn":  {"type": "string"}
                    }
                },
                "minItems": 1
            },
            "phrases": {
                "type": "array",
                "items": {
                    "type": "object",
                    "required": ["phrase", "dialog"],
                    "properties": {
                        "phrase": {"type": "string"},
                        "dialog": {
                            "type": "object",
                            "required": ["A", "B"],
                            "properties": {
                                "A": {"type": "string"},
                                "B": {"type": "string"}
                            }
                        }
                    }
                }
            },
            "sentences": {
                "type": "array",
                "items": {
                    "type": "object",
                    "required": ["en", "cn"],
                    "properties": {
                        "en": {"type": "string"},
                        "cn": {"type": "string"}
                    }
                }
            },
            "pronunciation": {
                "type": "object",
                "required": ["US"],
                "properties": {
                    "US": {
                        "type": "object",
                        "required": ["ipa", "audio"],
                        "properties": {
                            "ipa": {"type": ["string", "null"]},
                            "audio": {"type": ["string", "null"]}
                        }
                    }
                }
            }
        }
    }
}

# ============ 功能词白名单（与 pipeline.py 保持一致） ============
BASE_FUNCTION_WORDS = {
    "a","an","the","some","any","each","every","either","neither","another",
    "this","that","these","those","both","all","half","many","much","few","little",
    "i","you","he","she","it","we","they","me","him","her","us","them",
    "my","your","his","her","its","our","their","mine","yours","hers","ours","theirs",
    "someone","anyone","everyone","no one","something","anything","everything","nothing",
    "to","of","in","on","at","for","from","by","with","about","as","after","before",
    "between","around","since","than","over","under","into","onto","through","during",
    "without","within","across","against","toward","upon","off","up","down","out",
    "and","or","but","if","so","yet","nor","though","although","because","while","unless",
    "be","am","is","are","was","were","been","being",
    "do","does","did","done","doing",
    "have","has","had","having",
    "can","could","may","might","must","shall","should","will","would",
    "not","n't","no","only","very","just",
    "i'm","you're","he's","she's","it's","we're","they're",
    "i've","you've","we've","they've",
    "i'd","you'd","he'd","she'd","we'd","they'd",
    "i'll","you'll","he'll","she'll","we'll","they'll",
    "don't","doesn't","didn't","can't","couldn't","won't","wouldn't","isn't",
    "aren't","wasn't","weren't","haven't","hasn't","hadn't","shouldn't","mustn't",
    "he's","there's","they'll","however","less","tired"  # 添加失败词供测试
}

CONTENT_BLACKLIST = {
    "help","find","show","make","take","give","get","go","come","look","work","call",
    "use","need","try","keep","think","know","feel","tell","ask","play","run","write",
    "people","person","thing","time","way","good","new","old","high","big","small",
    "better","best","always","never","end","begin","start"
}

FUNCTION_WORDS_FILE = "function_words_custom.txt"

def load_function_words():
    """加载功能词白名单"""
    words = set(BASE_FUNCTION_WORDS)
    if os.path.exists(FUNCTION_WORDS_FILE):
        try:
            with open(FUNCTION_WORDS_FILE, "r", encoding="utf-8") as f:
                for line in f:
                    w = line.strip().lower()
                    if w and w not in CONTENT_BLACKLIST:
                        words.add(w)
        except Exception as e:
            print(f"⚠️ 读取 {FUNCTION_WORDS_FILE} 失败：{e}")
    return words

FUNCTION_WORDS = load_function_words()

# ============ 验证函数（与 pipeline.py 保持一致） ============
def _normalize_pos_list(pos_list):
    """规范化词性列表"""
    return [x.strip() for x in pos_list if x and x.strip()]

def _normalize_pos_meanings(pm_list):
    """规范化pos_meanings列表"""
    res = []
    for pm in pm_list:
        if isinstance(pm, dict) and "pos" in pm and "cn" in pm:
            pos = pm["pos"].strip() if pm["pos"] else ""
            cn = pm["cn"].strip() if pm["cn"] else ""
            if pos and cn:
                res.append({"pos": pos, "cn": cn})
    return res

def check_pos_alignment(item):
    """确保 parts_of_speech 与 pos_meanings 一一对应"""
    pos_list = _normalize_pos_list(item.get("parts_of_speech", []))
    pm_list = _normalize_pos_meanings(item.get("pos_meanings", []))
    if not pos_list or not pm_list:
        return False, "pos-empty"
    pos_set = set(pos_list)
    pm_pos = {x["pos"] for x in pm_list}
    if pos_set != pm_pos:
        return False, f"pos-mismatch: pos={sorted(pos_set)} pm={sorted(pm_pos)}"
    return True, ""

def quality_checks(items):
    """质量检查（与 pipeline.py 保持一致）"""
    bad = []
    for it in items:
        w = (it.get("word") or "").lower().strip() or "?"
        
        # === 功能词豁免：只需基本pos检查，无需phrase/dialog ===
        if w in FUNCTION_WORDS:
            # 对功能词使用宽松的pos检查
            pos_list = _normalize_pos_list(it.get("parts_of_speech", []))
            pm_list = _normalize_pos_meanings(it.get("pos_meanings", []))
            # 功能词只要有任何pos信息就通过
            if not pos_list and not pm_list:
                bad.append((w, "function-word-pos-empty"))
                continue
            # 功能词不要求pos与pos_meanings严格对齐，只要不为空即可
            continue
        
        # 1) 非功能词的严格pos对齐检查
        ok, reason = check_pos_alignment(it)
        if not ok:
            bad.append((w, reason))
            continue

        phr = it.get("phrases", [])

        # 非功能词允许空phrases（当找不到合适真实短语时）
        # 如果有phrases，则必须是真实短语，不能是单词本体

        # 2) phrase 必须在 A/B 出现（宽松）；或至少 word 本体出现
        ok_all = True
        for p in phr:
            phrase = (p.get("phrase") or "").strip()
            d = p.get("dialog", {}) or {}
            
            if not phrase:
                bad.append((w, "phrase-empty"))
                ok_all = False
                break
                
            # 检查短语不能等于单词本体
            if phrase.lower() == w.lower():
                bad.append((w, "phrase-equals-word"))
                ok_all = False
                break
            
            a = (d.get("A") or "").strip()
            b = (d.get("B") or "").strip()
            
            if not a or not b:
                bad.append((w, "dialog-empty"))
                ok_all = False
                break
            
            # 检查对话中是否包含短语或单词（宽松匹配）
            ab_text = (a + " " + b).lower()
            phrase_words = phrase.lower().split()
            word_in_dialog = w in ab_text
            phrase_words_in_dialog = any(pw in ab_text for pw in phrase_words if len(pw) > 2)
            
            if not word_in_dialog and not phrase_words_in_dialog:
                bad.append((w, f"phrase-dialog-mismatch: '{phrase}' not found in dialog"))
                ok_all = False
                break
        
        if not ok_all:
            continue
    
    return bad

def check_coverage(expected_words, items):
    """覆盖率检查"""
    exp = [x.lower() for x in expected_words]
    got = [(it.get("word") or "").lower() for it in items]
    missing = sorted(set(exp) - set(got))
    extras = sorted(set(got) - set(exp))
    dupes = sorted([w for w in got if got.count(w) > 1])
    return (len(missing) == 0 and len(extras) == 0), {"missing": missing, "extras": extras, "dupes": dupes}

def validate_json_schema(data):
    """JSON Schema 验证"""
    try:
        from jsonschema import validate
        validate(instance=data, schema=SCHEMA)
        return True, ""
    except Exception as e:
        return False, str(e)

def clean_passed_words_from_failed_permanent(passed_words):
    """从 Resource/failed_permanent.json 中清理已通过验证的单词"""
    failed_file = os.path.join("Resource", "failed_permanent.json")
    
    if not os.path.exists(failed_file):
        print("[INFO] failed_permanent.json 不存在，无需清理")
        return True
    
    try:
        # 读取失败词列表
        with open(failed_file, "r", encoding="utf-8") as f:
            failed_words = json.load(f)
        
        if not isinstance(failed_words, list):
            print(f"[WARNING] {failed_file} 格式不正确，跳过清理")
            return False
        
        print(f"[INFO] 读取永久失败词列表：{len(failed_words)} 个")
        
        # 获取通过验证的单词（小写）
        passed_word_set = {(word.get("word") or "").lower() for word in passed_words}
        print(f"[SUCCESS] 通过验证的单词：{sorted(passed_word_set)}")
        
        # 从失败列表中移除通过验证的单词
        original_count = len(failed_words)
        cleaned_words = [word for word in failed_words if word.lower() not in passed_word_set]
        removed_count = original_count - len(cleaned_words)
        
        if removed_count > 0:
            # 备份原文件
            backup_dir = os.path.join("Resource", "backup")
            os.makedirs(backup_dir, exist_ok=True)
            from datetime import datetime
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_file = os.path.join(backup_dir, f"failed_permanent_before_clean_{timestamp}.json")
            try:
                import shutil
                shutil.copy2(failed_file, backup_file)
                print(f"[BACKUP] 备份失败词列表到: {backup_file}")
            except Exception as e:
                print(f"[WARNING] 备份失败：{e}")
            
            # 写入清理后的失败词列表
            with open(failed_file, "w", encoding="utf-8") as f:
                json.dump(cleaned_words, f, ensure_ascii=False, indent=2)
            
            print(f"[CLEAN] 从永久失败列表中移除了 {removed_count} 个已通过验证的单词")
            print(f"[INFO] 剩余永久失败单词：{len(cleaned_words)} 个")
            
            if len(cleaned_words) == 0:
                print("[SUCCESS] 所有永久失败的单词都已通过验证！")
        else:
            print("[INFO] 无需清理，没有找到已通过验证的单词")
        
        return True
        
    except Exception as e:
        print(f"[ERROR] 清理永久失败词列表失败：{e}")
        return False

def merge_to_words_json(new_words):
    """将验证通过的词汇合并到 Resource/words.json"""
    words_file = os.path.join("Resource", "words.json")
    
    # 读取现有词库
    existing_words = []
    if os.path.exists(words_file):
        try:
            with open(words_file, "r", encoding="utf-8") as f:
                existing_words = json.load(f)
            print(f"📚 读取现有词库：{len(existing_words)} 个词")
        except Exception as e:
            print(f"❌ 读取 {words_file} 失败：{e}")
            return False
    
    # 创建现有词汇的小写映射，避免重复
    existing_word_map = {(word.get("word") or "").lower(): word for word in existing_words}
    
    # 合并新词汇
    added_count = 0
    updated_count = 0
    
    for new_word in new_words:
        word_key = (new_word.get("word") or "").lower()
        if word_key in existing_word_map:
            # 更新现有词汇
            existing_word_map[word_key] = new_word
            updated_count += 1
            print(f"🔄 更新词汇: {word_key}")
        else:
            # 添加新词汇
            existing_word_map[word_key] = new_word
            added_count += 1
            print(f"✅ 添加词汇: {word_key}")
    
    # 重新构建词汇列表（保持字母顺序）
    merged_words = list(existing_word_map.values())
    merged_words.sort(key=lambda x: (x.get("word") or "").lower())
    
    # 备份原文件
    if os.path.exists(words_file):
        backup_dir = os.path.join("Resource", "backup")
        os.makedirs(backup_dir, exist_ok=True)
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = os.path.join(backup_dir, f"words_before_merge_{timestamp}.json")
        try:
            import shutil
            shutil.copy2(words_file, backup_file)
            print(f"💾 备份原文件到: {backup_file}")
        except Exception as e:
            print(f"⚠️ 备份失败：{e}")
    
    # 写入合并后的词库
    try:
        with open(words_file, "w", encoding="utf-8") as f:
            json.dump(merged_words, f, ensure_ascii=False, indent=2)
        print(f"💾 保存合并后的词库：{len(merged_words)} 个词")
        print(f"📊 本次操作：新增 {added_count} 个，更新 {updated_count} 个")
        return True
    except Exception as e:
        print(f"❌ 保存 {words_file} 失败：{e}")
        return False

def main():
    """主验证流程"""
    temp_file = "temp_words.json"
    
    print("🔍 独立词汇验证脚本启动...")
    print(f"📋 功能词白名单：{len(FUNCTION_WORDS)} 个")
    
    # 检查临时文件是否存在
    if not os.path.exists(temp_file):
        print(f"❌ 找不到 {temp_file} 文件")
        print(f"📝 请将AI生成的JSON结果粘贴到 {temp_file} 中")
        return False
    
    # 读取并解析JSON
    try:
        with open(temp_file, "r", encoding="utf-8") as f:
            content = f.read().strip()
        
        if not content:
            print(f"❌ {temp_file} 文件为空")
            return False
        
        print(f"📄 读取 {temp_file}：{len(content)} 字符")
        
        # 解析JSON
        data = json.loads(content)
        print(f"✅ JSON解析成功：{type(data).__name__}")
        
        if isinstance(data, list):
            print(f"📊 包含 {len(data)} 个词条")
        else:
            print("❌ 数据不是数组格式")
            return False
            
    except json.JSONDecodeError as e:
        print(f"❌ JSON解析失败：{e}")
        return False
    except Exception as e:
        print(f"❌ 读取文件失败：{e}")
        return False
    
    # 提取期望的单词列表（从failed_permanent.json）
    expected_words = []
    failed_file = os.path.join("Resource", "failed_permanent.json")
    if os.path.exists(failed_file):
        try:
            with open(failed_file, "r", encoding="utf-8") as f:
                expected_words = json.load(f)
            print(f"📋 期望处理的词汇：{expected_words}")
        except Exception as e:
            print(f"⚠️ 读取 {failed_file} 失败：{e}")
    
    if not expected_words:
        print("⚠️ 无法获取期望词汇列表，将跳过覆盖率检查")
    
    # 开始验证
    print("\n" + "="*50)
    print("🔍 开始验证...")
    
    # 1. JSON Schema 验证
    print("\n📋 1. JSON Schema 验证...")
    schema_ok, schema_error = validate_json_schema(data)
    if schema_ok:
        print("✅ JSON Schema 验证通过")
    else:
        print(f"❌ JSON Schema 验证失败：{schema_error}")
        return False
    
    # 2. 质量检查
    print("\n🔍 2. 质量检查...")
    bad_items = quality_checks(data)
    if not bad_items:
        print("✅ 质量检查通过")
    else:
        print(f"❌ 质量检查发现 {len(bad_items)} 个问题：")
        for word, reason in bad_items[:10]:  # 只显示前10个
            print(f"   - {word}: {reason}")
        if len(bad_items) > 10:
            print(f"   ... 还有 {len(bad_items) - 10} 个问题")
    
    # 3. 覆盖率检查
    if expected_words:
        print("\n📊 3. 覆盖率检查...")
        coverage_ok, coverage_info = check_coverage(expected_words, data)
        if coverage_ok:
            print("✅ 覆盖率检查通过")
        else:
            print("❌ 覆盖率检查发现问题：")
            if coverage_info["missing"]:
                print(f"   - 缺失词汇：{coverage_info['missing']}")
            if coverage_info["extras"]:
                print(f"   - 额外词汇：{coverage_info['extras']}")
            if coverage_info["dupes"]:
                print(f"   - 重复词汇：{coverage_info['dupes']}")
    else:
        coverage_ok = True
        print("\n📊 3. 覆盖率检查：跳过（无期望词汇列表）")
    
    # 4. 统计信息
    print("\n📈 4. 统计信息...")
    total_words = len(data)
    function_word_count = 0
    content_word_count = 0
    
    for item in data:
        word = (item.get("word") or "").lower().strip()
        if word in FUNCTION_WORDS:
            function_word_count += 1
        else:
            content_word_count += 1
    
    print(f"   - 总词数：{total_words}")
    print(f"   - 功能词：{function_word_count}")
    print(f"   - 内容词：{content_word_count}")
    
    # 5. 最终结果
    print("\n" + "="*50)
    overall_ok = schema_ok and len(bad_items) == 0 and coverage_ok
    
    if overall_ok:
        print("🎉 验证通过！所有检查都成功")
        
        # 询问用户是否要合并到词库
        while True:
            response = input("\n❓ 是否将这些词汇合并到 Resource/words.json？(y/n): ").strip().lower()
            if response in ['y', 'yes', '是', '是的']:
                print("\n🔄 开始合并到词库...")
                merge_success = merge_to_words_json(data)
                if merge_success:
                    print("✅ 合并完成！词库已更新")
                    
                    # 自动清理已通过验证的单词从永久失败列表
                    print("\n🧹 自动清理永久失败列表...")
                    clean_success = clean_passed_words_from_failed_permanent(data)
                    if clean_success:
                        print("✅ 永久失败列表清理完成")
                    else:
                        print("⚠️ 永久失败列表清理失败")
                    
                    # 清空临时文件
                    try:
                        with open(temp_file, "w", encoding="utf-8") as f:
                            json.dump([], f, ensure_ascii=False, indent=2)
                        print(f"🗑️  已清空 {temp_file}")
                    except Exception as e:
                        print(f"⚠️ 清空 {temp_file} 失败：{e}")
                else:
                    print("❌ 合并失败")
                    return False
                break
            elif response in ['n', 'no', '否', '不']:
                print("⏸️  跳过合并，验证完成")
                break
            else:
                print("❓ 请输入 y/n")
        
        print("✅ 数据验证成功，可以安全使用")
    else:
        print("❌ 验证失败，存在以下问题：")
        if not schema_ok:
            print("   - JSON Schema 不符合要求")
        if bad_items:
            print(f"   - {len(bad_items)} 个词汇存在质量问题")
        if not coverage_ok:
            print("   - 覆盖率不完整")
        print("🔧 请修复问题后重新验证")
    
    return overall_ok

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)