#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
stats.py - 全局词库统计工具

功能：
- 统计所有Resource目录的词汇数量
- 对比各Resource的数据状态
- 提供快速概览
"""

import os
import json
from datetime import datetime

# 目录配置
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
RESOURCE_DIRS = ["Resource", "Resource2", "Resource3", "Resource4"]

def load_words_from_dir(resource_dir):
    """从指定目录加载词库数据"""
    words_file = os.path.join(BASE_DIR, resource_dir, "words.json")
    
    if not os.path.exists(words_file):
        return []
    
    try:
        with open(words_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except:
        return []

def count_unique_words(words_data):
    """统计唯一单词数量（与pipeline.py逻辑一致）"""
    unique_words = {}
    for item in words_data:
        if isinstance(item, dict) and 'word' in item:
            key = item['word'].lower()
            unique_words[key] = item
    return len(unique_words)

def get_file_info(resource_dir):
    """获取words.json文件信息"""
    words_file = os.path.join(BASE_DIR, resource_dir, "words.json")
    
    if not os.path.exists(words_file):
        return None
    
    try:
        stat = os.stat(words_file)
        size_kb = stat.st_size / 1024
        modified_time = datetime.fromtimestamp(stat.st_mtime)
        
        return {
            'size_kb': round(size_kb, 1),
            'modified_time': modified_time.strftime("%m-%d %H:%M")
        }
    except:
        return None

def check_api_key(resource_dir):
    """检查API key配置"""
    pipeline_file = os.path.join(BASE_DIR, resource_dir, "pipeline.py")
    
    if not os.path.exists(pipeline_file):
        return "[NO]"
    
    try:
        with open(pipeline_file, 'r', encoding='utf-8') as f:
            content = f.read()
            if 'DEEPSEEK_API_KEY=' in content and 'sk-' in content:
                return "[OK]"
            else:
                return "[?]"
    except:
        return "[??]"

def display_overview():
    """显示总览统计"""
    print("=" * 70)
    print("CheckWords 全局统计概览")
    print("=" * 70)
    print(f"{'目录':12} {'条目':>6} {'唯一':>6} {'大小':>8} {'更新时间':>12} {'API':>4}")
    print("-" * 70)
    
    total_items = 0
    total_unique = 0
    
    for resource_dir in RESOURCE_DIRS:
        words_data = load_words_from_dir(resource_dir)
        unique_count = count_unique_words(words_data)
        file_info = get_file_info(resource_dir)
        api_status = check_api_key(resource_dir)
        
        total_items += len(words_data)
        total_unique += unique_count
        
        # 格式化显示
        items_str = str(len(words_data)) if words_data else "0"
        unique_str = str(unique_count) if unique_count > 0 else "0"
        
        if file_info:
            size_str = f"{file_info['size_kb']}KB"
            time_str = file_info['modified_time']
        else:
            size_str = "-"
            time_str = "-"
        
        print(f"{resource_dir:12} {items_str:>6} {unique_str:>6} {size_str:>8} {time_str:>12} {api_status:>4}")
    
    print("-" * 70)
    print(f"{'总计':12} {total_items:>6} {total_unique:>6}")
    
    # 检查是否有可合并的数据
    resource234_total = 0
    for resource_dir in ["Resource2", "Resource3", "Resource4"]:
        words_data = load_words_from_dir(resource_dir)
        unique_count = count_unique_words(words_data)
        resource234_total += unique_count
    
    if resource234_total > 0:
        print(f"\n提示: Resource2,3,4 共有 {resource234_total} 个唯一单词可合并到Resource")
        print("   运行 'python merge_resources.py' 进行合并")

def display_detailed():
    """显示详细统计"""
    display_overview()
    
    print("\n" + "=" * 70)
    print("详细信息")
    print("=" * 70)
    
    for resource_dir in RESOURCE_DIRS:
        print(f"\n[{resource_dir}]:")
        
        words_data = load_words_from_dir(resource_dir)
        if not words_data:
            print("  无词汇数据")
            continue
        
        unique_count = count_unique_words(words_data)
        duplicates = len(words_data) - unique_count
        
        print(f"  总条目: {len(words_data)}")
        print(f"  唯一词: {unique_count}")
        if duplicates > 0:
            print(f"  重复词: {duplicates}")
        
        # 检查数据完整性
        complete_items = 0
        for item in words_data:
            if isinstance(item, dict) and all(key in item for key in ['word', 'parts_of_speech', 'pos_meanings']):
                complete_items += 1
        
        if complete_items != len(words_data):
            print(f"  不完整条目: {len(words_data) - complete_items}")
        else:
            print(f"  数据完整性: 良好")

def main():
    """主函数"""
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] in ['-d', '--detailed']:
        display_detailed()
    else:
        display_overview()
        print("\n提示: 使用 -d 或 --detailed 参数查看详细统计")
        print("提示: 单独查看Resource统计: cd Resource && python word_stats.py")

if __name__ == "__main__":
    main()