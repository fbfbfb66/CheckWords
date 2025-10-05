import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// 数据导入服务
/// 负责在首次启动时从assets导入预置的词汇数据
class DataImportService {
  static const String _importedKey = 'data_imported';
  static const String _versionKey = 'import_version';
  static const int _currentImportVersion = 6;  // 🚨 升级：强制重新导入
  static const String _assetJsonPath = 'assets/data/words_seed.json';

  /// 检查是否需要导入数据
  static Future<bool> needsImport() async {
    final prefs = await SharedPreferences.getInstance();
    final isMarkedAsImported = prefs.getBool(_importedKey) ?? false;
    final importVersion = prefs.getInt(_versionKey) ?? 0;

    print('🚨🚨🚨 [DataImport] 检查导入状态: 已导入=$isMarkedAsImported, 版本=$importVersion, 当前版本=$_currentImportVersion');

    // 🚨 关键修复：检查版本号，强制重新导入
    if (importVersion < _currentImportVersion) {
      print('🚨🚨🚨 [DataImport] 检测到版本升级，强制重新导入数据');
      await prefs.setBool(_importedKey, false);
      await prefs.setInt(_versionKey, _currentImportVersion);
      return true;
    }

    // 检查数据库是否实际有数据
    if (isMarkedAsImported) {
      try {
        final database = AppDatabase.instance;
        final count = await database.customSelect('SELECT COUNT(*) as count FROM words_table').getSingle();
        final hasData = (count.data['count'] as int) > 0;

        if (!hasData) {
          // 标记为已导入但没有数据，重置标记
          await prefs.setBool(_importedKey, false);
          print('[DataImport] 检测到数据缺失，重置导入标记');
          return true;
        }
      } catch (e) {
        print('[DataImport] 检查数据状态失败: $e');
        return true; // 出错时重新导入
      }
    }

    return !isMarkedAsImported;
  }

