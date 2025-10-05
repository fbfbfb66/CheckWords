import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/words_table.dart';
import 'tables/users_table.dart';
import 'tables/user_words_table.dart';
import 'tables/search_history_table.dart';

part 'app_database.g.dart';

/// 应用数据库类
@DriftDatabase(
  tables: [
    WordsTable,
    UsersTable,
    UserWordsTable,
    SearchHistoryTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;

  /// 获取数据库单例实例
  static Future<AppDatabase> initialize() async {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  /// 获取数据库实例
  static AppDatabase get instance {
    if (_instance == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  @override
  int get schemaVersion => 6; // 🚨 强制升级：修复搜索排序问题

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // 创建所有表
        await m.createAll();

        // 创建FTS5虚拟表用于全文搜索
        await customStatement('''
          CREATE VIRTUAL TABLE words_fts USING fts5(
            word,
            lemma,
            search_content
          );
        ''');

        // 创建触发器保持FTS表同步
        await customStatement('''
          CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
            INSERT INTO words_fts(rowid, word, lemma, search_content) 
            VALUES (new.id, new.word, new.lemma, new.content);
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER words_fts_delete AFTER DELETE ON words_table BEGIN
            DELETE FROM words_fts WHERE rowid = old.id;
          END;
        ''');

        await customStatement('''
          CREATE TRIGGER words_fts_update AFTER UPDATE ON words_table BEGIN
            DELETE FROM words_fts WHERE rowid = old.id;
            INSERT INTO words_fts(rowid, word, lemma, search_content) 
            VALUES (new.id, new.word, new.lemma, new.content);
          END;
        ''');

        // 创建索引
        await customStatement(
            'CREATE INDEX idx_words_frequency ON words_table(frequency DESC);');
        await customStatement(
            'CREATE INDEX idx_words_level ON words_table(level);');
        await customStatement(
            'CREATE INDEX idx_user_words_user_id ON user_words_table(user_id);');
        await customStatement(
            'CREATE INDEX idx_user_words_word_id ON user_words_table(word_id);');
        await customStatement(
            'CREATE INDEX idx_search_history_user_id ON search_history_table(user_id);');
        await customStatement(
            'CREATE INDEX idx_search_history_timestamp ON search_history_table(timestamp DESC);');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 从版本1升级到版本2：重建FTS5表
        if (from == 1 && to >= 2) {
          print('[Database] 升级数据库：重建FTS5搜索索引...');

          // 删除旧的FTS5表和触发器
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('DROP TRIGGER IF EXISTS words_fts_insert');
          await customStatement('DROP TRIGGER IF EXISTS words_fts_delete');
          await customStatement('DROP TRIGGER IF EXISTS words_fts_update');

          // 创建新的FTS5表
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              word,
              lemma,
              search_content
            );
          ''');

          // 创建新的触发器
          await customStatement('''
            CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
              INSERT INTO words_fts(rowid, word, lemma, search_content) 
              VALUES (new.id, new.word, new.lemma, new.content);
            END;
          ''');

          await customStatement('''
            CREATE TRIGGER words_fts_delete AFTER DELETE ON words_table BEGIN
              DELETE FROM words_fts WHERE rowid = old.id;
            END;
          ''');

          await customStatement('''
            CREATE TRIGGER words_fts_update AFTER UPDATE ON words_table BEGIN
              DELETE FROM words_fts WHERE rowid = old.id;
              INSERT INTO words_fts(rowid, word, lemma, search_content) 
              VALUES (new.id, new.word, new.lemma, new.content);
            END;
          ''');

          // 同步现有数据到FTS5表
          await customStatement('''
            INSERT INTO words_fts(rowid, word, lemma, search_content)
            SELECT id, word, lemma, content FROM words_table
          ''');

          print('[Database] FTS5索引重建完成');
        }

        // 从版本2升级到版本3：修复FTS5 rowid关联
        if (from == 2 && to == 3) {
          print('[Database] 升级数据库：修复FTS5 rowid关联...');

          // 删除旧的FTS5表和触发器
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('DROP TRIGGER IF EXISTS words_fts_insert');
          await customStatement('DROP TRIGGER IF EXISTS words_fts_delete');
          await customStatement('DROP TRIGGER IF EXISTS words_fts_update');

          // 创建新的FTS5表
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              word,
              lemma,
              search_content
            );
          ''');

          // 创建新的触发器（使用rowid关联）
          await customStatement('''
            CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
              INSERT INTO words_fts(rowid, word, lemma, search_content) 
              VALUES (new.id, new.word, new.lemma, new.content);
            END;
          ''');

          await customStatement('''
            CREATE TRIGGER words_fts_delete AFTER DELETE ON words_table BEGIN
              DELETE FROM words_fts WHERE rowid = old.id;
            END;
          ''');

          await customStatement('''
            CREATE TRIGGER words_fts_update AFTER UPDATE ON words_table BEGIN
              DELETE FROM words_fts WHERE rowid = old.id;
              INSERT INTO words_fts(rowid, word, lemma, search_content) 
              VALUES (new.id, new.word, new.lemma, new.content);
            END;
          ''');

          // 重新同步现有数据到FTS5表
          await customStatement('''
            INSERT INTO words_fts(rowid, word, lemma, search_content)
            SELECT id, word, lemma, content FROM words_table
          ''');

          print('[Database] FTS5 rowid关联修复完成');
        }

        // 从版本3升级到版本4：修复表结构和数据类型问题
        if (from <= 3 && to >= 4) {
          print('[Database] 升级数据库到版本4：修复数据类型问题...');

          // 由于Drift无法直接修改列的默认值，我们需要清空并重建数据
          // 这样新的表结构和默认值会生效
          await customStatement('DELETE FROM words_table');

          // 重建FTS5表
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              word,
              lemma,
              search_content
            );
          ''');

          // 数据导入标记存储在SharedPreferences中，不在数据库

          print('[Database] 版本4升级完成：已清空数据，需要重新导入');
        }

        // 从版本4升级到版本5：修复类型转换问题
        if (from <= 4 && to >= 5) {
          print('[Database] 升级数据库到版本5：修复类型转换问题...');

          // 清空数据，因为字段存储格式发生了变化
          await customStatement('DELETE FROM words_table');

          // 重建FTS5表
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              word,
              lemma,
              search_content
            );
          ''');

          print('[Database] 版本5升级完成：已修复类型转换问题，需要重新导入数据');
        }

        // 从版本5升级到版本6：修复搜索排序问题
        if (from <= 5 && to >= 6) {
          print('🚨🚨🚨 [Database] 升级数据库到版本6：修复搜索排序问题！🚨🚨🚨');

          // 强制清空数据和重置导入标记，确保使用新的搜索逻辑
          await customStatement('DELETE FROM words_table');
          await customStatement('DROP TABLE IF EXISTS words_fts');

          // 重建FTS5表
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              word,
              lemma,
              search_content
            );
          ''');

          print('🚨🚨🚨 [Database] 版本6升级完成：已重置数据，强制重新导入');
          print('🚨🚨🚨 [Database] 新版本将使用优化的搜索排序逻辑');
        }
      },
      beforeOpen: (details) async {
        // 启用外键约束
        await customStatement('PRAGMA foreign_keys = ON');

        // 优化SQLite性能
        await customStatement('PRAGMA journal_mode = WAL');
        await customStatement('PRAGMA synchronous = NORMAL');
        await customStatement('PRAGMA cache_size = 10000');
        await customStatement('PRAGMA temp_store = MEMORY');
      },
    );
  }

  /// 全文搜索单词
  Future<List<WordsTableData>> searchWords(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final queryTrimmed = query.trim();
    if (queryTrimmed.isEmpty) {
      return [];
    }

    try {
      final results = <WordsTableData>[];

      final prefixResults =
          await _performWordPrefixSearch(queryTrimmed, limit, offset);
      results.addAll(prefixResults);

      if (results.length < limit) {
        final remainingLimit = limit - results.length;
        final ftsResults =
            await _performFTS5Search('$queryTrimmed*', remainingLimit, offset);
        final existing = results.map((r) => r.word).toSet();
        results.addAll(
          ftsResults.where((result) => !existing.contains(result.word)),
        );
      }

      final queryLower = queryTrimmed.toLowerCase();
      results.sort((a, b) {
        final aWord = a.word.toLowerCase();
        final bWord = b.word.toLowerCase();
        final aExact = aWord == queryLower;
        final bExact = bWord == queryLower;
        if (aExact != bExact) {
          return aExact ? -1 : 1;
        }
        final aStarts = aWord.startsWith(queryLower);
        final bStarts = bWord.startsWith(queryLower);
        if (aStarts != bStarts) {
          return aStarts ? -1 : 1;
        }
        final frequencyCompare = b.frequency.compareTo(a.frequency);
        if (frequencyCompare != 0) {
          return frequencyCompare;
        }
        return a.word.length.compareTo(b.word.length);
      });

      return results;
    } catch (e) {
      print('搜索失败: $e');
      return await fuzzySearchWords(query, limit: limit);
    }
  }

  /// 纯单词前缀匹配（绕过FTS5的例句干扰）
  Future<List<WordsTableData>> _performWordPrefixSearch(
    String queryWord,
    int limit,
    int offset,
  ) async {
    print('🚨🚨🚨 [前缀搜索] 执行纯前缀匹配: "$queryWord" 🚨🚨🚨');

    final sqlQuery = '''
      SELECT w.* FROM words_table w
      WHERE w.word LIKE ? || '%'
      AND w.word NOT GLOB '[0-9]*'
      AND LENGTH(w.word) > 1
      AND w.word GLOB '[a-zA-Z]*'
      ORDER BY
        CASE
          WHEN w.word = ? THEN 0                    -- 🥇 完全匹配优先
          ELSE 1
        END,
        w.frequency DESC,
        LENGTH(w.word) ASC
      LIMIT ? OFFSET ?
    ''';

    print('🚨 [前缀搜索] SQL: $sqlQuery');
    print('🚨 [前缀搜索] 参数: [$queryWord, $queryWord, $limit, $offset]');

    final results = await customSelect(
      sqlQuery,
      variables: [
        Variable.withString(queryWord), // 用于LIKE前缀匹配
        Variable.withString(queryWord), // 用于完全匹配检查
        Variable.withInt(limit),
        Variable.withInt(offset),
      ],
      readsFrom: {wordsTable},
    ).get();

    print('🚨🚨🚨 [前缀搜索] 原始查询返回 ${results.length} 条结果');

    // 调试输出所有结果
    for (int i = 0; i < results.length; i++) {
      final word = results[i].data['word'];
      final frequency = results[i].data['frequency'];
      print('🚨 [前缀搜索] 结果${i + 1}: "$word" (频率:$frequency)');
    }

    // 🔧 终极修复：使用Drift的select方法，避免fromJson转换问题
    print('🚨🚨🚨 [前缀搜索] 绕过fromJson，使用Drift查询');

    // 🔧 简化查询：先使用基础排序，确保能工作
    final driftResults = await (select(wordsTable)
          ..where((tbl) => tbl.word.like('$queryWord%'))
          ..where((tbl) => tbl.word.isNotNull())
          ..where((tbl) => tbl.word.length.isBiggerThanValue(1))
          ..orderBy([
            (t) => OrderingTerm.desc(t.frequency),
            (t) => OrderingTerm.asc(t.word.length),
          ])
          ..limit(limit, offset: offset))
        .get();

    print('🚨🚨🚨 [前缀搜索] Drift查询返回 ${driftResults.length} 条结果');

    // 输出前几个结果
    for (int i = 0; i < driftResults.length && i < 5; i++) {
      print(
          '🚨 [Drift结果] ${i + 1}: "${driftResults[i].word}" (频率:${driftResults[i].frequency})');
    }

    return driftResults;
  }

  /// 执行FTS5搜索的核心方法
  Future<List<WordsTableData>> _performFTS5Search(
    String ftsQuery,
    int limit,
    int offset,
  ) async {
    // 提取查询词（去掉*通配符）
    final queryWord = ftsQuery.replaceAll('*', '');

    print('🔍 [搜索调试] FTS查询: "$ftsQuery", 原词: "$queryWord"');

    final sqlQuery = '''
      SELECT
        w.*,
        CASE
          WHEN w.word = ? THEN 0                    -- 🥇 完全匹配优先
          WHEN w.word LIKE ? || '%' THEN 1          -- 🥈 真正的前缀匹配优先
          ELSE 2                                    -- 🥉 例句/释义匹配最后
        END as match_priority
      FROM words_table w
      INNER JOIN words_fts fts ON w.id = fts.rowid
      WHERE words_fts MATCH ?
      AND w.word NOT GLOB '[0-9]*'
      AND LENGTH(w.word) > 1
      AND w.word GLOB '[a-zA-Z]*'
      ORDER BY
        match_priority,
        w.frequency DESC,
        LENGTH(w.word) ASC
      LIMIT ? OFFSET ?
    ''';

    print(
        '🔍 [搜索调试] SQL查询变量: [$queryWord, $queryWord, $ftsQuery, $limit, $offset]');

    final results = await customSelect(
      sqlQuery,
      variables: [
        Variable.withString(queryWord), // 用于完全匹配检查
        Variable.withString(queryWord), // 用于前缀匹配检查
        Variable.withString(ftsQuery), // 用于FTS5匹配
        Variable.withInt(limit),
        Variable.withInt(offset),
      ],
      readsFrom: {wordsTable},
    ).get();

    // 调试输出前5个结果
    for (int i = 0; i < results.length && i < 5; i++) {
      final word = results[i].data['word'];
      final priority = results[i].data['match_priority'];
      final frequency = results[i].data['frequency'];
      print('🔍 [搜索调试] 结果${i + 1}: "$word" (优先级:$priority, 频率:$frequency)');
    }

    return results.map((row) => WordsTableData.fromJson(row.data)).toList();
  }

  /// 模糊搜索单词（用于输入提示）
  Future<List<WordsTableData>> fuzzySearchWords(
    String query, {
    int limit = 10,
  }) async {
    final queryLower = query.toLowerCase();

    try {
      final results = await (select(wordsTable)
            ..where((tbl) => tbl.word.lower().like('%$queryLower%'))
            ..orderBy([(t) => OrderingTerm.desc(t.frequency)])
            ..limit(limit))
          .get();

      if (results.isNotEmpty) {
        return results;
      }

      return await (select(wordsTable)
            ..where((tbl) => tbl.content.lower().like('%$queryLower%'))
            ..orderBy([(t) => OrderingTerm.desc(t.frequency)])
            ..limit(limit))
          .get();
    } catch (e) {
      print('Drift搜索失败: $e');
      return [];
    }
  }

  /// 获取热门单词
  Future<List<WordsTableData>> getPopularWords({int limit = 50}) async {
    return (select(wordsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.frequency)])
          ..limit(limit))
        .get();
  }

  /// 根据等级获取单词
  Future<List<WordsTableData>> getWordsByLevel(
    String level, {
    int limit = 100,
    int offset = 0,
  }) async {
    final query = select(wordsTable)
      ..where((tbl) => tbl.level.equals(level))
      ..orderBy([(t) => OrderingTerm.desc(t.frequency)])
      ..limit(limit);

    if (offset > 0) {
      query.limit(limit, offset: offset);
    }

    return query.get();
  }

  /// 批量插入单词
  Future<void> insertWords(List<WordsTableCompanion> words) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(wordsTable, words);
    });
  }

  /// 添加搜索历史
  Future<void> addSearchHistory(String userId, String query) async {
    await into(searchHistoryTable).insert(
      SearchHistoryTableCompanion.insert(
        userId: userId,
        query: query,
        timestamp: Value(DateTime.now()),
      ),
      mode: InsertMode.replace,
    );

    // 保持搜索历史数量不超过100条
    await customStatement('''
      DELETE FROM search_history_table 
      WHERE user_id = ? AND id NOT IN (
        SELECT id FROM search_history_table 
        WHERE user_id = ? 
        ORDER BY timestamp DESC 
        LIMIT 100
      )
    ''', [userId, userId]);
  }

  /// 获取搜索历史
  Future<List<String>> getSearchHistory(String userId, {int limit = 20}) async {
    final results = await (select(searchHistoryTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();

    return results.map((row) => row.query).toList();
  }

  /// 清除搜索历史
  Future<void> clearSearchHistory(String userId) async {
    await (delete(searchHistoryTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .go();
  }
}

/// 数据库连接配置
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 在移动平台上设置sqlite3库路径
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // 获取数据库文件路径
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'check_words.db'));

    // 配置数据库连接
    return NativeDatabase.createInBackground(
      file,
      logStatements: true,
    );
  });
}
