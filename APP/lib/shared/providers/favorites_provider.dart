import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/tables/user_words_table.dart';
import '../models/word_model.dart';
import 'auth_provider.dart';
import 'learning_provider.dart';

part 'favorites_provider.g.dart';

/// 检查单词是否被收藏
@riverpod
Future<bool> isWordFavorited(IsWordFavoritedRef ref, int wordId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  final database = ref.watch(databaseProvider);

  try {
    final query = database.select(database.userWordsTable)
      ..where((tbl) => tbl.userId.equals(user.id) & tbl.wordId.equals(wordId));
    
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
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('\u7528\u6237\u672a\u767b\u5f55');
    }

    final database = ref.read(databaseProvider);
    final currentState = state.valueOrNull ?? false;
    final isFavoriting = !currentState;

    try {
      await database.transaction(() async {
        final existingQuery = database.select(database.userWordsTable)
          ..where((tbl) => tbl.userId.equals(user.id) & tbl.wordId.equals(wordId));

        final existing = await existingQuery.getSingleOrNull();

        if (existing != null) {
          await (database.update(database.userWordsTable)
                ..where((tbl) => tbl.id.equals(existing.id)))
              .write(UserWordsTableCompanion(
                isFavorited: Value(isFavoriting),
                learningStatus: isFavoriting
                    ? Value(LearningStatus.notLearned.value)
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
          await database.into(database.userWordsTable).insert(
            UserWordsTableCompanion.insert(
              userId: user.id,
              wordId: wordId,
              isFavorited: Value(isFavoriting),
              learningStatus: Value(LearningStatus.notLearned.value),
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
      print('\u5207\u6362\u6536\u85cf\u72b6\u6001\u5931\u8d25: $e');
      throw Exception('\u64cd\u4f5c\u5931\u8d25: $e');
    }
  }

}

/// 获取用户收藏的单词列表
@riverpod
Future<List<WordModel>> favoriteWords(FavoriteWordsRef ref, {int limit = 100}) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final database = ref.watch(databaseProvider);

  try {
    // 联查获取收藏的单词详情
    final results = await database.customSelect(
      '''
      SELECT w.* FROM words_table w
      INNER JOIN user_words_table uw ON w.id = uw.word_id
      WHERE uw.user_id = ? AND uw.is_favorited = 1
      ORDER BY uw.updated_at DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withString(user.id),
        Variable.withInt(limit),
      ],
      readsFrom: {database.wordsTable, database.userWordsTable},
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

/// 获取收藏数量
@riverpod
Future<int> favoriteWordsCount(FavoriteWordsCountRef ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;

  final database = ref.watch(databaseProvider);

  try {
    final query = database.selectOnly(database.userWordsTable)
      ..addColumns([database.userWordsTable.id.count()])
      ..where(database.userWordsTable.userId.equals(user.id) & 
              database.userWordsTable.isFavorited.equals(true));
    
    final result = await query.getSingle();
    return result.read(database.userWordsTable.id.count()) ?? 0;
  } catch (e) {
    print('获取收藏数量失败: $e');
    return 0;
  }
}

/// 批量操作收藏
@riverpod
class BatchFavoriteOperations extends _$BatchFavoriteOperations {
  @override
  Future<void> build() async {
    // 不需要初始状态
  }

  /// 批量添加收藏
  Future<void> addMultipleFavorites(List<int> wordIds) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('用户未登录');
    }

    final database = ref.read(databaseProvider);

    try {
      await database.transaction(() async {
        for (final wordId in wordIds) {
          await database.into(database.userWordsTable).insertOnConflictUpdate(
            UserWordsTableCompanion.insert(
              userId: user.id,
              wordId: wordId,
              isFavorited: const Value(true),
            ),
          );
        }
      });

      // 使相关provider失效
      ref.invalidate(favoriteWordsProvider);
      ref.invalidate(favoriteWordsCountProvider);
    } catch (e) {
      print('批量添加收藏失败: $e');
      throw Exception('批量操作失败: $e');
    }
  }

  /// 批量移除收藏
  Future<void> removeMultipleFavorites(List<int> wordIds) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('用户未登录');
    }

    final database = ref.read(databaseProvider);

    try {
      await database.transaction(() async {
        await (database.update(database.userWordsTable)
              ..where((tbl) => tbl.userId.equals(user.id) & 
                              tbl.wordId.isIn(wordIds)))
            .write(const UserWordsTableCompanion(
              isFavorited: Value(false),
              updatedAt: Value.absentIfNull(null),
            ));
      });

      // 使相关provider失效
      ref.invalidate(favoriteWordsProvider);
      ref.invalidate(favoriteWordsCountProvider);
    } catch (e) {
      print('批量移除收藏失败: $e');
      throw Exception('批量操作失败: $e');
    }
  }

  /// 清空所有收藏
  Future<void> clearAllFavorites() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      throw Exception('用户未登录');
    }

    final database = ref.read(databaseProvider);

    try {
      await (database.update(database.userWordsTable)
            ..where((tbl) => tbl.userId.equals(user.id)))
          .write(const UserWordsTableCompanion(
            isFavorited: Value(false),
            updatedAt: Value.absentIfNull(null),
          ));

      // 使相关provider失效
      ref.invalidate(favoriteWordsProvider);
      ref.invalidate(favoriteWordsCountProvider);
    } catch (e) {
      print('清空收藏失败: $e');
      throw Exception('清空失败: $e');
    }
  }
}