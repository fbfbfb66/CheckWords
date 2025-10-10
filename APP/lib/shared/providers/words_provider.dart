import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/database_provider.dart';
import '../models/word_model.dart';

part 'words_provider.g.dart';

/// 根据ID获取单词详情
@riverpod
Future<WordModel?> wordById(WordByIdRef ref, int wordId) async {
  final database = ref.watch(databaseProvider);

  try {
    final query = database.select(database.wordsTable)
      ..where((tbl) => tbl.id.equals(wordId));

    final result = await query.getSingleOrNull();

    if (result == null) {
      print('❌ 未找到单词ID: $wordId');
      return null;
    }

    if (result.headWord.isEmpty) {
      print('❌ 单词记录无效: headWord为空 (ID: $wordId)');
      return null;
    }

    // 构建数据库记录Map
    final dbRecord = {
      'id': result.id,
      'wordId': result.wordId,
      'bookId': result.bookId,
      'wordRank': result.wordRank,
      'headWord': result.headWord,
      'usphone': result.usphone,
      'ukphone': result.ukphone,
      'usspeech': result.usspeech,
      'ukspeech': result.ukspeech,
      'trans': result.trans,
      'sentences': result.sentences,
      'phrases': result.phrases,
      'synonyms': result.synonyms,
      'relWords': result.relWords,
      'exams': result.exams,
    };

    final wordModel = WordModel.fromDatabaseRecord(dbRecord);
    return wordModel;

  } catch (e, stackTrace) {
    print('❌ 获取单词详情失败: $e');
    print('❌ 堆栈跟踪: $stackTrace');
    print('❌ 单词ID: $wordId');

    // 尝试创建一个基本的WordModel作为fallback
    try {
      final query = database.select(database.wordsTable)
        ..where((tbl) => tbl.id.equals(wordId));
      final result = await query.getSingleOrNull();

      if (result != null && result.headWord.isNotEmpty) {
        print('🔄 尝试创建fallback WordModel');
        return WordModel(
          id: result.id,
          wordId: result.wordId,
          bookId: result.bookId,
          wordRank: result.wordRank,
          headWord: result.headWord,
          usphone: result.usphone,
          ukphone: result.ukphone,
          usspeech: result.usspeech,
          ukspeech: result.ukspeech,
          trans: [],
          sentences: [],
          phrases: [],
          synonyms: [],
          relWords: [],
          exams: [],
        );
      }
    } catch (fallbackError) {
      print('❌ Fallback也失败了: $fallbackError');
    }

    return null;
  }
}

/// 检查数据库状态（调试用）
@riverpod
Future<DatabaseStatus> databaseStatus(DatabaseStatusRef ref) async {
  final database = ref.watch(databaseProvider);

  try {
    // 检查应用数据库表结构
    final tableInfoQuery = database.customSelect("PRAGMA table_info(words_table)");
    final tableInfoResult = await tableInfoQuery.get();
    print('🔍 应用数据库表结构:');
    for (final row in tableInfoResult) {
      final name = row.read<String>('name');
      final type = row.read<String>('type');
      print('   - $name ($type)');
    }

    // 检查单词总数
    final countQuery = database.customSelect('SELECT COUNT(*) as count FROM words_table');
    final countResult = await countQuery.get();
    final totalCount = countResult.first.read<int>('count') ?? 0;

    // 检查前5个单词
    final sampleQuery = database.customSelect('SELECT head_word, usphone, ukphone FROM words_table LIMIT 5');
    final sampleResults = await sampleQuery.get();

    // 检查有音标的单词数量
    final pronunciationCountQuery = database.customSelect(
      'SELECT COUNT(*) as count FROM words_table WHERE usphone IS NOT NULL OR ukphone IS NOT NULL'
    );
    final pronunciationCountResult = await pronunciationCountQuery.get();
    final pronunciationCount = pronunciationCountResult.first.read<int>('count') ?? 0;

    print('🔍 数据库状态调试:');
    print('   总单词数: $totalCount');
    print('   有音标的单词数: $pronunciationCount');
    print('   前5个单词样本:');
    final sampleWordList = <String>[];
    for (final word in sampleResults) {
      final headWord = word.read<String>('head_word') ?? '';
      final usphone = word.read<String>('usphone');
      final ukphone = word.read<String>('ukphone');
      print('     - $headWord (美音:$usphone, 英音:$ukphone)');
      if (headWord.isNotEmpty) {
        sampleWordList.add(headWord);
      }
    }

    return DatabaseStatus(
      totalWords: totalCount,
      wordsWithPronunciation: pronunciationCount,
      sampleWords: sampleWordList,
    );
  } catch (e) {
    print('❌ 检查数据库状态失败: $e');
    return DatabaseStatus(
      totalWords: 0,
      wordsWithPronunciation: 0,
      sampleWords: [],
      error: e.toString(),
    );
  }
}

/// 数据库状态数据模型
class DatabaseStatus {
  final int totalWords;
  final int wordsWithPronunciation;
  final List<String> sampleWords;
  final String? error;

  const DatabaseStatus({
    required this.totalWords,
    required this.wordsWithPronunciation,
    required this.sampleWords,
    this.error,
  });
}

