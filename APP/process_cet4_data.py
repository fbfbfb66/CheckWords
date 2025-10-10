#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CET4luan_1.json 数据预处理脚本
根据 Requirements.md 中的注释要求处理数据
"""

import json
import sqlite3
import os
from typing import Dict, List, Any

def replace_fran(text: str) -> str:
    """
    替换法语字母为英语字母
    """
    if not text:
        return text

    fr_en = [
        ['é', 'e'], ['ê', 'e'], ['è', 'e'], ['ë', 'e'],
        ['à', 'a'], ['â', 'a'], ['ç', 'c'], ['î', 'i'],
        ['ï', 'i'], ['ô', 'o'], ['ù', 'u'], ['û', 'u'],
        ['ü', 'u'], ['ÿ', 'y']
    ]

    for fr_char, en_char in fr_en:
        text = text.replace(fr_char, en_char)

    return text

def extract_word_data(word_json: Dict[str, Any]) -> Dict[str, Any]:
    """
    从原始JSON中提取所需的字段
    根据Requirements.md中定义的数据库架构
    """
    try:
        word_content = word_json.get('content', {}).get('word', {})
        content = word_content.get('content', {})

        # 基本信息
        word_rank = word_json.get('wordRank', 0)
        head_word = word_json.get('headWord', '')
        word_id = word_content.get('wordId', '')
        book_id = word_json.get('bookId', '')

        # 清理法语字母
        head_word = replace_fran(head_word)

        # 音标
        usphone = replace_fran(content.get('usphone', ''))
        ukphone = replace_fran(content.get('ukphone', ''))
        usspeech = content.get('usspeech', '')
        ukspeech = content.get('ukspeech', '')

        # 释义
        trans_data = content.get('trans', [])
        trans = json.dumps(trans_data, ensure_ascii=False)

        # 例句
        sentences_data = content.get('sentence', {}).get('sentences', [])
        # 清理例句中的法语字母
        for sentence in sentences_data:
            if 'sContent' in sentence:
                sentence['sContent'] = replace_fran(sentence['sContent'])
            if 'sCn' in sentence:
                sentence['sCn'] = replace_fran(sentence['sCn'])
        sentences = json.dumps(sentences_data, ensure_ascii=False)

        # 短语
        phrases_data = content.get('phrase', {}).get('phrases', [])
        # 清理短语中的法语字母
        for phrase in phrases_data:
            if 'pContent' in phrase:
                phrase['pContent'] = replace_fran(phrase['pContent'])
            if 'pCn' in phrase:
                phrase['pCn'] = replace_fran(phrase['pCn'])
        phrases = json.dumps(phrases_data, ensure_ascii=False)

        # 同近义词
        synos_data = content.get('syno', {}).get('synos', [])
        # 清理同近义词中的法语字母
        for syno in synos_data:
            if 'tran' in syno:
                syno['tran'] = replace_fran(syno['tran'])
            if 'hwds' in syno:
                for hwd in syno['hwds']:
                    if 'w' in hwd:
                        hwd['w'] = replace_fran(hwd['w'])
        synonyms = json.dumps(synos_data, ensure_ascii=False)

        # 同根词
        rel_words_data = content.get('relWord', {}).get('rels', [])
        # 清理同根词中的法语字母
        for rel_word in rel_words_data:
            if 'words' in rel_word:
                for word_item in rel_word['words']:
                    if 'hwd' in word_item:
                        word_item['hwd'] = replace_fran(word_item['hwd'])
                    if 'tran' in word_item:
                        word_item['tran'] = replace_fran(word_item['tran'])
        rel_words = json.dumps(rel_words_data, ensure_ascii=False)

        # 测试题
        exams_data = content.get('exam', [])
        # 清理测试题中的法语字母
        for exam in exams_data:
            if 'question' in exam:
                exam['question'] = replace_fran(exam['question'])
            if 'choices' in exam:
                for choice in exam['choices']:
                    if 'choice' in choice:
                        choice['choice'] = replace_fran(choice['choice'])
            if 'answer' in exam and 'explain' in exam['answer']:
                exam['answer']['explain'] = replace_fran(exam['answer']['explain'])
        exams = json.dumps(exams_data, ensure_ascii=False)

        # 分类 (从bookId提取)
        category = 'CET4' if 'CET4' in book_id else 'UNKNOWN'

        # 搜索内容 (用于全文搜索)
        search_parts = [head_word]

        # 添加释义到搜索内容
        for trans_item in trans_data:
            if 'tranCn' in trans_item:
                search_parts.append(trans_item['tranCn'])

        # 添加例句到搜索内容
        for sentence in sentences_data:
            if 'sContent' in sentence:
                search_parts.append(sentence['sContent'])
            if 'sCn' in sentence:
                search_parts.append(sentence['sCn'])

        search_content = ' '.join(search_parts)
        search_content = replace_fran(search_content)

        return {
            'wordRank': word_rank,
            'word': head_word,
            'wordId': word_id,
            'usphone': usphone,
            'ukphone': ukphone,
            'usspeech': usspeech,
            'ukspeech': ukspeech,
            'trans': trans,
            'sentences': sentences,
            'phrases': phrases,
            'synonyms': synonyms,
            'relWords': rel_words,
            'exams': exams,
            'category': category,
            'bookId': book_id,
            'searchContent': search_content
        }

    except Exception as e:
        print(f"提取数据时出错: {e}")
        print(f"问题数据: {word_json}")
        return None

def create_database():
    """
    创建SQLite数据库和表
    根据Requirements.md中的数据库架构
    """
    # 确保assets/data目录存在
    os.makedirs('assets/data', exist_ok=True)
    db_path = 'assets/data/cet4_words.db'

    # 如果数据库已存在，删除它
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # 创建words表
    cursor.execute('''
        CREATE TABLE words_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            wordRank INTEGER NOT NULL,
            headWord TEXT NOT NULL,
            wordId TEXT NOT NULL UNIQUE,
            usphone TEXT,
            ukphone TEXT,
            usspeech TEXT,
            ukspeech TEXT,
            trans TEXT DEFAULT '[]',
            sentences TEXT DEFAULT '[]',
            phrases TEXT DEFAULT '[]',
            synonyms TEXT DEFAULT '[]',
            relWords TEXT DEFAULT '[]',
            exams TEXT DEFAULT '[]',
            category TEXT NOT NULL,
            bookId TEXT NOT NULL,
            searchContent TEXT NOT NULL,
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
            updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    # 创建FTS5虚拟表用于全文搜索
    cursor.execute('''
        CREATE VIRTUAL TABLE words_fts USING fts5(
            headWord,
            searchContent,
            content='words_table',
            content_rowid='id'
        )
    ''')

    # 创建索引
    cursor.execute('CREATE INDEX idx_headWord ON words_table(headWord)')
    cursor.execute('CREATE INDEX idx_category ON words_table(category)')
    cursor.execute('CREATE INDEX idx_wordId ON words_table(wordId)')
    cursor.execute('CREATE INDEX idx_wordRank ON words_table(wordRank)')

    conn.commit()
    conn.close()

    print(f"数据库 {db_path} 创建成功")

def import_data_to_database(filename: str):
    """
    从JSON文件导入数据到数据库
    """
    db_path = 'assets/data/cet4_words.db'

    if not os.path.exists(filename):
        print(f"文件 {filename} 不存在")
        return

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    processed_count = 0
    error_count = 0

    try:
        with open(filename, 'r', encoding='utf-8') as file:
            for line_num, line in enumerate(file, 1):
                line = line.strip()
                if not line:
                    continue

                try:
                    # 解析JSON
                    word_json = json.loads(line)

                    # 提取数据
                    word_data = extract_word_data(word_json)

                    if word_data:
                        # 插入数据库
                        cursor.execute('''
                            INSERT INTO words_table (
                                wordRank, headWord, wordId, usphone, ukphone,
                                usspeech, ukspeech, trans, sentences, phrases,
                                synonyms, relWords, exams, category, bookId,
                                searchContent
                            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        ''', (
                            word_data['wordRank'],
                            word_data['word'],
                            word_data['wordId'],
                            word_data['usphone'],
                            word_data['ukphone'],
                            word_data['usspeech'],
                            word_data['ukspeech'],
                            word_data['trans'],
                            word_data['sentences'],
                            word_data['phrases'],
                            word_data['synonyms'],
                            word_data['relWords'],
                            word_data['exams'],
                            word_data['category'],
                            word_data['bookId'],
                            word_data['searchContent']
                        ))

                        # 插入FTS表
                        cursor.execute('''
                            INSERT INTO words_fts (headWord, searchContent)
                            VALUES (?, ?)
                        ''', (
                            word_data['word'],
                            word_data['searchContent']
                        ))

                        processed_count += 1

                        # 每1000条提交一次
                        if processed_count % 1000 == 0:
                            conn.commit()
                            print(f"已处理 {processed_count} 条数据...")

                except json.JSONDecodeError as e:
                    print(f"第 {line_num} 行JSON解析错误: {e}")
                    error_count += 1
                except Exception as e:
                    print(f"第 {line_num} 行处理错误: {e}")
                    error_count += 1

    except Exception as e:
        print(f"文件读取错误: {e}")

    finally:
        conn.commit()
        conn.close()

    print(f"数据导入完成!")
    print(f"成功处理: {processed_count} 条")
    print(f"错误数量: {error_count} 条")

def main():
    """
    主函数
    """
    filename = "c:\\Users\\FBI\\Desktop\\CheckWords\\APP\\assets\\data\\CET4luan_1.json"

    print("开始处理CET4luan_1.json数据...")

    # 1. 创建数据库
    print("创建数据库...")
    create_database()

    # 2. 导入数据
    print("导入数据...")
    import_data_to_database(filename)

    print("处理完成!")

if __name__ == "__main__":
    main()