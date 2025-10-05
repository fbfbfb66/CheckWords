#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
deploy_to_app.py - 自动化部署脚本

功能：
1. 读取 Resource/words.db 中的规范化数据
2. 转换为 APP 需要的扁平化 JSON 格式
3. 创建适合 APP 导入的 SQLite 数据库
4. 自动复制到 APP 的 assets/data/ 目录
"""

import os
import sys
import json
import sqlite3
import shutil
from datetime import datetime
from pathlib import Path

# 配置
SCRIPT_DIR = Path(__file__).parent
RESOURCE_DB = SCRIPT_DIR / "words.db"
APP_DIR = SCRIPT_DIR.parent / "APP"
APP_ASSETS_DATA = APP_DIR / "assets" / "data"
OUTPUT_DB = APP_ASSETS_DATA / "words.db"
OUTPUT_JSON = APP_ASSETS_DATA / "words_seed.json"

def connect_resource_db():
    """连接Resource数据库"""
    if not RESOURCE_DB.exists():
        raise FileNotFoundError(f"Resource数据库不存在: {RESOURCE_DB}")
    
    conn = sqlite3.connect(RESOURCE_DB)
    conn.row_factory = sqlite3.Row  # 使结果可以按列名访问
    return conn

def convert_words_data():
    """从Resource数据库读取并转换数据为APP格式"""
    print("[INFO] 读取Resource数据库...")
    conn = connect_resource_db()
    
    try:
        # 查询所有单词数据
        cursor = conn.execute("""
            SELECT w.id, w.word
            FROM words w
            ORDER BY w.word
        """)
        words = cursor.fetchall()
        
        converted_words = []
        total = len(words)
        
        print(f"[INFO] 找到 {total} 个单词，开始转换...")
        
        for i, word_row in enumerate(words):
            word_id = word_row['id']
            word = word_row['word']
            
            if (i + 1) % 100 == 0:
                print(f"   处理进度: {i + 1}/{total} ({(i+1)/total*100:.1f}%)")
            
            # 获取词性
            pos_cursor = conn.execute(
                "SELECT pos FROM parts_of_speech WHERE word_id = ?", 
                (word_id,)
            )
            parts_of_speech = [row['pos'] for row in pos_cursor.fetchall()]
            
            # 获取词性含义
            meaning_cursor = conn.execute(
                "SELECT pos, meaning_cn FROM pos_meanings WHERE word_id = ?", 
                (word_id,)
            )
            pos_meanings = []
            for row in meaning_cursor.fetchall():
                pos_meanings.append({
                    "pos": row['pos'],
                    "cn": row['meaning_cn']
                })
            
            # 获取短语和对话
            phrase_cursor = conn.execute(
                """
                SELECT p.phrase, d.speaker_a, d.speaker_b
                FROM phrases p
                LEFT JOIN dialogs d ON p.id = d.phrase_id
                WHERE p.word_id = ?
                """, 
                (word_id,)
            )
            phrases = []
            for row in phrase_cursor.fetchall():
                phrase_data = {
                    "phrase": row['phrase'],
                    "dialog": {
                        "A": row['speaker_a'] or "",
                        "B": row['speaker_b'] or ""
                    }
                }
                phrases.append(phrase_data)
            
            # 获取例句
            sentence_cursor = conn.execute(
                "SELECT sentence_en, sentence_zh FROM sentences WHERE word_id = ?", 
                (word_id,)
            )
            sentences = []
            for row in sentence_cursor.fetchall():
                sentences.append({
                    "en": row['sentence_en'],
                    "cn": row['sentence_zh']
                })
            
            # 获取音标
            pron_cursor = conn.execute(
                "SELECT region, ipa, audio FROM pronunciations WHERE word_id = ?", 
                (word_id,)
            )
            pronunciation = {"US": {"ipa": None, "audio": None}}
            for row in pron_cursor.fetchall():
                region = row['region'] or 'US'
                pronunciation[region] = {
                    "ipa": row['ipa'],
                    "audio": row['audio']
                }
            
            # 构建最终数据
            word_data = {
                "word": word,
                "parts_of_speech": parts_of_speech,
                "pos_meanings": pos_meanings,
                "phrases": phrases,
                "sentences": sentences,
                "pronunciation": pronunciation
            }
            
            converted_words.append(word_data)
        
        print(f"[SUCCESS] 转换完成: {len(converted_words)} 个单词")
        return converted_words
        
    finally:
        conn.close()

def create_app_compatible_db(words_data):
    """创建APP兼容的SQLite数据库"""
    print("[INFO] 创建APP兼容数据库...")
    
    # 确保目标目录存在
    APP_ASSETS_DATA.mkdir(parents=True, exist_ok=True)
    
    # 删除已存在的数据库
    if OUTPUT_DB.exists():
        OUTPUT_DB.unlink()
    
    # 创建新数据库
    conn = sqlite3.connect(OUTPUT_DB)
    
    try:
        # 创建words_table
        conn.execute("""
            CREATE TABLE words_table (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                word TEXT NOT NULL UNIQUE,
                lemma TEXT,
                parts_of_speech TEXT NOT NULL,
                pos_meanings TEXT NOT NULL,
                phrases TEXT NOT NULL,
                sentences TEXT NOT NULL,
                pronunciation TEXT NOT NULL,
                level TEXT,
                frequency INTEGER DEFAULT 0,
                tags TEXT DEFAULT '[]',
                synonyms TEXT DEFAULT '[]',
                antonyms TEXT DEFAULT '[]',
                content TEXT NOT NULL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # 创建索引
        conn.execute("CREATE INDEX idx_words_frequency ON words_table(frequency DESC)")
        conn.execute("CREATE INDEX idx_words_level ON words_table(level)")
        conn.execute("CREATE UNIQUE INDEX idx_words_word ON words_table(word)")
        
        # 插入数据
        total = len(words_data)
        for i, word in enumerate(words_data):
            if (i + 1) % 100 == 0:
                print(f"   写入进度: {i + 1}/{total} ({(i+1)/total*100:.1f}%)")
            
            # 生成搜索内容
            search_content = []
            search_content.append(word['word'])
            
            # 添加中文含义到搜索内容
            for meaning in word.get('pos_meanings', []):
                search_content.append(meaning.get('cn', ''))
            
            # 添加例句到搜索内容
            for sentence in word.get('sentences', []):
                search_content.append(sentence.get('en', ''))
                search_content.append(sentence.get('cn', ''))
            
            content_text = ' '.join(filter(None, search_content))
            
            # 插入数据
            conn.execute("""
                INSERT INTO words_table (
                    word, lemma, parts_of_speech, pos_meanings, 
                    phrases, sentences, pronunciation, content
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                word['word'],
                word['word'],  # lemma暂时与word相同
                json.dumps(word.get('parts_of_speech', []), ensure_ascii=False),
                json.dumps(word.get('pos_meanings', []), ensure_ascii=False),
                json.dumps(word.get('phrases', []), ensure_ascii=False),
                json.dumps(word.get('sentences', []), ensure_ascii=False),
                json.dumps(word.get('pronunciation', {}), ensure_ascii=False),
                content_text
            ))
        
        conn.commit()
        print(f"[SUCCESS] 数据库创建完成: {OUTPUT_DB}")
        print(f"[INFO] 共写入 {total} 个单词")
        
    finally:
        conn.close()

def save_json_seed(words_data):
    """保存JSON种子文件（可选）"""
    print("[INFO] 保存JSON种子文件...")
    
    with open(OUTPUT_JSON, 'w', encoding='utf-8') as f:
        json.dump(words_data, f, ensure_ascii=False, indent=2)
    
    file_size = OUTPUT_JSON.stat().st_size / 1024 / 1024  # MB
    print(f"[SUCCESS] JSON文件保存完成: {OUTPUT_JSON}")
    print(f"[INFO] 文件大小: {file_size:.2f} MB")

def update_app_pubspec():
    """更新APP的pubspec.yaml以包含数据文件"""
    pubspec_path = APP_DIR / "pubspec.yaml"
    
    if not pubspec_path.exists():
        print("[WARNING] 未找到APP的pubspec.yaml文件")
        return
    
    print("[INFO] 检查APP pubspec.yaml配置...")
    
    with open(pubspec_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 检查是否已经包含assets/data/配置
    if 'assets/data/' in content:
        print("[SUCCESS] pubspec.yaml已包含assets/data/配置")
    else:
        print("[WARNING] pubspec.yaml缺少assets/data/配置，请手动添加到assets部分")
        print("   建议添加: - assets/data/")

def create_deployment_info():
    """创建部署信息文件"""
    info = {
        "deployment_time": datetime.now().isoformat(),
        "source_db": str(RESOURCE_DB),
        "words_count": 0,  # 将在main中更新
        "app_db": str(OUTPUT_DB),
        "app_json": str(OUTPUT_JSON)
    }
    
    # 获取单词数量
    try:
        conn = sqlite3.connect(OUTPUT_DB)
        cursor = conn.execute("SELECT COUNT(*) FROM words_table")
        info["words_count"] = cursor.fetchone()[0]
        conn.close()
    except:
        pass
    
    info_file = APP_ASSETS_DATA / "deployment_info.json"
    with open(info_file, 'w', encoding='utf-8') as f:
        json.dump(info, f, ensure_ascii=False, indent=2)
    
    print(f"[INFO] 部署信息已保存: {info_file}")

def validate_deployment():
    """验证部署结果"""
    print("\n" + "="*60)
    print("[INFO] 验证部署结果...")
    
    errors = []
    
    # 检查文件是否存在
    if not OUTPUT_DB.exists():
        errors.append(f"数据库文件不存在: {OUTPUT_DB}")
    
    if not OUTPUT_JSON.exists():
        errors.append(f"JSON文件不存在: {OUTPUT_JSON}")
    
    # 检查数据库内容
    if OUTPUT_DB.exists():
        try:
            conn = sqlite3.connect(OUTPUT_DB)
            cursor = conn.execute("SELECT COUNT(*) FROM words_table")
            count = cursor.fetchone()[0]
            
            if count == 0:
                errors.append("数据库中没有词汇数据")
            else:
                print(f"[SUCCESS] 数据库验证通过: {count} 个单词")
            
            # 检查数据样本
            cursor = conn.execute("SELECT word, parts_of_speech, content FROM words_table LIMIT 3")
            samples = cursor.fetchall()
            print("[INFO] 数据样本:")
            for word, pos, content in samples:
                print(f"   - {word}: {pos[:50]}...")
            
            conn.close()
        except Exception as e:
            errors.append(f"数据库验证失败: {e}")
    
    if errors:
        print("[ERROR] 验证发现问题:")
        for error in errors:
            print(f"   - {error}")
        return False
    else:
        print("[SUCCESS] 所有验证通过!")
        return True

def main():
    """主流程"""
    print("开始自动化部署到APP...")
    print("="*60)
    
    try:
        # 1. 转换数据
        words_data = convert_words_data()
        
        # 2. 创建APP兼容数据库
        create_app_compatible_db(words_data)
        
        # 3. 保存JSON种子文件（可选）
        save_json_seed(words_data)
        
        # 4. 更新APP配置
        update_app_pubspec()
        
        # 5. 创建部署信息
        create_deployment_info()
        
        # 6. 验证部署结果
        success = validate_deployment()
        
        if success:
            print("\n" + "="*60)
            print("[SUCCESS] 部署成功!")
            print(f"[INFO] APP数据库: {OUTPUT_DB}")
            print(f"[INFO] JSON种子: {OUTPUT_JSON}")
            print("\n[INFO] 使用说明:")
            print("1. 在APP中实现数据库初始化逻辑")
            print("2. 首次启动时从assets/data/words.db导入数据")
            print("3. 或使用words_seed.json进行批量导入")
            print("\n[INFO] 重新部署:")
            print("   python Resource/deploy_to_app.py")
        else:
            print("\n[ERROR] 部署失败，请检查错误信息")
            return False
            
    except Exception as e:
        print(f"[ERROR] 部署过程中发生错误: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)