/// 根据单词名称获取单词详情
@riverpod
Future<WordModel?> wordByName(WordByNameRef ref, String word) async {
  final database = ref.watch(databaseProvider);

  try {
    print('🔍 开始根据单词名称获取详情: $word');
    final query = database.select(database.wordsTable)
      ..where((tbl) => tbl.headWord.equals(word));

    final result = await query.getSingleOrNull();

    if (result == null) {
      print('❌ 数据库中未找到单词: $word');
      return null;
    }

    print('✅ 找到单词记录: $word (ID: ${result.id})');

    // 直接创建WordModel，避免循环依赖
    return WordModel.fromDatabaseRecord({
      'id': result.id,
      'wordId': result.wordId,
      'bookId': result.bookId,
      'wordRank': result.wordRank,
      'headWord': result.headWord,
      'usphone': result.usphone,
      'ukphone': result.ukphone,
      'usspeech': result.usspeech,
      'ukspeech': result.ukspeech,
      'trans': result.trans,
      'sentences': result.sentences,
      'phrases': result.phrases,
      'synonyms': result.synonyms,
      'relWords': result.relWords,
      'exams': result.exams,
    });
  } catch (e) {
    print('根据名称获取单词失败: $e');
    return null;
  }
}


/// 搜索单词
@riverpod

/// 搜索单词
@riverpod
Future<List<WordModel>> searchWords(SearchWordsRef ref, String query,
    {int limit = 20}) async {
  final database = ref.watch(databaseProvider);

  final trimmedQuery = query.trim();
  if (trimmedQuery.isEmpty) {
    return [];
  }

  try {
    final results = await database.searchWords(trimmedQuery, limit: limit);
    final words = results
        .map((result) => WordModel.fromDatabaseRecord({
              'id': result.id,
              'wordId': result.wordId,
              'bookId': result.bookId,
              'wordRank': result.wordRank,
              'headWord': result.headWord,
              'usphone': result.usphone,
      'ukphone': result.ukphone,
      'usspeech': result.usspeech,
      'ukspeech': result.ukspeech,
              'trans': result.trans,
              'sentences': result.sentences,
              'phrases': result.phrases,
              'synonyms': result.synonyms,
              'relWords': result.relWords,
              'exams': result.exams,
            }))
        .toList();

    final queryLower = trimmedQuery.toLowerCase();
    words.sort((a, b) {
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

    return words;
  } catch (e) {
    print('搜索单词失败: ');
    return [];
  }
}

/// 模糊搜索单词（用于输入提示）
@riverpod
Future<List<WordModel>> fuzzySearchWords(FuzzySearchWordsRef ref, String query,
    {int limit = 10}) async {
  final database = ref.watch(databaseProvider);

  if (query.isEmpty) {
    return [];
  }

  try {
    final results = await database.fuzzySearchWords(query, limit: limit);

    return results
        .map((result) => WordModel.fromDatabaseRecord({
              'id': result.id,
              'wordId': result.wordId,
              'bookId': result.bookId,
              'wordRank': result.wordRank,
              'headWord': result.headWord,
              'usphone': result.usphone,
      'ukphone': result.ukphone,
      'usspeech': result.usspeech,
      'ukspeech': result.ukspeech,
              'trans': result.trans,
              'sentences': result.sentences,
              'phrases': result.phrases,
              'synonyms': result.synonyms,
              'relWords': result.relWords,
              'exams': result.exams,
            }))
        .toList();
  } catch (e) {
    print('模糊搜索失败: $e');
    return [];
  }
}

/// 获取热门单词
@riverpod
Future<List<WordModel>> popularWords(PopularWordsRef ref,
    {int limit = 50}) async {
  final database = ref.watch(databaseProvider);

  try {
    final results = await database.getPopularWords(limit: limit);

    return results
        .map((result) => WordModel.fromDatabaseRecord({
              'id': result.id,
              'wordId': result.wordId,
              'bookId': result.bookId,
              'wordRank': result.wordRank,
              'headWord': result.headWord,
              'usphone': result.usphone,
      'ukphone': result.ukphone,
      'usspeech': result.usspeech,
      'ukspeech': result.ukspeech,
              'trans': result.trans,
              'sentences': result.sentences,
              'phrases': result.phrases,
              'synonyms': result.synonyms,
              'relWords': result.relWords,
              'exams': result.exams,
            }))
        .toList();
  } catch (e) {
    print('获取热门单词失败: $e');
    return [];
  }
}

/// 根据等级获取单词
@riverpod
Future<List<WordModel>> wordsByLevel(WordsByLevelRef ref, String level,
    {int limit = 100}) async {
  final database = ref.watch(databaseProvider);

  try {
    final results = await database.getWordsByBookId(level, limit: limit);

    return results
        .map((result) => WordModel.fromDatabaseRecord({
              'id': result.id,
              'wordId': result.wordId,
              'bookId': result.bookId,
              'wordRank': result.wordRank,
              'headWord': result.headWord,
              'usphone': result.usphone,
      'ukphone': result.ukphone,
      'usspeech': result.usspeech,
      'ukspeech': result.ukspeech,
              'trans': result.trans,
              'sentences': result.sentences,
              'phrases': result.phrases,
              'synonyms': result.synonyms,
              'relWords': result.relWords,
              'exams': result.exams,
            }))
        .toList();
  } catch (e) {
    print('根据等级获取单词失败: $e');
    return [];
  }
}
