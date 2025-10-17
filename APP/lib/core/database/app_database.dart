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
    FavoritesTable,
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
  int get schemaVersion => 13; // 🚨 升级到版本13：进一步简化用户系统，改为全局收藏

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // 创建所有表
        await m.createAll();

        // 创建FTS5虚拟表用于全文搜索
        await customStatement('''
          CREATE VIRTUAL TABLE words_fts USING fts5(
            head_word,
            word_id,
            search_content
          );
        ''');

        // 创建触发器保持FTS表同步
        await customStatement('''
          CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
            INSERT INTO words_fts(rowid, head_word, word_id, search_content)
            VALUES (new.id, new.head_word, new.word_id, new.search_content);
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
            INSERT INTO words_fts(rowid, head_word, word_id, search_content)
            VALUES (new.id, new.head_word, new.word_id, new.search_content);
          END;
        ''');

        // 创建索引
        await customStatement(
            'CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC);');
        await customStatement(
            'CREATE INDEX idx_words_book_id ON words_table(book_id ASC);');
        await customStatement(
            'CREATE INDEX idx_words_head_word ON words_table(head_word ASC);');
        // 修复：user_words_table已不存在，改为favorites_table的索引
        await customStatement(
            'CREATE INDEX idx_favorites_word_id ON favorites_table(word_id);');
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

        // 从版本6升级到版本7：适配kajweb/dict JSON格式
        if (from <= 6 && to >= 7) {
          print('🚨🚨🚨 [Database] 升级数据库到版本7：适配kajweb/dict JSON格式！🚨🚨🚨');

          // 由于表结构发生重大变化，需要重建表
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('DROP TABLE IF EXISTS words_table');

          // 重新创建所有表结构
          await m.createAll();

          // 重新创建FTS5虚拟表用于全文搜索
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              head_word,
              word_id,
              search_content
            );
          ''');

          // 重新创建触发器保持FTS表同步
          await customStatement('''
            CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
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
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
            END;
          ''');

          // 重新创建索引
          await customStatement(
              'CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC);');
          await customStatement(
              'CREATE INDEX idx_words_book_id ON words_table(book_id ASC);');
          await customStatement(
              'CREATE INDEX idx_words_head_word ON words_table(head_word ASC);');

          print('🚨🚨🚨 [Database] 版本7升级完成：表结构已更新，需要重新导入数据');
        }

        // 从版本7升级到版本8：修复字段名不匹配问题
        if (from <= 7 && to >= 8) {
          print('🚨🚨🚨 [Database] 升级数据库到版本8：修复字段名不匹配问题！🚨🚨🚨');

          // 由于字段名不匹配导致FTS5触发器失效，需要重建表
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('DROP TABLE IF EXISTS words_table');

          // 重新创建所有表结构
          await m.createAll();

          // 重新创建FTS5虚拟表用于全文搜索
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              head_word,
              word_id,
              search_content
            );
          ''');

          // 重新创建触发器保持FTS表同步
          await customStatement('''
            CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
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
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
            END;
          ''');

          // 重新创建索引
          await customStatement(
              'CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC);');
          await customStatement(
              'CREATE INDEX idx_words_book_id ON words_table(book_id ASC);');
          await customStatement(
              'CREATE INDEX idx_words_head_word ON words_table(head_word ASC);');

          print('🚨🚨🚨 [Database] 版本8升级完成：字段名已修复，需要重新导入数据');
        }

        // 从版本8升级到版本9：强制重新导入真实CET4数据
        if (from <= 8 && to >= 9) {
          print('🚨🚨🚨 [Database] 升级数据库到版本9：强制重新导入真实CET4数据！🚨🚨🚨');

          // 由于数据导入逻辑已更新，需要清空现有数据并重新导入
          await customStatement('DELETE FROM words_table');
          await customStatement('DELETE FROM words_fts');

          print('🚨🚨🚨 [Database] 版本9升级完成：已清空数据，强制重新导入真实CET4数据');
        }

        // 从版本9升级到版本10：修复发音字段架构
        if (from <= 9 && to >= 10) {
          print('🚨🚨🚨 [Database] 升级数据库到版本10：修复发音字段架构！🚨🚨🚨');

          // 由于发音字段架构发生重大变化（从JSON字段改为独立字段），需要重建表
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('DROP TABLE IF EXISTS words_table');

          // 重新创建所有表结构
          await m.createAll();

          // 重新创建FTS5虚拟表用于全文搜索
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              head_word,
              word_id,
              search_content
            );
          ''');

          // 重新创建触发器保持FTS表同步
          await customStatement('''
            CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
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
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
            END;
          ''');

          // 重新创建索引
          await customStatement(
              'CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC);');
          await customStatement(
              'CREATE INDEX idx_words_book_id ON words_table(book_id ASC);');
          await customStatement(
              'CREATE INDEX idx_words_head_word ON words_table(head_word ASC);');

          print('🚨🚨🚨 [Database] 版本10升级完成：发音字段架构已修复，需要重新导入数据');
        }

        // 从版本10升级到版本11：强制重新创建数据库结构（解决迁移未执行问题）
        if (from <= 10 && to >= 11) {
          print('🚨🚨🚨 [Database] 升级数据库到版本11：强制重新创建数据库结构！🚨🚨🚨');

          // 由于迁移逻辑问题，需要完全重建数据库
          await customStatement('DROP TABLE IF EXISTS words_fts');
          await customStatement('DROP TABLE IF EXISTS words_table');

          // 重新创建所有表结构
          await m.createAll();

          // 重新创建FTS5虚拟表用于全文搜索
          await customStatement('''
            CREATE VIRTUAL TABLE words_fts USING fts5(
              head_word,
              word_id,
              search_content
            );
          ''');

          // 重新创建触发器保持FTS表同步
          await customStatement('''
            CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
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
              INSERT INTO words_fts(rowid, head_word, word_id, search_content)
              VALUES (new.id, new.head_word, new.word_id, new.search_content);
            END;
          ''');

          // 重新创建索引
          await customStatement(
              'CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC);');
          await customStatement(
              'CREATE INDEX idx_words_book_id ON words_table(book_id ASC);');
          await customStatement(
              'CREATE INDEX idx_words_head_word ON words_table(head_word ASC);');

          print('🚨🚨🚨 [Database] 版本11升级完成：数据库结构已完全重建，包含独立发音字段');
        }

        // 从版本11升级到版本12：简化用户表结构，移除登录系统
        if (from <= 11 && to >= 12) {
          print('🚨🚨🚨 [Database] 升级数据库到版本12：简化用户表结构！🚨🚨🚨');

          // 由于表结构发生重大变化，需要重建用户表
          await customStatement('DROP TABLE IF EXISTS users_table');

          // 重新创建用户表（新结构）
          await m.createTable(usersTable);

          print('🚨🚨🚨 [Database] 版本12升级完成：用户表结构已简化，移除登录相关字段');
        }

        // 从版本12升级到版本13：进一步简化用户系统，改为全局收藏
        if (from <= 12 && to >= 13) {
          print('🚨🚨🚨 [Database] 升级数据库到版本13：改为全局收藏系统！🚨🚨🚨');

          // 删除旧的user_words表，创建新的favorites表
          await customStatement('DROP TABLE IF EXISTS user_words_table');

          // 重新创建用户表（新结构）
          await m.createTable(usersTable);

          // 创建新的收藏表
          await m.createTable(favoritesTable);

          print('🚨🚨🚨 [Database] 版本13升级完成：已改为全局收藏系统');
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

        // 检查是否存在表结构，如果不存在则重新创建
        try {
          final tableExists = await customSelect("SELECT name FROM sqlite_master WHERE type='table' AND name='words_table'").get();
          if (tableExists.isEmpty && details.versionNow == 7) {
            print('🚨🚨🚨 [Database] 数据库存在但表结构缺失，重新创建表结构...');
            await _createTableStructure();
            print('🚨🚨🚨 [Database] 表结构重新创建完成');
          }
        } catch (e) {
          print('🚨🚨🚨 [Database] 检查表结构失败: $e');
        }
      },
    );
  }

  /// 创建表结构（用于手动创建）
  Future<void> _createTableStructure() async {
    print('🚨🚨🚨 [Database] 开始创建表结构...');

    // 先创建主要的 words_table 表结构（模拟 Drift 的创建）
    await customStatement('''
      CREATE TABLE words_table (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        word_id TEXT NOT NULL,
        book_id TEXT NOT NULL,
        word_rank INTEGER NOT NULL,
        head_word TEXT NOT NULL,
        pronunciation TEXT NOT NULL DEFAULT '{}',
        trans TEXT NOT NULL DEFAULT '[]',
        sentences TEXT NOT NULL DEFAULT '[]',
        phrases TEXT NOT NULL DEFAULT '[]',
        synonyms TEXT NOT NULL DEFAULT '[]',
        rel_words TEXT NOT NULL DEFAULT '[]',
        exams TEXT NOT NULL DEFAULT '[]',
        search_content TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    // 创建FTS5虚拟表用于全文搜索
    await customStatement('''
      CREATE VIRTUAL TABLE words_fts USING fts5(
        head_word,
        word_id,
        search_content
      );
    ''');

    // 创建触发器保持FTS表同步
    await customStatement('''
      CREATE TRIGGER words_fts_insert AFTER INSERT ON words_table BEGIN
        INSERT INTO words_fts(rowid, head_word, word_id, search_content)
        VALUES (new.id, new.head_word, new.word_id, new.search_content);
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
        INSERT INTO words_fts(rowid, head_word, word_id, search_content)
        VALUES (new.id, new.head_word, new.word_id, new.search_content);
      END;
    ''');

    // 创建索引
    await customStatement(
        'CREATE INDEX idx_words_word_rank ON words_table(word_rank ASC);');
    await customStatement(
        'CREATE INDEX idx_words_book_id ON words_table(book_id ASC);');
    await customStatement(
        'CREATE INDEX idx_words_head_word ON words_table(head_word ASC);');

    print('🚨🚨🚨 [Database] 表结构创建完成');
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
        final existing = results.map((r) => r.headWord).toSet();
        results.addAll(
          ftsResults.where((result) => !existing.contains(result.headWord)),
        );
      }

      final queryLower = queryTrimmed.toLowerCase();
      results.sort((a, b) {
        final aWord = a.headWord.toLowerCase();
        final bWord = b.headWord.toLowerCase();
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
        final rankCompare = a.wordRank.compareTo(b.wordRank);
        if (rankCompare != 0) {
          return rankCompare;
        }
        return a.headWord.length.compareTo(b.headWord.length);
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
      WHERE w.head_word LIKE ? || '%'
      AND w.head_word NOT GLOB '[0-9]*'
      AND LENGTH(w.head_word) > 1
      AND w.head_word GLOB '[a-zA-Z]*'
      ORDER BY
        CASE
          WHEN w.head_word = ? THEN 0                 -- 🥇 完全匹配优先
          ELSE 1
        END,
        w.word_rank ASC,
        LENGTH(w.head_word) ASC
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
      final headWord = results[i].data['headWord'];
      final wordRank = results[i].data['wordRank'];
      print('🚨 [前缀搜索] 结果${i + 1}: "$headWord" (排名:$wordRank)');
    }

    // 🔧 终极修复：使用Drift的select方法，避免fromJson转换问题
    print('🚨🚨🚨 [前缀搜索] 绕过fromJson，使用Drift查询');

    // 🔧 简化查询：先使用基础排序，确保能工作
    final driftResults = await (select(wordsTable)
          ..where((tbl) => tbl.headWord.like('$queryWord%'))
          ..where((tbl) => tbl.headWord.isNotNull())
          ..where((tbl) => tbl.headWord.length.isBiggerThanValue(1))
          ..orderBy([
            (t) => OrderingTerm.asc(t.wordRank),
            (t) => OrderingTerm.asc(t.headWord.length),
          ])
          ..limit(limit, offset: offset))
        .get();

    print('🚨🚨🚨 [前缀搜索] Drift查询返回 ${driftResults.length} 条结果');

    // 输出前几个结果
    for (int i = 0; i < driftResults.length && i < 5; i++) {
      print(
          '🚨 [Drift结果] ${i + 1}: "${driftResults[i].headWord}" (排名:${driftResults[i].wordRank})');
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
          WHEN w.head_word = ? THEN 0                -- 🥇 完全匹配优先
          WHEN w.head_word LIKE ? || '%' THEN 1       -- 🥈 真正的前缀匹配优先
          ELSE 2                                    -- 🥉 例句/释义匹配最后
        END as match_priority
      FROM words_table w
      INNER JOIN words_fts fts ON w.id = fts.rowid
      WHERE words_fts MATCH ?
      AND w.head_word NOT GLOB '[0-9]*'
      AND LENGTH(w.head_word) > 1
      AND w.head_word GLOB '[a-zA-Z]*'
      ORDER BY
        match_priority,
        w.word_rank ASC,
        LENGTH(w.head_word) ASC
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
            ..where((tbl) => tbl.headWord.lower().like('%$queryLower%'))
            ..orderBy([(t) => OrderingTerm.asc(t.wordRank)])
            ..limit(limit))
          .get();

      if (results.isNotEmpty) {
        return results;
      }

      return await (select(wordsTable)
            ..where((tbl) => tbl.searchContent.lower().like('%$queryLower%'))
            ..orderBy([(t) => OrderingTerm.asc(t.wordRank)])
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
          ..orderBy([(t) => OrderingTerm.asc(t.wordRank)])
          ..limit(limit))
        .get();
  }

  /// 根据书籍ID获取单词
  Future<List<WordsTableData>> getWordsByBookId(
    String bookId, {
    int limit = 100,
    int offset = 0,
  }) async {
    final query = select(wordsTable)
      ..where((tbl) => tbl.bookId.equals(bookId))
      ..orderBy([(t) => OrderingTerm.asc(t.wordRank)])
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
