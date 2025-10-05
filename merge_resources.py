#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
merge_resources.py - Resource整合脚本

功能：
1. 将Resource2,3,4的words.json内容整合到Resource/words.json中
2. 去重合并词汇数据
3. 将Resource2,3,4重置为初始状态
4. 保留各自的API key配置
"""

import os
import json
import shutil
from datetime import datetime

# 基本配置
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
RESOURCE_DIRS = ["Resource2", "Resource3", "Resource4"]
TARGET_DIR = "Resource"

# GLM API Keys for each resource (统一使用GLM-4.6)
API_KEYS = {
    "Resource2": "06b420079b514b599bbd6a6381829677.7j0V6fafUrjWg1sl",
    "Resource3": "06b420079b514b599bbd6a6381829677.7j0V6fafUrjWg1sl",
    "Resource4": "06b420079b514b599bbd6a6381829677.7j0V6fafUrjWg1sl"
}

# OFFSET配置 (重置后都为初始值，避免重复获取)
OFFSETS = {
    "Resource2": 1000,     # 重置后从1000开始
    "Resource3": 2000,     # 重置后从2000开始
    "Resource4": 3000      # 重置后从3000开始
}

def load_words_json(file_path):
    """加载words.json文件"""
    if not os.path.exists(file_path):
        return []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except Exception as e:
        print(f"⚠️ 读取 {file_path} 失败: {e}")
        return []

def save_words_json(file_path, data):
    """保存words.json文件"""
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        return True
    except Exception as e:
        print(f"❌ 保存 {file_path} 失败: {e}")
        return False

def merge_word_data(existing_words, new_words):
    """合并词汇数据，去重"""
    # 创建已存在词汇的字典 (小写键值)
    existing_dict = {}
    for word in existing_words:
        if isinstance(word, dict) and 'word' in word:
            key = word['word'].lower()
            existing_dict[key] = word
    
    # 合并新词汇
    added_count = 0
    for word in new_words:
        if isinstance(word, dict) and 'word' in word:
            key = word['word'].lower()
            if key not in existing_dict:
                existing_dict[key] = word
                added_count += 1
    
    # 返回合并后的列表
    merged_list = list(existing_dict.values())
    return merged_list, added_count

def reset_resource_to_initial(resource_dir):
    """将Resource重置为初始状态"""
    resource_path = os.path.join(BASE_DIR, resource_dir)
    
    print(f"🔄 重置 {resource_dir} 到初始状态...")
    
    # 1. 清空并重建backup文件夹
    backup_path = os.path.join(resource_path, "backup")
    if os.path.exists(backup_path):
        shutil.rmtree(backup_path)
    os.makedirs(backup_path)
    
    # 2. 清空并重建logs文件夹
    logs_path = os.path.join(resource_path, "logs")
    if os.path.exists(logs_path):
        shutil.rmtree(logs_path)
    os.makedirs(logs_path)
    
    # 3. 重置failed_permanent.json为空数组
    failed_perm_path = os.path.join(resource_path, "failed_permanent.json")
    with open(failed_perm_path, 'w', encoding='utf-8') as f:
        json.dump([], f, ensure_ascii=False, indent=2)
    
    # 4. 重置function_words_custom.txt为空
    func_words_path = os.path.join(resource_path, "function_words_custom.txt")
    with open(func_words_path, 'w', encoding='utf-8') as f:
        f.write("")
    
    # 5. 重置words.json为空数组
    words_path = os.path.join(resource_path, "words.json")
    with open(words_path, 'w', encoding='utf-8') as f:
        json.dump([], f, ensure_ascii=False, indent=2)
    
    # 6. 重置pipeline.py的配置但保持API key
    reset_pipeline_config(resource_dir)
    
    # 7. 重置state.json
    state_path = os.path.join(resource_path, "state.json")
    initial_state = {
        "run_id": "off0-tot100-bs8",
        "done_batches": []
    }
    with open(state_path, 'w', encoding='utf-8') as f:
        json.dump(initial_state, f, ensure_ascii=False, indent=2)
    
    print(f"✅ {resource_dir} 已重置为初始状态")

def reset_pipeline_config(resource_dir):
    """重置pipeline.py配置但保持API key"""
    pipeline_path = os.path.join(BASE_DIR, resource_dir, "pipeline.py")
    
    # 读取当前pipeline.py
    with open(pipeline_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 获取对应的API key和OFFSET
    api_key = API_KEYS.get(resource_dir)
    offset = OFFSETS.get(resource_dir, 0)
    
    # 重置关键配置项
    modifications = [
        ('TOTAL_WORDS     = \\d+', 'TOTAL_WORDS     = 1000'),
        ('AUTO_OFFSET     = \\w+', 'AUTO_OFFSET     = False'),
        (f'OFFSET          = \\s*\\d+', f'OFFSET          = {offset}'),
        ('GLM_API_KEY     = "[^"]*"', f'GLM_API_KEY     = "{api_key}"'),
        ('MODEL_NAME      = "[^"]*"', 'MODEL_NAME      = "glm-4.6"')
    ]
    
    import re
    for pattern, replacement in modifications:
        content = re.sub(pattern, replacement, content)
    
    # 写回文件
    with open(pipeline_path, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    print("🚀 开始Resource整合...")
    print("=" * 60)
    
    # 1. 加载Resource的现有词汇
    resource_words_path = os.path.join(BASE_DIR, TARGET_DIR, "words.json")
    existing_words = load_words_json(resource_words_path)
    print(f"📚 Resource现有词汇: {len(existing_words)} 个")
    
    # 2. 收集所有Resource2,3,4的词汇
    all_new_words = []
    for resource_dir in RESOURCE_DIRS:
        words_path = os.path.join(BASE_DIR, resource_dir, "words.json")
        words = load_words_json(words_path)
        all_new_words.extend(words)
        print(f"📖 {resource_dir}词汇: {len(words)} 个")
    
    print(f"📋 待整合词汇总数: {len(all_new_words)} 个")
    
    # 3. 合并去重
    print("🔄 开始合并去重...")
    merged_words, added_count = merge_word_data(existing_words, all_new_words)
    print(f"✨ 合并完成: 新增 {added_count} 个词汇")
    print(f"📊 Resource词库总数: {len(merged_words)} 个")
    
    # 4. 备份Resource的原始数据
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = os.path.join(BASE_DIR, TARGET_DIR, "backup", f"words_before_merge_{timestamp}.json")
    os.makedirs(os.path.dirname(backup_path), exist_ok=True)
    save_words_json(backup_path, existing_words)
    print(f"💾 原始数据已备份到: {os.path.basename(backup_path)}")
    
    # 5. 保存合并后的数据到Resource
    if save_words_json(resource_words_path, merged_words):
        print(f"✅ 合并数据已保存到 {TARGET_DIR}/words.json")
    else:
        print("❌ 保存合并数据失败，停止后续操作")
        return False
    
    # 6. 重置Resource2,3,4为初始状态
    print("\n" + "=" * 60)
    print("🔄 开始重置Resource2,3,4...")
    
    for resource_dir in RESOURCE_DIRS:
        reset_resource_to_initial(resource_dir)
    
    # 7. 生成整合报告
    print("\n" + "=" * 60)
    print("📊 整合完成报告:")
    print(f"  • Resource原有词汇: {len(existing_words)} 个")
    print(f"  • 待整合词汇总数: {len(all_new_words)} 个") 
    print(f"  • 实际新增词汇: {added_count} 个")
    print(f"  • Resource词库总数: {len(merged_words)} 个")
    print(f"  • Resource2,3,4 已重置为初始状态 (OFFSET=0)")
    print(f"  • 各自API key已保留")
    print("=" * 60)
    print("🎉 整合完成！")
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        if success:
            print("\n✅ 所有操作成功完成！")
        else:
            print("\n❌ 操作过程中出现错误！")
    except Exception as e:
        print(f"\n💥 脚本执行异常: {e}")
        import traceback
        traceback.print_exc()