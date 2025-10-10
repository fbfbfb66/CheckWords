#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
词汇数据预处理脚本
通用处理脚本，支持处理任意格式的词汇JSON文件
"""

import json
import sqlite3
import os
import glob
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

        # 分类直接使用bookId
        category = book_id

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

def get_database_name_from_bookid(book_id: str) -> str:
    """
    根据bookId生成数据库文件名
    直接使用bookId作为文件名，保持一致性
    """
    import re
    # 清理bookId中的特殊字符，只保留字母、数字和下划线
    clean_book_id = re.sub(r'[^\w]', '_', book_id)
    return f"{clean_book_id}.db"

def create_database(db_path: str):
    """
    创建SQLite数据库和表
    根据Requirements.md中的数据库架构
    """
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

def import_data_to_database(filename: str, db_path: str):
    """
    从JSON文件导入数据到指定数据库
    """
    if not os.path.exists(filename):
        print(f"文件 {filename} 不存在")
        return 0, 0

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

    return processed_count, error_count

def create_main_database():
    """
    创建或初始化汇总数据库
    如果表不存在则创建，存在则保留现有数据
    """
    db_path = 'assets/data/main.db'

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # 检查表是否存在
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='words_table'")
    table_exists = cursor.fetchone() is not None

    if not table_exists:
        # 创建words表
        cursor.execute('''
            CREATE TABLE words_table (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                wordRank INTEGER NOT NULL,
                headWord TEXT NOT NULL,
                wordId TEXT NOT NULL,
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
        print("创建words_table表")

    # 检查FTS表是否存在
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='words_fts'")
    fts_exists = cursor.fetchone() is not None

    if not fts_exists:
        # 创建FTS5虚拟表用于全文搜索
        cursor.execute('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
                headWord,
                searchContent,
                content='words_table',
                content_rowid='id'
            )
        ''')
        print("创建words_fts全文搜索表")

    # 检查索引是否存在，不存在则创建
    cursor.execute("SELECT name FROM sqlite_master WHERE type='index' AND name='idx_headWord'")
    if cursor.fetchone() is None:
        cursor.execute('CREATE INDEX idx_headWord ON words_table(headWord)')
        print("创建idx_headWord索引")

    cursor.execute("SELECT name FROM sqlite_master WHERE type='index' AND name='idx_category'")
    if cursor.fetchone() is None:
        cursor.execute('CREATE INDEX idx_category ON words_table(category)')
        print("创建idx_category索引")

    cursor.execute("SELECT name FROM sqlite_master WHERE type='index' AND name='idx_wordId'")
    if cursor.fetchone() is None:
        cursor.execute('CREATE INDEX idx_wordId ON words_table(wordId)')
        print("创建idx_wordId索引")

    cursor.execute("SELECT name FROM sqlite_master WHERE type='index' AND name='idx_wordRank'")
    if cursor.fetchone() is None:
        cursor.execute('CREATE INDEX idx_wordRank ON words_table(wordRank)')
        print("创建idx_wordRank索引")

    conn.commit()
    conn.close()

    if table_exists:
        print(f"汇总数据库 {db_path} 已存在，保留现有数据")
    else:
        print(f"汇总数据库 {db_path} 创建成功")

def merge_to_main_database(source_db_path: str):
    """
    将源数据库的数据合并到汇总数据库（去重）
    去重逻辑：基于headWord去重，保留第一次出现的记录
    """
    main_db_path = 'assets/data/main.db'

    if not os.path.exists(source_db_path):
        print(f"源数据库 {source_db_path} 不存在")
        return 0, 0

    # 连接源数据库和汇总数据库
    source_conn = sqlite3.connect(source_db_path)
    main_conn = sqlite3.connect(main_db_path)

    source_cursor = source_conn.cursor()
    main_cursor = main_conn.cursor()

    try:
        # 获取源数据库的所有数据
        source_cursor.execute('SELECT * FROM words_table ORDER BY wordRank')
        source_words = source_cursor.fetchall()

        if not source_words:
            print("源数据库为空")
            return 0, 0

        # 获取列名
        column_names = [description[0] for description in source_cursor.description]

        processed_count = 0
        skipped_count = 0

        for word_row in source_words:
            # 将元组转换为字典
            word_dict = dict(zip(column_names, word_row))
            head_word = word_dict['headWord']

            # 检查汇总数据库中是否已存在该单词
            main_cursor.execute('SELECT COUNT(*) FROM words_table WHERE headWord = ?', (head_word,))
            count = main_cursor.fetchone()[0]

            if count == 0:
                # 插入到汇总数据库
                insert_columns = list(word_dict.keys())[1:]  # 跳过id字段
                insert_values = list(word_dict.values())[1:]  # 跳过id字段

                placeholders = ', '.join(['?' for _ in insert_columns])
                columns_str = ', '.join(insert_columns)

                main_cursor.execute(f'''
                    INSERT INTO words_table ({columns_str})
                    VALUES ({placeholders})
                ''', insert_values)

                # 插入FTS表
                main_cursor.execute('''
                    INSERT INTO words_fts (headWord, searchContent)
                    VALUES (?, ?)
                ''', (head_word, word_dict['searchContent']))

                processed_count += 1
            else:
                skipped_count += 1

        main_conn.commit()

        print(f"合并到汇总数据库完成!")
        print(f"新增记录: {processed_count} 条")
        print(f"跳过重复: {skipped_count} 条")

        return processed_count, skipped_count

    except Exception as e:
        print(f"合并数据时出错: {e}")
        return 0, 0

    finally:
        source_conn.close()
        main_conn.close()

def find_json_files():
    """
    在assets/data/json目录下查找JSON文件
    """
    json_dir = 'assets/data/json'

    if not os.path.exists(json_dir):
        print(f"目录 {json_dir} 不存在")
        return []

    # 查找所有.json文件
    json_files = glob.glob(os.path.join(json_dir, '*.json'))

    return json_files

def get_book_id_from_json(filename: str) -> str:
    """
    从JSON文件中读取第一个条目获取bookId
    """
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            for line in file:
                line = line.strip()
                if line:
                    word_json = json.loads(line)
                    book_id = word_json.get('bookId', '')
                    if book_id:
                        return book_id
    except Exception as e:
        print(f"读取bookId时出错: {e}")

    return 'unknown'

def backup_existing_data():
    """
    备份现有的汇总数据库
    """
    main_db_path = 'assets/data/main.db'
    backup_path = 'assets/data/main.db.backup'

    if os.path.exists(main_db_path):
        try:
            # 如果备份文件已存在，先删除
            if os.path.exists(backup_path):
                os.remove(backup_path)
            # 复制文件作为备份
            import shutil
            shutil.copy2(main_db_path, backup_path)
            print(f"已备份现有数据库到: {backup_path}")
            return True
        except Exception as e:
            print(f"备份数据库失败: {e}")
            return False
    return False

def main():
    """
    主函数
    """
    print("开始处理词汇数据...")

    # 确保目录存在
    os.makedirs('assets/data/db', exist_ok=True)
    os.makedirs('assets/data/json', exist_ok=True)

    # 查找JSON文件
    json_files = find_json_files()

    if not json_files:
        print("未找到任何JSON文件，请将词汇数据文件放在 assets/data/json/ 目录下")
        return

    print(f"找到 {len(json_files)} 个JSON文件")

    # 备份现有数据
    backup_existing_data()

    # 创建汇总数据库（保留现有数据）
    print("初始化汇总数据库...")
    create_main_database()

    total_processed = 0
    total_merged = 0

    # 处理每个JSON文件
    for json_file in json_files:
        print(f"\n处理文件: {json_file}")

        # 获取bookId
        book_id = get_book_id_from_json(json_file)
        print(f"检测到bookId: {book_id}")

        # 生成数据库文件名
        db_filename = get_database_name_from_bookid(book_id)
        db_path = f'assets/data/db/{db_filename}'

        print(f"生成独立数据库: {db_path}")

        # 创建独立数据库
        create_database(db_path)

        # 导入数据到独立数据库
        print(f"导入数据到 {db_path}...")
        processed_count, error_count = import_data_to_database(json_file, db_path)
        total_processed += processed_count

        if processed_count > 0:
            # 合并到汇总数据库
            print(f"合并数据到汇总数据库...")
            merged_count, skipped_count = merge_to_main_database(db_path)
            total_merged += merged_count
        else:
            print("没有有效数据，跳过合并")

    print(f"\n处理完成!")
    print(f"总计处理: {total_processed} 条词汇")
    print(f"总计合并到汇总数据库: {total_merged} 条词汇")
    print("独立数据库文件位于: assets/data/db/")
    print("汇总数据库文件位于: assets/data/main.db")

if __name__ == "__main__":
    main()