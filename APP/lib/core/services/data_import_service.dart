import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/app_database.dart';

/// 数据导入服务
/// 负责在首次启动时从assets导入预置的词汇数据
class DataImportService {
  static const String _importedKey = 'data_imported';
  static const String _versionKey = 'import_version';
  static const int _currentImportVersion = 15;  // v1.2 - 导入完整的词汇数据库
  // 版本历史:
  // v1.1 (11): 初始版本
  // v1.2 (12): 完整词汇数据库导入
  static const String _assetJsonPath = 'assets/data/main.db';

  /// 检查是否需要导入数据
  static Future<bool> needsImport() async {
    final prefs = await SharedPreferences.getInstance();
    final isMarkedAsImported = prefs.getBool(_importedKey) ?? false;
    final importVersion = prefs.getInt(_versionKey) ?? 0;

    print('🍔🍔🍔 [DataImport] 检查导入状态: 已导入=$isMarkedAsImported, 版本=$importVersion, 当前版本=$_currentImportVersion');

    // 关键修复：检查版本号，强制重新导入
    if (importVersion < _currentImportVersion) {
      print('🍔🍔🍔 [DataImport] 检测到版本升级，强制重新导入数据');
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
    await prefs.setInt(_versionKey, _currentImportVersion);  // 保存当前版本号
    print('🍔🍔🍔 [DataImport] 数据导入完成，版本: $_currentImportVersion');
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

      // 🔧 真机修复：强制清理可能冲突的数据
      print('[DataImport] 🔧 真机修复：清理旧数据...');
      await _cleanupForRealDevice(database);

      // 从数据库文件导入
      final imported = await _importFromDatabase(database);

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

  /// 真机数据清理：清除可能的冲突数据
  static Future<void> _cleanupForRealDevice(AppDatabase database) async {
    try {
      print('[DataImport] 开始真机数据清理...');

      // 1. 删除所有词汇数据
      await database.customStatement('DELETE FROM words_table');
      await database.customStatement('DELETE FROM words_fts');
      await database.customStatement('DELETE FROM favorites_table');

      // 2. 重置自增ID
      await database.customStatement('DELETE FROM sqlite_sequence WHERE name IN (\'words_table\', \'favorites_table\')');

      print('[DataImport] ✅ 真机数据清理完成');
    } catch (e) {
      print('[DataImport] ⚠️ 数据清理过程中出现警告: $e');
      // 不抛出异常，继续导入过程
    }
  }

  /// 从数据库文件导入
  static Future<bool> _importFromDatabase(AppDatabase database) async {
    try {
      print('[DataImport] 从数据库文件导入真实CET4词汇数据...');

      // 先清空现有的测试数据
      print('[DataImport] 清空现有测试数据...');
      await database.customSelect('DELETE FROM words_table').get();
      await database.customSelect('DELETE FROM words_fts').get();
      print('[DataImport] 测试数据已清空');

      // 从assets复制数据库文件到临时目录
      final tempDbPath = await _copyDatabaseFromAssets();
      if (tempDbPath == null) {
        print('[DataImport] 无法从assets复制数据库文件');
        return false;
      }

      // 连接到外部数据库并读取数据
      final externalDb = await sqlite.openDatabase(tempDbPath);

      try {
        // 首先检查外部数据库的表结构
        final tableInfo = await externalDb.rawQuery("PRAGMA table_info(words_table)");
        print('[DataImport] 外部数据库表结构: ${tableInfo.map((row) => row['name']).join(", ")}');

        // 查询外部数据库中的词汇数据
        final List<Map<String, dynamic>> externalWords = await externalDb.rawQuery('SELECT * FROM words_table ORDER BY wordRank LIMIT 5');
        print('[DataImport] 从外部数据库读取到前5个词汇作为样本');
        for (int i = 0; i < externalWords.length; i++) {
          final word = externalWords[i];
          print('[DataImport] 词汇${i + 1}: ${word.keys.join(", ")}');
        }

        // 查询总数量
        final countResult = await externalDb.rawQuery('SELECT COUNT(*) as count FROM words_table');
        final totalCount = countResult.first['count'] as int;
        print('[DataImport] 外部数据库总词汇数: $totalCount');

        if (totalCount == 0) {
          print('[DataImport] 外部数据库为空');
          return false;
        }

        // 读取所有数据
        final allWords = await externalDb.rawQuery('SELECT * FROM words_table ORDER BY wordRank');
        print('[DataImport] 成功读取所有${allWords.length} 个词汇');

        if (allWords.isEmpty) {
          print('[DataImport] 外部数据库为空');
          return false;
        }

        // 批量导入数据
        await _batchImportWords(database, allWords);

        print('[DataImport] 真实CET4词汇数据导入完成');
        return true;

      } finally {
        await externalDb.close();
        // 清理临时文件
        try {
          await File(tempDbPath).delete();
        } catch (e) {
          print('[DataImport] 清理临时文件失败: $e');
        }
      }

    } catch (e) {
      print('[DataImport] 导入过程中发生错误: $e');
      return false;
    }
  }


  /// 批量插入数据
  static Future<void> _insertBatch(AppDatabase database, List<dynamic> batch) async {
    await database.batch((batchOp) {
      for (final wordData in batch) {
        try {
          final word = wordData as Map<String, dynamic>;

          // 提取kajweb/dict格式的数据
          final wordId = _extractWordId(word);
          final bookId = word['bookId'] as String? ?? '';
          final wordRank = word['wordRank'] as int? ?? 0;
          final headWord = _extractHeadWord(word);
          final usphone = word['usphone'] as String?;
          final ukphone = word['ukphone'] as String?;
          final usspeech = word['usspeech'] as String?;
          final ukspeech = word['ukspeech'] as String?;
          final trans = _extractTrans(word);
          final sentences = _extractSentences(word);
          final phrases = _extractPhrases(word);
          final synonyms = _extractSynonyms(word);
          final relWords = _extractRelWords(word);
          final exams = _extractExams(word);

          // 生成搜索内容
          final searchContent = _generateSearchContent(word);

          batchOp.insert(
            database.wordsTable,
            WordsTableCompanion.insert(
              wordId: wordId,
              bookId: bookId,
              wordRank: wordRank,
              headWord: headWord,
              usphone: Value(usphone),
              ukphone: Value(ukphone),
              usspeech: Value(usspeech),
              ukspeech: Value(ukspeech),
              trans: Value(json.encode(trans)),
              sentences: Value(json.encode(sentences)),
              phrases: Value(json.encode(phrases)),
              synonyms: Value(json.encode(synonyms)),
              relWords: Value(json.encode(relWords)),
              exams: Value(json.encode(exams)),
              searchContent: Value(searchContent),
            ),
            mode: InsertMode.insertOrReplace,
          );
        } catch (e) {
          print('[DataImport] 插入单词失败: ${wordData['headWord']}, 错误: $e');
        }
      }
    });
  }

  /// 提取单词ID
  static String _extractWordId(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      return word?['wordId'] as String? ?? '';
    } catch (e) {
      return '';
    }
  }

  /// 提取单词本身
  static String _extractHeadWord(Map<String, dynamic> wordData) {
    try {
      // 优先使用headWord
      final headWord = wordData['headWord'] as String?;
      if (headWord != null && headWord.isNotEmpty) return headWord;

      // 从content.word.wordHead提取
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordHead = word?['wordHead'] as String?;
      return wordHead ?? '';
    } catch (e) {
      return '';
    }
  }


  /// 提取释义列表
  static List<dynamic> _extractTrans(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordContent = word?['content'] as Map<String, dynamic>?;
      return wordContent?['trans'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 提取例句列表
  static List<dynamic> _extractSentences(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordContent = word?['content'] as Map<String, dynamic>?;
      final sentence = wordContent?['sentence'] as Map<String, dynamic>?;
      return sentence?['sentences'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 提取短语列表
  static List<dynamic> _extractPhrases(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordContent = word?['content'] as Map<String, dynamic>?;
      final phrase = wordContent?['phrase'] as Map<String, dynamic>?;
      return phrase?['phrases'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 提取同近义词列表
  static List<dynamic> _extractSynonyms(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordContent = word?['content'] as Map<String, dynamic>?;
      final syno = wordContent?['syno'] as Map<String, dynamic>?;
      return syno?['synos'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 提取同根词列表
  static List<dynamic> _extractRelWords(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordContent = word?['content'] as Map<String, dynamic>?;
      final relWord = wordContent?['relWord'] as Map<String, dynamic>?;
      return relWord?['rels'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 提取考试题目列表
  static List<dynamic> _extractExams(Map<String, dynamic> wordData) {
    try {
      final content = wordData['content'] as Map<String, dynamic>?;
      final word = content?['word'] as Map<String, dynamic>?;
      final wordContent = word?['content'] as Map<String, dynamic>?;
      return wordContent?['exam'] as List<dynamic>? ?? [];
    } catch (e) {
      return [];
    }
  }

  /// 生成搜索内容
  static String _generateSearchContent(Map<String, dynamic> wordData) {
    final contentParts = <String>[];

    try {
      // 添加单词本身
      final headWord = wordData['headWord']?.toString() ?? '';
      if (headWord.isNotEmpty) {
        contentParts.add(headWord);
      }

      // 解析释义JSON并添加中文释义
      final transJson = wordData['trans']?.toString() ?? '[]';
      try {
        final transList = json.decode(transJson) as List<dynamic>;
        for (final trans in transList) {
          if (trans is Map<String, dynamic>) {
            final tranCn = trans['tranCn']?.toString() ?? '';
            if (tranCn.isNotEmpty) {
              contentParts.add(tranCn);
            }
          }
        }
      } catch (e) {
        print('[DataImport] 解析释义JSON失败: $e');
      }

      // 解析例句JSON并添加例句内容
      final sentencesJson = wordData['sentences']?.toString() ?? '[]';
      try {
        final sentencesList = json.decode(sentencesJson) as List<dynamic>;
        for (final sentence in sentencesList) {
          if (sentence is Map<String, dynamic>) {
            final sContent = sentence['sContent']?.toString() ?? '';
            final sCn = sentence['sCn']?.toString() ?? '';
            if (sContent.isNotEmpty) contentParts.add(sContent);
            if (sCn.isNotEmpty) contentParts.add(sCn);
          }
        }
      } catch (e) {
        print('[DataImport] 解析例句JSON失败: $e');
      }

    } catch (e) {
      print('[DataImport] 生成搜索内容失败: $e');
      // 至少返回单词本身
      final headWord = wordData['headWord']?.toString() ?? '';
      if (headWord.isNotEmpty) {
        contentParts.add(headWord);
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
      await database.customStatement('DELETE FROM words_fts');

      // 重置导入标记
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_importedKey, false);
      await prefs.setInt(_versionKey, _currentImportVersion - 1); // 强制触发版本升级

      // 重新导入
      return await importWordsData(database);
    } catch (e) {
      print('[DataImport] 强制重新导入失败: $e');
      return false;
    }
  }

  /// 清理数据库：删除CET6垃圾数据
  static Future<bool> cleanDatabase(AppDatabase database) async {
    try {
      print('🚮 开始清理数据库...');

      // 1. 检查当前数据状态
      final totalCount = await database.customSelect('SELECT COUNT(*) as count FROM words_table').getSingle();
      print('   清理前总词汇数: ${totalCount.data['count']}');

      // 2. 检查CET6数据
      final cet6Count = await database.customSelect('''
        SELECT COUNT(*) as count FROM words_table
        WHERE book_id LIKE '%cet6%' OR book_id LIKE '%CET6%'
      ''').getSingle();
      final cet6Data = cet6Count.data['count'] as int;

      if (cet6Data > 0) {
        print('   发现 $cet6Data 条CET6数据，开始清理...');

        // 3. 删除CET6数据
        await database.customStatement('DELETE FROM words_table WHERE book_id LIKE \'%cet6%\' OR book_id LIKE \'%CET6%\'');

        // 4. 清理FTS索引
        await database.customStatement('DELETE FROM words_fts');

        // 5. 重建FTS索引
        await database.customStatement('''
          INSERT INTO words_fts(rowid, head_word, word_id, search_content)
          SELECT id, head_word, word_id, search_content FROM words_table
        ''');

        // 6. 检查清理结果
        final afterCount = await database.customSelect('SELECT COUNT(*) as count FROM words_table').getSingle();
        final cleanedCount = (totalCount.data['count'] as int) - (afterCount.data['count'] as int);

        print('   ✔ 清理完成！删除了 $cleanedCount 条垃圾数据');
        print('   清理后总词汇数: ${afterCount.data['count']}');

        // 7. 重置导入标记，强制重新导入
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_importedKey, false);
        await prefs.setInt(_versionKey, _currentImportVersion - 1);

        return true;
      } else {
        print('   ✔ 未发现CET6垃圾数据，数据库已干净');
        return true;
      }

    } catch (e) {
      print('[DataImport] 数据库清理失败: $e');
      return false;
    }
  }

  /// 完全重置数据库：清空所有数据并重新导入
  static Future<bool> fullReset(AppDatabase database) async {
    try {
      print('🔄 开始完全重置数据库...');

      // 1. 清空所有数据
      await database.customStatement('DELETE FROM words_table');
      await database.customStatement('DELETE FROM words_fts');

      // 2. 重置导入标记
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_importedKey, false);
      await prefs.setInt(_versionKey, _currentImportVersion - 1);

      print('   ✔ 数据库已完全重置');

      // 3. 重新导入
      return await importWordsData(database);

    } catch (e) {
      print('[DataImport] 数据库重置失败: $e');
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
        INSERT INTO words_fts(rowid, headWord, wordId, search_content)
        SELECT id, headWord, wordId, searchContent FROM words_table
      ''');

      // 4. 确认同步结果
      final ftsCount = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_fts'
      ).getSingle();
      final mainCount = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table'
      ).getSingle();

      if (ftsCount.data['count'] != mainCount.data['count']) {
        throw Exception('FTS5同步不完整 ${ftsCount.data['count']}/${mainCount.data['count']}');
      }

      print('[DataImport] FTS5数据同步完成: ${ftsCount.data['count']} 条记录');
    } catch (e) {
      print('[DataImport] FTS5数据同步失败: $e');
      rethrow; // 关键修复：抛出异常，不掩盖错误
    }
  }

  /// 从assets复制数据库文件到临时目录
  static Future<String?> _copyDatabaseFromAssets() async {
    try {
      // 修复：在Windows平台初始化databaseFactory
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      // 从assets读取数据库文件
      print('[DataImport] 开始从assets读取数据库文件...');
      final byteData = await rootBundle.load('assets/data/main.db');
      final bytes = byteData.buffer.asUint8List();
      print('[DataImport] 成功读取数据库文件，大小: ${bytes.length} bytes');

      // 在真机上优先使用应用文档目录而不是临时目录
      Directory tempDir;
      if (Platform.isAndroid || Platform.isIOS) {
        // 真机上使用应用文档目录
        tempDir = await getApplicationDocumentsDirectory();
        print('[DataImport] 使用应用文档目录: ${tempDir.path}');
      } else {
        // 桌面平台使用临时目录
        tempDir = await getTemporaryDirectory();
        print('[DataImport] 使用临时目录: ${tempDir.path}');
      }

      final tempDbPath = p.join(tempDir.path, 'temp_cet4_words_${DateTime.now().millisecondsSinceEpoch}.db');

      // 写入临时文件
      print('[DataImport] 写入临时文件: $tempDbPath');
      final file = File(tempDbPath);
      await file.writeAsBytes(bytes);

      // 验证文件是否成功写入
      if (await file.exists()) {
        final fileSize = await file.length();
        print('[DataImport] ✅ 数据库文件已成功复制，大小: $fileSize bytes');
        return tempDbPath;
      } else {
        print('[DataImport] ❌ 临时文件创建失败');
        return null;
      }

    } catch (e) {
      print('[DataImport] ❌ 复制数据库文件失败: $e');
      print('[DataImport] 错误堆栈: ${StackTrace.current}');
      return null;
    }
  }

  /// 批量导入词汇数据
  static Future<void> _batchImportWords(AppDatabase database, List<Map<String, dynamic>> externalWords) async {
    print('[DataImport] 开始批量导入词汇数据...');

    // 收集所有要插入的数据
    final List<WordsTableCompanion> companions = [];

    for (int i = 0; i < externalWords.length; i++) {
      final word = externalWords[i];

      try {
        // 字段映射和数据转换
        final companion = WordsTableCompanion.insert(
          wordId: word['wordId']?.toString() ?? '',
          bookId: word['bookId']?.toString() ?? '',
          wordRank: (word['wordRank'] as int?) ?? 0,
          headWord: word['headWord']?.toString() ?? '', // 修复：使用正确的字段名headWord
          usphone: Value(word['usphone'] as String?),
          ukphone: Value(word['ukphone'] as String?),
          usspeech: Value(word['usspeech'] as String?),
          ukspeech: Value(word['ukspeech'] as String?),
          trans: Value(word['trans']?.toString() ?? '[]'),
          sentences: Value(word['sentences']?.toString() ?? '[]'),
          phrases: Value(word['phrases']?.toString() ?? '[]'),
          synonyms: Value(word['synonyms']?.toString() ?? '[]'),
          relWords: Value(word['relWords']?.toString() ?? '[]'),
          exams: Value(word['exams']?.toString() ?? '[]'),
          searchContent: Value(_generateSearchContent(word)),
        );

        companions.add(companion);

        // 每1000条处理一次
        if ((i + 1) % 1000 == 0) {
          print('[DataImport] 已处理${i + 1} 条数据...');
        }

      } catch (e) {
        print('[DataImport] 处理词汇数据时出错(索引 $i): $e');
        print('[DataImport] 问题数据: $word');
      }
    }

    // 批量插入所有数据
    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(database.wordsTable, companions);
    });

    print('[DataImport] 批量插入完成');
  }
}