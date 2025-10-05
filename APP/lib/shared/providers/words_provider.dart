import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
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
      return null;
    }

    return WordModel.fromDatabaseRecord({
      'id': result.id,
      'word': result.word,
      'lemma': result.lemma,
      'parts_of_speech': result.partsOfSpeech,
      'pos_meanings': result.posMeanings,
      'phrases': result.phrases,
      'sentences': result.sentences,
      'pronunciation': result.pronunciation,
      'level': result.level,
      'frequency': result.frequency,
      'tags': result.tags,
      'synonyms': result.synonyms,
      'antonyms': result.antonyms,
    });
  } catch (e) {
    print('获取单词详情失败: $e');
    return null;
  }
}

/// 根据单词名称获取单词详情
@riverpod
Future<WordModel?> wordByName(WordByNameRef ref, String word) async {
  final database = ref.watch(databaseProvider);

  try {
    final query = database.select(database.wordsTable)
      ..where((tbl) => tbl.word.equals(word));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    return WordModel.fromDatabaseRecord({
      'id': result.id,
      'word': result.word,
      'lemma': result.lemma,
      'parts_of_speech': result.partsOfSpeech,
      'pos_meanings': result.posMeanings,
      'phrases': result.phrases,
      'sentences': result.sentences,
      'pronunciation': result.pronunciation,
      'level': result.level,
      'frequency': result.frequency,
      'tags': result.tags,
      'synonyms': result.synonyms,
      'antonyms': result.antonyms,
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
              'word': result.word,
              'lemma': result.lemma,
              'parts_of_speech': result.partsOfSpeech,
              'pos_meanings': result.posMeanings,
              'phrases': result.phrases,
              'sentences': result.sentences,
              'pronunciation': result.pronunciation,
              'level': result.level,
              'frequency': result.frequency,
              'tags': result.tags,
              'synonyms': result.synonyms,
              'antonyms': result.antonyms,
            }))
        .toList();

    final queryLower = trimmedQuery.toLowerCase();
    words.sort((a, b) {
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
              'word': result.word,
              'lemma': result.lemma,
              'parts_of_speech': result.partsOfSpeech,
              'pos_meanings': result.posMeanings,
              'phrases': result.phrases,
              'sentences': result.sentences,
              'pronunciation': result.pronunciation,
              'level': result.level,
              'frequency': result.frequency,
              'tags': result.tags,
              'synonyms': result.synonyms,
              'antonyms': result.antonyms,
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
              'word': result.word,
              'lemma': result.lemma,
              'parts_of_speech': result.partsOfSpeech,
              'pos_meanings': result.posMeanings,
              'phrases': result.phrases,
              'sentences': result.sentences,
              'pronunciation': result.pronunciation,
              'level': result.level,
              'frequency': result.frequency,
              'tags': result.tags,
              'synonyms': result.synonyms,
              'antonyms': result.antonyms,
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
    final results = await database.getWordsByLevel(level, limit: limit);

    return results
        .map((result) => WordModel.fromDatabaseRecord({
              'id': result.id,
              'word': result.word,
              'lemma': result.lemma,
              'parts_of_speech': result.partsOfSpeech,
              'pos_meanings': result.posMeanings,
              'phrases': result.phrases,
              'sentences': result.sentences,
              'pronunciation': result.pronunciation,
              'level': result.level,
              'frequency': result.frequency,
              'tags': result.tags,
              'synonyms': result.synonyms,
              'antonyms': result.antonyms,
            }))
        .toList();
  } catch (e) {
    print('根据等级获取单词失败: $e');
    return [];
  }
}
