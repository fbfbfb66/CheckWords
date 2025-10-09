import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/tables/user_words_table.dart';
import '../models/word_model.dart';
import 'auth_provider.dart';

part 'learning_provider.g.dart';

class _FavoritedWordsStats {
  const _FavoritedWordsStats({
    required this.total,
    required this.mastered,
  });

  final int total;
  final int mastered;

  bool get hasFavorites => total > 0;
  bool get allMastered => hasFavorites && mastered == total;
}

@riverpod
class LearningSession extends _$LearningSession {
  @override
  LearningSessionState build() {
    return const LearningSessionState();
  }

  Future<void> startLearning() async {
    if (!state.isLoading &&
        (state.currentWord != null || state.remainingWords.isNotEmpty) &&
        !state.isCompleted) {
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final database = ref.read(databaseProvider);

    try {
      state = state.copyWith(isLoading: true);

      final stats = await _loadFavoritedWordStats(database, user.id);

      final results = await database.customSelect(
        '''
        SELECT w.*
        FROM words_table w
        INNER JOIN user_words_table uw ON w.id = uw.word_id
        WHERE uw.user_id = ?
          AND uw.is_favorited = 1
          AND (uw.learning_status IS NULL OR uw.learning_status != ?)
        ORDER BY RANDOM()
        ''',
        variables: [
          Variable.withString(user.id),
          Variable.withInt(LearningStatus.mastered.value),
        ],
        readsFrom: {database.wordsTable, database.userWordsTable},
      ).get();

      final words = results
          .map(
            (row) => WordModel.fromDatabaseRecord({
              'id': row.data['id'] as int,
              'word': row.data['word'] as String,
              'lemma': row.data['lemma'] as String?,
              'parts_of_speech': row.data['parts_of_speech'] as String,
              'pos_meanings': row.data['pos_meanings'] as String,
              'phrases': row.data['phrases'] as String,
              'sentences': row.data['sentences'] as String,
              'pronunciation': row.data['pronunciation'] as String,
              'level': row.data['level'] as String?,
              'frequency': row.data['frequency'] as int? ?? 0,
              'tags': row.data['tags'] as String? ?? '[]',
              'synonyms': row.data['synonyms'] as String? ?? '[]',
              'antonyms': row.data['antonyms'] as String? ?? '[]',
            }),
          )
          .toList();

      state = state.copyWith(
        isLoading: false,
        currentWord: words.isNotEmpty ? words.first : null,
        remainingWords: words.isNotEmpty ? words.skip(1).toList() : const [],
        totalWords: words.length,
        completedCount: 0,
        showAnswer: false,
        isCompleted: words.isEmpty,
        hasFavoritedWords: stats.hasFavorites,
        allFavoritedMastered: stats.allMastered,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // ignore: avoid_print
      print('加载学习单词失败: $e');
    }
  }

  Future<void> resetMasteredFavorites() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }

    final database = ref.read(databaseProvider);

    try {
      state = state.copyWith(isLoading: true);

      await (database.update(database.userWordsTable)
            ..where((tbl) =>
                tbl.userId.equals(user.id) &
                tbl.isFavorited.equals(true) &
                tbl.learningStatus.equals(LearningStatus.mastered.value)))
          .write(
        UserWordsTableCompanion(
          learningStatus: Value(LearningStatus.notLearned.value),
          reviewCount: const Value(0),
          correctCount: const Value(0),
          incorrectCount: const Value(0),
          lastReviewedAt: const Value(null),
          nextReviewAt: const Value(null),
          reviewInterval: const Value(1),
          easeFactor: const Value(2.5),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await startLearning();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // ignore: avoid_print
      print('重置收藏单词状态失败: $e');
    }
  }

  void showAnswer() {
    state = state.copyWith(showAnswer: true);
  }

  Future<void> handleWordResult(bool isKnown) async {
    final currentWord = state.currentWord;
    if (currentWord == null) {
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }

    final database = ref.read(databaseProvider);

    if (isKnown) {
      try {
        await (database.update(database.userWordsTable)
              ..where((tbl) =>
                  tbl.userId.equals(user.id) &
                  tbl.wordId.equals(currentWord.id)))
            .write(
          UserWordsTableCompanion(
            learningStatus: Value(LearningStatus.mastered.value),
            updatedAt: Value(DateTime.now()),
            lastReviewedAt: Value(DateTime.now()),
            reviewCount: const Value(1),
            correctCount: const Value(1),
          ),
        );
      } catch (e) {
        // ignore: avoid_print
        print('更新学习状态失败: $e');
      }
    } else {
      state = state.copyWith(
        remainingWords: [...state.remainingWords, currentWord],
      );
    }

    _moveToNextWord(isKnown);
  }

  void _moveToNextWord(bool wasCorrect) {
    if (state.remainingWords.isEmpty) {
      state = state.copyWith(
        isCompleted: true,
        currentWord: null,
        showAnswer: false,
      );
      return;
    }

    final nextWord = state.remainingWords.first;
    final remaining = state.remainingWords.skip(1).toList();

    state = state.copyWith(
      currentWord: nextWord,
      remainingWords: remaining,
      showAnswer: false,
      completedCount:
          wasCorrect ? state.completedCount + 1 : state.completedCount,
    );
  }

  void resetSession() {
    state = const LearningSessionState();
  }

  Future<void> restartLearning() async {
    resetSession();
    await startLearning();
  }

  Future<_FavoritedWordsStats> _loadFavoritedWordStats(
    AppDatabase database,
    String userId,
  ) async {
    final totalCountExpr = database.userWordsTable.id.count();
    final totalResult = await (database.selectOnly(database.userWordsTable)
          ..addColumns([totalCountExpr])
          ..where(database.userWordsTable.userId.equals(userId) &
              database.userWordsTable.isFavorited.equals(true)))
        .getSingle();
    final total = totalResult.read(totalCountExpr) ?? 0;

    final masteredCountExpr = database.userWordsTable.id.count();
    final masteredResult = await (database.selectOnly(database.userWordsTable)
          ..addColumns([masteredCountExpr])
          ..where(database.userWordsTable.userId.equals(userId) &
              database.userWordsTable.isFavorited.equals(true) &
              database.userWordsTable.learningStatus
                  .equals(LearningStatus.mastered.value)))
        .getSingle();
    final mastered = masteredResult.read(masteredCountExpr) ?? 0;

    return _FavoritedWordsStats(total: total, mastered: mastered);
  }
}

class LearningSessionState {
  const LearningSessionState({
    this.isLoading = true,
    this.currentWord,
    this.remainingWords = const [],
    this.totalWords = 0,
    this.completedCount = 0,
    this.showAnswer = false,
    this.isCompleted = false,
    this.hasFavoritedWords = false,
    this.allFavoritedMastered = false,
  });

  final bool isLoading;
  final WordModel? currentWord;
  final List<WordModel> remainingWords;
  final int totalWords;
  final int completedCount;
  final bool showAnswer;
  final bool isCompleted;
  final bool hasFavoritedWords;
  final bool allFavoritedMastered;

  double get progress {
    if (totalWords == 0) {
      return 0;
    }
    return completedCount / totalWords;
  }

  int get remainingCount => remainingWords.length;

  LearningSessionState copyWith({
    bool? isLoading,
    WordModel? currentWord,
    List<WordModel>? remainingWords,
    int? totalWords,
    int? completedCount,
    bool? showAnswer,
    bool? isCompleted,
    bool? hasFavoritedWords,
    bool? allFavoritedMastered,
  }) {
    return LearningSessionState(
      isLoading: isLoading ?? this.isLoading,
      currentWord: currentWord ?? this.currentWord,
      remainingWords: remainingWords ?? this.remainingWords,
      totalWords: totalWords ?? this.totalWords,
      completedCount: completedCount ?? this.completedCount,
      showAnswer: showAnswer ?? this.showAnswer,
      isCompleted: isCompleted ?? this.isCompleted,
      hasFavoritedWords: hasFavoritedWords ?? this.hasFavoritedWords,
      allFavoritedMastered: allFavoritedMastered ?? this.allFavoritedMastered,
    );
  }
}
