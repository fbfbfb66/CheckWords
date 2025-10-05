#!/usr/bin/env python3
"""
将words.json转换为SQLite数据库的脚本
"""

import json
import sqlite3
import os
from typing import Dict, List, Any

class WordsConverter:
    def __init__(self, json_file: str, db_file: str):
        self.json_file = json_file
        self.db_file = db_file
        
    def create_database_schema(self, conn: sqlite3.Connection):
        """创建数据库表结构"""
        cursor = conn.cursor()
        
        # 主词汇表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT UNIQUE NOT NULL
        )
        ''')
        
        # 词性表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS parts_of_speech (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER,
            pos TEXT NOT NULL,
            FOREIGN KEY (word_id) REFERENCES words (id)
        )
        ''')
        
        # 词性释义表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS pos_meanings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER,
            pos TEXT NOT NULL,
            meaning_cn TEXT NOT NULL,
            FOREIGN KEY (word_id) REFERENCES words (id)
        )
        ''')
        
        # 短语表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS phrases (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER,
            phrase TEXT NOT NULL,
            FOREIGN KEY (word_id) REFERENCES words (id)
        )
        ''')
        
        # 对话表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS dialogs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phrase_id INTEGER,
            speaker_a TEXT,
            speaker_b TEXT,
            FOREIGN KEY (phrase_id) REFERENCES phrases (id)
        )
        ''')
        
        # 例句表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS sentences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER,
            sentence_en TEXT NOT NULL,
            sentence_zh TEXT NOT NULL,
            FOREIGN KEY (word_id) REFERENCES words (id)
        )
        ''')
        
        # 发音表
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS pronunciations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER,
            region TEXT DEFAULT 'US',
            ipa TEXT,
            audio TEXT,
            FOREIGN KEY (word_id) REFERENCES words (id)
        )
        ''')
        
        # 创建索引以提高查询性能
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_words_word ON words (word)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_pos_word_id ON parts_of_speech (word_id)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_meanings_word_id ON pos_meanings (word_id)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_phrases_word_id ON phrases (word_id)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_sentences_word_id ON sentences (word_id)')
        cursor.execute('CREATE INDEX IF NOT EXISTS idx_pronunciations_word_id ON pronunciations (word_id)')
        
        conn.commit()
        print("数据库表结构创建完成")
        
    def load_json_data(self) -> List[Dict[str, Any]]:
        """加载JSON数据"""
        with open(self.json_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        print(f"加载了 {len(data)} 个词汇")
        return data
        
    def insert_word_data(self, conn: sqlite3.Connection, word_data: Dict[str, Any]) -> int:
        """插入单词数据并返回word_id"""
        cursor = conn.cursor()
        
        # 插入主词汇
        cursor.execute('INSERT OR IGNORE INTO words (word) VALUES (?)', (word_data['word'],))
        cursor.execute('SELECT id FROM words WHERE word = ?', (word_data['word'],))
        word_id = cursor.fetchone()[0]
        
        # 插入词性
        for pos in word_data.get('parts_of_speech', []):
            cursor.execute('INSERT INTO parts_of_speech (word_id, pos) VALUES (?, ?)', 
                         (word_id, pos))
        
        # 插入词性释义
        for meaning in word_data.get('pos_meanings', []):
            cursor.execute('INSERT INTO pos_meanings (word_id, pos, meaning_cn) VALUES (?, ?, ?)',
                         (word_id, meaning['pos'], meaning['cn']))
        
        # 插入短语和对话
        for phrase_data in word_data.get('phrases', []):
            cursor.execute('INSERT INTO phrases (word_id, phrase) VALUES (?, ?)',
                         (word_id, phrase_data['phrase']))
            phrase_id = cursor.lastrowid
            
            # 插入对话（如果存在）
            dialog = phrase_data.get('dialog', {})
            if dialog:
                cursor.execute('INSERT INTO dialogs (phrase_id, speaker_a, speaker_b) VALUES (?, ?, ?)',
                             (phrase_id, dialog.get('A'), dialog.get('B')))
        
        # 插入例句
        for sentence in word_data.get('sentences', []):
            cursor.execute('INSERT INTO sentences (word_id, sentence_en, sentence_zh) VALUES (?, ?, ?)',
                         (word_id, sentence['en'], sentence['zh']))
        
        # 插入发音信息
        pronunciation = word_data.get('pronunciation', {})
        if pronunciation:
            for region, pron_data in pronunciation.items():
                if isinstance(pron_data, dict):
                    cursor.execute('INSERT INTO pronunciations (word_id, region, ipa, audio) VALUES (?, ?, ?, ?)',
                                 (word_id, region, pron_data.get('ipa'), pron_data.get('audio')))
        
        return word_id
        
    def convert(self):
        """执行转换过程"""
        # 删除现有数据库文件（如果存在）
        if os.path.exists(self.db_file):
            os.remove(self.db_file)
            print(f"删除现有数据库文件: {self.db_file}")
        
        # 加载JSON数据
        word_list = self.load_json_data()
        
        # 创建数据库连接
        with sqlite3.connect(self.db_file) as conn:
            # 创建表结构
            self.create_database_schema(conn)
            
            # 插入数据
            print("开始插入数据...")
            for i, word_data in enumerate(word_list, 1):
                self.insert_word_data(conn, word_data)
                if i % 100 == 0:
                    print(f"已处理 {i}/{len(word_list)} 个词汇")
            
            conn.commit()
            print(f"数据转换完成! 共处理 {len(word_list)} 个词汇")
            
    def query_word(self, word: str) -> Dict[str, Any]:
        """查询单词信息"""
        with sqlite3.connect(self.db_file) as conn:
            conn.row_factory = sqlite3.Row
            cursor = conn.cursor()
            
            # 获取基本词汇信息
            cursor.execute('SELECT id, word FROM words WHERE word = ?', (word,))
            word_row = cursor.fetchone()
            
            if not word_row:
                return None
                
            word_id = word_row['id']
            result = {'word': word_row['word']}
            
            # 获取词性
            cursor.execute('SELECT DISTINCT pos FROM parts_of_speech WHERE word_id = ?', (word_id,))
            result['parts_of_speech'] = [row['pos'] for row in cursor.fetchall()]
            
            # 获取词性释义
            cursor.execute('SELECT pos, meaning_cn FROM pos_meanings WHERE word_id = ?', (word_id,))
            result['pos_meanings'] = [{'pos': row['pos'], 'cn': row['meaning_cn']} 
                                     for row in cursor.fetchall()]
            
            # 获取短语和对话
            cursor.execute('''
                SELECT p.id, p.phrase, d.speaker_a, d.speaker_b 
                FROM phrases p 
                LEFT JOIN dialogs d ON p.id = d.phrase_id 
                WHERE p.word_id = ?
            ''', (word_id,))
            
            phrases = []
            for row in cursor.fetchall():
                phrase_data = {'phrase': row['phrase']}
                if row['speaker_a'] or row['speaker_b']:
                    phrase_data['dialog'] = {
                        'A': row['speaker_a'],
                        'B': row['speaker_b']
                    }
                phrases.append(phrase_data)
            result['phrases'] = phrases
            
            # 获取例句
            cursor.execute('SELECT sentence_en, sentence_zh FROM sentences WHERE word_id = ?', (word_id,))
            result['sentences'] = [{'en': row['sentence_en'], 'zh': row['sentence_zh']} 
                                  for row in cursor.fetchall()]
            
            # 获取发音
            cursor.execute('SELECT region, ipa, audio FROM pronunciations WHERE word_id = ?', (word_id,))
            pronunciation = {}
            for row in cursor.fetchall():
                pronunciation[row['region']] = {
                    'ipa': row['ipa'],
                    'audio': row['audio']
                }
            result['pronunciation'] = pronunciation
            
            return result

def main():
    """主函数"""
    json_file = "words.json"
    db_file = "words.db"
    
    if not os.path.exists(json_file):
        print(f"错误: 找不到文件 {json_file}")
        return
        
    converter = WordsConverter(json_file, db_file)
    converter.convert()
    
    # 测试查询
    print("\n测试查询...")
    test_words = ["1", "the", "be", "of", "and"]  # 一些常见词汇
    
    for test_word in test_words:
        result = converter.query_word(test_word)
        if result:
            print(f"\n找到词汇 '{test_word}':")
            print(f"  词性: {result['parts_of_speech']}")
            print(f"  释义数量: {len(result['pos_meanings'])}")
            print(f"  短语数量: {len(result['phrases'])}")
            print(f"  例句数量: {len(result['sentences'])}")
            break
    
    print(f"\n数据库文件已创建: {db_file}")

if __name__ == "__main__":
    main()