  /// 标记数据已导入
  static Future<void> markAsImported() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_importedKey, true);
    await prefs.setInt(_versionKey, _currentImportVersion);  // 🚨 保存当前版本号
    print('🚨🚨🚨 [DataImport] 数据导入完成，版本: $_currentImportVersion');
  }

  /// 从assets导入预置的词汇数据
  static Future<bool> importWordsData(AppDatabase database) async {
    try {
      print('[DataImport] 开始导入词汇数据...');
      
      // 检查是否需要导入
      if (!await needsImport()) {
        print('[DataImport] 数据已导入，跳过导入过程');
        return true;
      }

      // 从JSON文件导入
      final imported = await _importFromJson(database);

      if (imported) {
        await markAsImported();
        print('[DataImport] 词汇数据导入完成');
      } else {
        print('[DataImport] 词汇数据导入失败');
      }

      return imported;
    } catch (e) {
      print('[DataImport] 导入过程中发生错误: $e');
      return false;
    }
  }

  /// 从JSON文件导入
  static Future<bool> _importFromJson(AppDatabase database) async {
    try {
      print('[DataImport] 从JSON文件导入...');

      // 从assets读取JSON文件
      final jsonString = await rootBundle.loadString(_assetJsonPath);
      final List<dynamic> wordsData = json.decode(jsonString);

      if (wordsData.isEmpty) {
        print('[DataImport] JSON文件为空');
        return false;
      }

      print('[DataImport] 找到 ${wordsData.length} 个单词，开始批量导入...');

      // 分批处理，避免内存问题
      const batchSize = 100;
      for (int i = 0; i < wordsData.length; i += batchSize) {
        final end = (i + batchSize < wordsData.length) ? i + batchSize : wordsData.length;
        final batch = wordsData.sublist(i, end);
        
        await _insertBatch(database, batch);
        
        if (i % 500 == 0) {
          print('[DataImport] 已处理: ${i + batch.length}/${wordsData.length}');
        }
      }

      print('[DataImport] JSON文件导入成功，开始同步FTS5索引...');
      
      // 手动同步FTS5数据（因为批量导入时触发器可能未执行）
      await _syncFTS5Data(database);
      
      print('[DataImport] FTS5索引同步完成');
      return true;
    } catch (e) {
      print('[DataImport] JSON文件导入失败: $e');
      return false;
    }
  }

  /// 批量插入数据
  static Future<void> _insertBatch(AppDatabase database, List<dynamic> batch) async {
    await database.batch((batchOp) {
      for (final wordData in batch) {
        try {
          final word = wordData as Map<String, dynamic>;
          
          // 生成搜索内容
          final searchContent = _generateSearchContent(word);
          
          batchOp.insert(
            database.wordsTable,
            WordsTableCompanion.insert(
              word: word['word'] as String,
              lemma: Value(word['word'] as String), // lemma暂时等于word
              partsOfSpeech: Value(json.encode(word['parts_of_speech'] ?? [])),
              posMeanings: Value(json.encode(word['pos_meanings'] ?? [])),
              phrases: Value(json.encode(word['phrases'] ?? [])),
              sentences: Value(json.encode(word['sentences'] ?? [])),
              pronunciation: Value(json.encode(word['pronunciation'] ?? {})),
              tags: Value(json.encode(word['tags'] ?? [])),
              synonyms: Value(json.encode(word['synonyms'] ?? [])),
              antonyms: Value(json.encode(word['antonyms'] ?? [])),
              content: Value(searchContent),
            ),
            mode: InsertMode.insertOrReplace,
          );
        } catch (e) {
          print('[DataImport] 插入单词失败: ${wordData['word']}, 错误: $e');
        }
      }
    });
  }

  /// 生成搜索内容
  static String _generateSearchContent(Map<String, dynamic> wordData) {
    final contentParts = <String>[];
    
    // 添加单词本身
    contentParts.add(wordData['word'] as String);
    
    // 添加中文释义
    final posMeanings = wordData['pos_meanings'] as List<dynamic>?;
    if (posMeanings != null) {
      for (final meaning in posMeanings) {
        if (meaning is Map<String, dynamic>) {
          final cn = meaning['cn'] as String?;
          if (cn != null && cn.isNotEmpty) {
            contentParts.add(cn);
          }
        }
      }
    }
    
    // 添加例句
    final sentences = wordData['sentences'] as List<dynamic>?;
    if (sentences != null) {
      for (final sentence in sentences) {
        if (sentence is Map<String, dynamic>) {
          final en = sentence['en'] as String?;
          final cn = sentence['cn'] as String?;
          if (en != null && en.isNotEmpty) contentParts.add(en);
          if (cn != null && cn.isNotEmpty) contentParts.add(cn);
        }
      }
    }
    
    return contentParts.join(' ');
  }

  /// 获取导入状态信息
  static Future<Map<String, dynamic>> getImportStatus(AppDatabase database) async {
    try {
      final isImported = !await needsImport();
      final wordsCount = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table',
      ).getSingle();

      return {
        'imported': isImported,
        'words_count': wordsCount.data['count'] as int,
        'has_asset_json': await _hasAssetFile(_assetJsonPath),
      };
    } catch (e) {
      return {
        'imported': false,
        'words_count': 0,
        'has_asset_json': false,
        'error': e.toString(),
      };
    }
  }

  /// 检查assets文件是否存在
  static Future<bool> _hasAssetFile(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 强制重新导入数据（用于调试）
  static Future<bool> forceReimport(AppDatabase database) async {
    try {
      print('[DataImport] 开始强制重新导入...');
      
      // 清空现有数据
      await database.customStatement('DELETE FROM words_table');
      
      // 重置导入标记
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_importedKey, false);
      
      // 重新导入
      return await importWordsData(database);
    } catch (e) {
      print('[DataImport] 强制重新导入失败: $e');
      return false;
    }
  }

  /// 手动同步FTS5数据
  static Future<void> _syncFTS5Data(AppDatabase database) async {
    try {
      // 1. 检查FTS5表是否存在
      final ftsExists = await database.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='words_fts'"
      ).get();

      if (ftsExists.isEmpty) {
        throw Exception('FTS5表不存在，需要重建数据库');
      }

      // 2. 清空FTS5表
      await database.customStatement('DELETE FROM words_fts');

      // 3. 同步数据并验证
      await database.customStatement('''
        INSERT INTO words_fts(rowid, word, lemma, search_content)
        SELECT id, word, lemma, content FROM words_table
      ''');

      // 4. 验证同步结果
      final ftsCount = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_fts'
      ).getSingle();
      final mainCount = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table'
      ).getSingle();

      if (ftsCount.data['count'] != mainCount.data['count']) {
        throw Exception('FTS5同步不完整: ${ftsCount.data['count']}/${mainCount.data['count']}');
      }

      print('[DataImport] FTS5数据同步完成: ${ftsCount.data['count']} 条记录');
    } catch (e) {
      print('[DataImport] FTS5数据同步失败: $e');
      rethrow; // 关键修复：抛出异常，不掩盖错误
    }
  }
}