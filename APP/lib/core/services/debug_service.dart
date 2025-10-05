import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';
import 'data_import_service.dart';

/// 调试服务
/// 提供应用调试和诊断功能
class DebugService {
  /// 获取应用状态诊断信息
  static Future<Map<String, dynamic>> getDiagnostics(AppDatabase database) async {
    final diagnostics = <String, dynamic>{};

    try {
      // 数据导入状态
      final importStatus = await DataImportService.getImportStatus(database);
      diagnostics['data_import'] = importStatus;

      // 数据库统计
      final stats = await _getDatabaseStats(database);
      diagnostics['database'] = stats;

      // 系统信息
      diagnostics['system'] = {
        'flutter_version': 'Flutter 3.x',
        'dart_version': 'Dart 3.x',
      };

    } catch (e) {
      diagnostics['error'] = e.toString();
    }

    return diagnostics;
  }

  /// 获取数据库统计信息
  static Future<Map<String, dynamic>> _getDatabaseStats(AppDatabase database) async {
    try {
      // 单词数量
      final wordsResult = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table',
      ).getSingle();
      final wordsCount = wordsResult.data['count'] as int;

      // 用户数量
      int usersCount = 0;
      try {
        final usersResult = await database.customSelect(
          'SELECT COUNT(*) as count FROM users_table',
        ).getSingle();
        usersCount = usersResult.data['count'] as int;
      } catch (e) {
        // 用户表可能不存在，忽略错误
      }

      // 数据库大小（近似）
      final sizeResult = await database.customSelect(
        "SELECT SUM(pgsize) as size FROM dbstat WHERE name='words_table'",
      ).getSingleOrNull();
      final dbSize = sizeResult?.data['size'] as int? ?? 0;

      return {
        'words_count': wordsCount,
        'users_count': usersCount,
        'database_size_bytes': dbSize,
        'database_size_mb': (dbSize / 1024 / 1024).toStringAsFixed(2),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// 执行数据库维护
  static Future<Map<String, dynamic>> performMaintenance(AppDatabase database) async {
    final results = <String, dynamic>{};

    try {
      // VACUUM操作（压缩数据库）
      await database.customStatement('VACUUM');
      results['vacuum'] = '成功';

      // ANALYZE操作（更新统计信息）
      await database.customStatement('ANALYZE');
      results['analyze'] = '成功';

      // 重建FTS索引
      await database.customStatement('INSERT INTO words_fts(words_fts) VALUES("rebuild")');
      results['fts_rebuild'] = '成功';

    } catch (e) {
      results['error'] = e.toString();
    }

    return results;
  }

  /// 强制重新导入数据
  static Future<bool> forceReimport(AppDatabase database) async {
    return await DataImportService.forceReimport(database);
  }

  /// 测试搜索功能
  static Future<Map<String, dynamic>> testSearchFunction(
    AppDatabase database, 
    String testQuery
  ) async {
    final results = <String, dynamic>{};
    
    try {
      // 1. 检查数据库中是否有数据
      final totalWords = await database.customSelect(
        'SELECT COUNT(*) as count FROM words_table',
      ).getSingle();
      results['total_words'] = totalWords.data['count'];
      
      if ((totalWords.data['count'] as int) == 0) {
        results['error'] = '数据库中没有单词数据，请先导入数据';
        return results;
      }

      // 2. 获取前5个单词样本
      final samples = await database.customSelect(
        'SELECT word, lemma FROM words_table LIMIT 5',
      ).get();
      results['sample_words'] = samples.map((row) => row.data['word']).toList();

      // 3. 测试FTS5表是否存在
      try {
        final ftsCheck = await database.customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='words_fts'",
        ).getSingleOrNull();
        results['fts5_table_exists'] = ftsCheck != null;
        
        if (ftsCheck != null) {
          // 4. 检查FTS5表中的数据量
          final ftsCount = await database.customSelect(
            'SELECT COUNT(*) as count FROM words_fts',
          ).getSingle();
          results['fts5_count'] = ftsCount.data['count'];
        }
      } catch (e) {
        results['fts5_error'] = e.toString();
      }

      // 5. 测试FTS5搜索
      if (testQuery.isNotEmpty) {
        try {
          final ftsResults = await database.customSelect(
            '''
            SELECT w.word FROM words_table w
            INNER JOIN words_fts fts ON w.id = fts.rowid
            WHERE words_fts MATCH ? 
            LIMIT 5
            ''',
            variables: [drift.Variable.withString(testQuery)],
          ).get();
          results['fts5_results'] = ftsResults.map((row) => row.data['word']).toList();
        } catch (e) {
          results['fts5_search_error'] = e.toString();
        }

        // 6. 测试LIKE搜索作为备选
        try {
          final likeResults = await database.customSelect(
            '''
            SELECT word FROM words_table 
            WHERE word LIKE ? OR lemma LIKE ? 
            LIMIT 5
            ''',
            variables: [
              drift.Variable.withString('%$testQuery%'),
              drift.Variable.withString('%$testQuery%'),
            ],
          ).get();
          results['like_results'] = likeResults.map((row) => row.data['word']).toList();
        } catch (e) {
          results['like_search_error'] = e.toString();
        }

        // 7. 测试精确匹配
        try {
          final exactResults = await database.customSelect(
            'SELECT word FROM words_table WHERE word = ? OR lemma = ?',
            variables: [
              drift.Variable.withString(testQuery),
              drift.Variable.withString(testQuery),
            ],
          ).get();
          results['exact_results'] = exactResults.map((row) => row.data['word']).toList();
        } catch (e) {
          results['exact_search_error'] = e.toString();
        }
      }

    } catch (e) {
      results['general_error'] = e.toString();
    }

    return results;
  }

  /// 重建FTS5索引
  static Future<bool> rebuildFTS5Index(AppDatabase database) async {
    try {
      // 删除现有的FTS表
      await database.customStatement('DROP TABLE IF EXISTS words_fts');
      
      // 重新创建FTS5虚拟表（使用新的简化结构）
      await database.customStatement('''
        CREATE VIRTUAL TABLE words_fts USING fts5(
          word,
          lemma,
          search_content
        );
      ''');

      // 从主表同步数据到FTS5表，确保rowid对应
      await database.customStatement('''
        INSERT INTO words_fts(rowid, word, lemma, search_content)
        SELECT id, word, lemma, content FROM words_table
      ''');
      
      return true;
    } catch (e) {
      print('重建FTS5索引失败: $e');
      return false;
    }
  }

  /// 导出诊断报告
  static String formatDiagnosticsReport(Map<String, dynamic> diagnostics) {
    final buffer = StringBuffer();
    buffer.writeln('CheckWords 诊断报告');
    buffer.writeln('=' * 40);
    buffer.writeln('生成时间: ${DateTime.now()}');
    buffer.writeln();

    // 数据导入状态
    if (diagnostics.containsKey('data_import')) {
      buffer.writeln('数据导入状态:');
      final importStatus = diagnostics['data_import'] as Map<String, dynamic>;
      for (final entry in importStatus.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value}');
      }
      buffer.writeln();
    }

    // 数据库统计
    if (diagnostics.containsKey('database')) {
      buffer.writeln('数据库统计:');
      final dbStats = diagnostics['database'] as Map<String, dynamic>;
      for (final entry in dbStats.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value}');
      }
      buffer.writeln();
    }

    // 系统信息
    if (diagnostics.containsKey('system')) {
      buffer.writeln('系统信息:');
      final systemInfo = diagnostics['system'] as Map<String, dynamic>;
      for (final entry in systemInfo.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value}');
      }
      buffer.writeln();
    }

    // 错误信息
    if (diagnostics.containsKey('error')) {
      buffer.writeln('错误信息:');
      buffer.writeln('  ${diagnostics['error']}');
    }

    return buffer.toString();
  }
}