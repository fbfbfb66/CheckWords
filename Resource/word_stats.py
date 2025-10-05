#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
word_stats.py - 词库统计工具

功能：
- 快速显示词库统计信息
- 详细分析词汇数据
- 检查数据完整性
"""

import os
import json
from datetime import datetime
from collections import Counter

# 文件路径
WORDS_REPO = "words.json"

def load_words_data():
    """加载词库数据"""
    if not os.path.exists(WORDS_REPO):
        print(f"❌ 未找到词库文件: {WORDS_REPO}")
        return []
    
    try:
        with open(WORDS_REPO, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except Exception as e:
        print(f"❌ 读取词库文件失败: {e}")
        return []

def count_unique_words(words_data):
    """统计唯一单词数量（与pipeline.py逻辑一致）"""
    unique_words = {}
    for item in words_data:
        if isinstance(item, dict) and 'word' in item:
            key = item['word'].lower()
            unique_words[key] = item
    return len(unique_words), unique_words

def analyze_parts_of_speech(words_data):
    """分析词性分布"""
    pos_counter = Counter()
    for item in words_data:
        if isinstance(item, dict) and 'parts_of_speech' in item:
            pos_list = item.get('parts_of_speech', [])
            for pos in pos_list:
                pos_counter[pos] += 1
    return pos_counter

def check_data_integrity(words_data):
    """检查数据完整性"""
    issues = []
    valid_items = 0
    
    required_fields = ['word', 'parts_of_speech', 'pos_meanings', 'phrases', 'sentences', 'pronunciation']
    
    for i, item in enumerate(words_data):
        if not isinstance(item, dict):
            issues.append(f"索引 {i}: 非字典对象")
            continue
            
        # 检查必需字段
        missing_fields = [field for field in required_fields if field not in item]
        if missing_fields:
            word = item.get('word', f'索引{i}')
            issues.append(f"单词 '{word}': 缺少字段 {missing_fields}")
            continue
            
        # 检查单词字段
        if not item.get('word'):
            issues.append(f"索引 {i}: word字段为空")
            continue
            
        valid_items += 1
    
    return valid_items, issues

def analyze_coverage_stats(words_data):
    """分析覆盖率统计"""
    stats = {
        'has_phrases': 0,
        'has_sentences': 0,
        'has_ipa': 0,
        'empty_phrases': 0,
        'empty_sentences': 0,
        'no_ipa': 0
    }
    
    for item in words_data:
        if not isinstance(item, dict):
            continue
            
        # 短语统计
        phrases = item.get('phrases', [])
        if phrases and len(phrases) > 0:
            stats['has_phrases'] += 1
        else:
            stats['empty_phrases'] += 1
            
        # 例句统计
        sentences = item.get('sentences', [])
        if sentences and len(sentences) > 0:
            stats['has_sentences'] += 1
        else:
            stats['empty_sentences'] += 1
            
        # IPA统计
        pronunciation = item.get('pronunciation', {})
        us_data = pronunciation.get('US', {})
        ipa = us_data.get('ipa')
        if ipa and ipa.strip():
            stats['has_ipa'] += 1
        else:
            stats['no_ipa'] += 1
    
    return stats

def get_file_info():
    """获取文件信息"""
    if not os.path.exists(WORDS_REPO):
        return None
        
    stat = os.stat(WORDS_REPO)
    size_mb = stat.st_size / (1024 * 1024)
    modified_time = datetime.fromtimestamp(stat.st_mtime)
    
    return {
        'size_mb': round(size_mb, 2),
        'modified_time': modified_time.strftime("%Y-%m-%d %H:%M:%S")
    }

def display_basic_stats():
    """显示基本统计信息"""
    words_data = load_words_data()
    if not words_data:
        return
        
    file_info = get_file_info()
    unique_count, unique_dict = count_unique_words(words_data)
    
    print("=" * 50)
    print("词库基本统计")
    print("=" * 50)
    print(f"总词汇条目: {len(words_data)}")
    print(f"唯一单词数: {unique_count}")
    if len(words_data) != unique_count:
        print(f"重复条目: {len(words_data) - unique_count}")
    
    if file_info:
        print(f"文件大小: {file_info['size_mb']} MB")
        print(f"最后更新: {file_info['modified_time']}")

def display_detailed_stats():
    """显示详细统计信息"""
    words_data = load_words_data()
    if not words_data:
        return
        
    display_basic_stats()
    
    # 数据完整性检查
    valid_items, issues = check_data_integrity(words_data)
    print("\n" + "=" * 50)
    print("数据完整性检查")
    print("=" * 50)
    print(f"有效条目: {valid_items}")
    if issues:
        print(f"发现问题: {len(issues)} 个")
        if len(issues) <= 5:
            for issue in issues:
                print(f"  • {issue}")
        else:
            for issue in issues[:5]:
                print(f"  • {issue}")
            print(f"  ... 还有 {len(issues) - 5} 个问题")
    else:
        print("数据完整性良好")
    
    # 词性分布
    pos_stats = analyze_parts_of_speech(words_data)
    print("\n" + "=" * 50)
    print("词性分布")
    print("=" * 50)
    if pos_stats:
        for pos, count in pos_stats.most_common(10):
            print(f"  {pos:12} : {count:4d}")
        if len(pos_stats) > 10:
            print(f"  ... 还有 {len(pos_stats) - 10} 种词性")
    else:
        print("  无词性数据")
    
    # 覆盖率统计
    coverage = analyze_coverage_stats(words_data)
    total_items = len(words_data)
    print("\n" + "=" * 50)
    print("内容覆盖率")
    print("=" * 50)
    if total_items > 0:
        print(f"有短语: {coverage['has_phrases']:4d} ({coverage['has_phrases']/total_items*100:.1f}%)")
        print(f"有例句: {coverage['has_sentences']:4d} ({coverage['has_sentences']/total_items*100:.1f}%)")
        print(f"有发音: {coverage['has_ipa']:4d} ({coverage['has_ipa']/total_items*100:.1f}%)")
    else:
        print("  无数据")

def main():
    """主函数"""
    import sys
    
    # 检查命令行参数
    if len(sys.argv) > 1 and sys.argv[1] in ['-d', '--detailed']:
        display_detailed_stats()
    else:
        display_basic_stats()
        print("\n提示: 使用 -d 或 --detailed 参数查看详细统计")

if __name__ == "__main__":
    main()