import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../models/word_model.dart';
import 'learning_provider.dart';

part 'favorites_provider.g.dart';

/// 检查单词是否被收藏（全局）
@riverpod
Future<bool> isWordFavorited(IsWordFavoritedRef ref, int wordId) async {
  final database = ref.watch(databaseProvider);

  try {
    final query = database.select(database.favoritesTable)
      ..where((tbl) => tbl.wordId.equals(wordId));

    final result = await query.getSingleOrNull();
    return result?.isFavorited ?? false;
  } catch (e) {
    print('检查收藏状态失败: $e');
    return false;
  }
}

/// 切换单词收藏状态
@riverpod
class FavoriteToggle extends _$FavoriteToggle {
  @override
  Future<bool> build(int wordId) async {
    return await ref.watch(isWordFavoritedProvider(wordId).future);
  }

  /// 切换收藏状态
  Future<bool> toggle() async {
    final database = ref.read(databaseProvider);
    final currentState = state.valueOrNull ?? false;
    final isFavoriting = !currentState;

    try {
      await database.transaction(() async {
        final existingQuery = database.select(database.favoritesTable)
          ..where((tbl) => tbl.wordId.equals(wordId));

        final existing = await existingQuery.getSingleOrNull();

        if (existing != null) {
          await (database.update(database.favoritesTable)
                ..where((tbl) => tbl.id.equals(existing.id)))
              .write(FavoritesTableCompanion(
                isFavorited: Value(isFavoriting),
                learningStatus: isFavoriting
                    ? Value(0) // 未学习
                    : const Value.absent(),
                reviewCount: isFavoriting ? const Value(0) : const Value.absent(),
                correctCount: isFavoriting ? const Value(0) : const Value.absent(),
                incorrectCount: isFavoriting ? const Value(0) : const Value.absent(),
                lastReviewedAt: isFavoriting ? const Value(null) : const Value.absent(),
                nextReviewAt: isFavoriting ? const Value(null) : const Value.absent(),
                reviewInterval: isFavoriting ? const Value(1) : const Value.absent(),
                easeFactor: isFavoriting ? const Value(2.5) : const Value.absent(),
                updatedAt: Value(DateTime.now()),
              ));
        } else {
          await database.into(database.favoritesTable).insert(
            FavoritesTableCompanion.insert(
              wordId: wordId,
              isFavorited: Value(isFavoriting),
              learningStatus: Value(0), // 未学习
            ),
          );
        }
      });

      final newState = isFavoriting;
      state = AsyncValue.data(newState);

      ref.invalidate(isWordFavoritedProvider(wordId));
      ref.invalidate(favoriteWordsProvider);
      ref.invalidate(favoriteWordsCountProvider);
      ref.invalidate(learningSessionProvider);

      return newState;
    } catch (e) {
      print('切换收藏状态失败: $e');
      throw Exception('操作失败: $e');
    }
  }

}

/// 获取收藏的单词列表（全局）
@riverpod
Future<List<WordModel>> favoriteWords(FavoriteWordsRef ref, {int limit = 100}) async {
  final database = ref.watch(databaseProvider);

  try {
    // 联查获取收藏的单词详情
    final results = await database.customSelect(
      '''
      SELECT w.* FROM words_table w
      INNER JOIN favorites_table f ON w.id = f.word_id
      WHERE f.is_favorited = 1
      ORDER BY f.updated_at DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withInt(limit),
      ],
      readsFrom: {database.wordsTable, database.favoritesTable},
    ).get();

    return results.map((result) => WordModel.fromDatabaseRecord({
      'id': result.data['id'] as int,
      'word': result.data['word'] as String,
      'lemma': result.data['lemma'] as String?,
      'parts_of_speech': result.data['parts_of_speech'] as String,
      'pos_meanings': result.data['pos_meanings'] as String,
      'phrases': result.data['phrases'] as String,
      'sentences': result.data['sentences'] as String,
      'pronunciation': result.data['pronunciation'] as String,
      'level': result.data['level'] as String?,
      'frequency': result.data['frequency'] as int? ?? 0,
      'tags': result.data['tags'] as String? ?? '[]',
      'synonyms': result.data['synonyms'] as String? ?? '[]',
      'antonyms': result.data['antonyms'] as String? ?? '[]',
    })).toList();
  } catch (e) {
    print('获取收藏单词失败: $e');
    return [];
  }
}

/// 获取收藏数量（全局）
@riverpod
Future<int> favoriteWordsCount(FavoriteWordsCountRef ref) async {
  final database = ref.watch(databaseProvider);

  try {
    final query = database.selectOnly(database.favoritesTable)
      ..addColumns([database.favoritesTable.id.count()])
      ..where(database.favoritesTable.isFavorited.equals(true));

    final result = await query.getSingle();
    return result.read(database.favoritesTable.id.count()) ?? 0;
  } catch (e) {
    print('获取收藏数量失败: $e');
    return 0;
  }
}

