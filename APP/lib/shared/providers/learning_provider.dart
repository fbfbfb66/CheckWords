import 'package:drift/drift.dart' hide JsonKey;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../models/word_model.dart';
import 'auth_provider.dart';

part 'learning_provider.g.dart';
part 'learning_provider.freezed.dart';

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

/// 学习会话（全局）
@riverpod
class LearningSession extends _$LearningSession {
  @override
  LearningSessionState build() {
    return const LearningSessionState();
  }

  /// 开始学习
  Future<void> startLearning() async {
    if (state.isLoading ||
        (state.currentWord != null || state.remainingWords.isNotEmpty) ||
        state.isCompleted) {
      return;
    }

    final database = ref.read(databaseProvider);

    try {
      state = state.copyWith(isLoading: true);

      // 获取所有收藏的单词
      final stats = await _loadFavoritedWordStats(database);

      final results = await database.customSelect(
        '''
        SELECT w.*
        FROM words_table w
        INNER JOIN favorites_table f ON w.id = f.word_id
        WHERE f.is_favorited = 1
          AND (f.learning_status IS NULL OR f.learning_status != ?)
        ORDER BY RANDOM()
        ''',
        variables: [
          Variable.withInt(2), // 已掌握状态值
        ],
        readsFrom: {database.wordsTable, database.favoritesTable},
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
        completedCount: 0,
        showAnswer: false,
        isCompleted: words.isEmpty,
        hasFavoritedWords: stats.hasFavorites,
        allFavoritedMastered: stats.allMastered,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('加载学习单词失败: $e');
    }
  }

  /// 重置已掌握的收藏单词
  Future<void> resetMasteredFavorites() async {
    final database = ref.read(databaseProvider);

    try {
      state = state.copyWith(isLoading: true);

      await (database.update(database.favoritesTable)
            ..where((tbl) =>
                tbl.isFavorited.equals(true) &
                tbl.learningStatus.equals(2))) // 已掌握状态值
          .write(
        FavoritesTableCompanion(
          learningStatus: Value(0), // 未学习状态
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
      print('重置收藏单词状态失败: $e');
    }
  }

  void showAnswer() {
    state = state.copyWith(showAnswer: true);
  }

  Future<void> handleWordResult(bool isKnown) async {
    final currentWord = state.currentWord;
    if (currentWord == null) return;

    final database = ref.read(databaseProvider);

    try {
      // 更新单词学习状态
      final status = isKnown ? 2 : 1; // 2=已掌握, 1=学习中

      await (database.update(database.favoritesTable)
            ..where((tbl) => tbl.wordId.equals(currentWord.id)))
          .write(
        FavoritesTableCompanion(
          learningStatus: Value(status),
          reviewCount: const Value(1),
          correctCount: isKnown ? const Value(1) : const Value(0),
          incorrectCount: isKnown ? const Value(0) : const Value(1),
          lastReviewedAt: Value(DateTime.now()),
          nextReviewAt: Value(_calculateNextReviewTime(status)),
          reviewInterval: Value(_calculateNextReviewInterval(status)),
          easeFactor: Value(_calculateNextEaseFactor(status)),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 继续下一个单词
      if (state.remainingWords.isNotEmpty) {
        final nextWord = state.remainingWords.first;
        state = state.copyWith(
          currentWord: nextWord,
          remainingWords: state.remainingWords.skip(1).toList(),
          currentIndex: state.currentIndex + 1,
          completedCount: state.completedCount + 1,
          showAnswer: false,
        );
      } else {
        // 学习完成
        state = state.copyWith(
          isCompleted: true,
          isLoading: false,
        );
      }

      // 刷新统计
      ref.invalidateSelf();
    } catch (e) {
      print('更新单词学习状态失败: $e');
    }
  }

  /// 跳转到下一个单词
  Future<void> nextWord() async {
    if (state.remainingWords.isEmpty) {
      state = state.copyWith(isCompleted: true);
      return;
    }

    final nextWord = state.remainingWords.first;
    state = state.copyWith(
      currentWord: nextWord,
      remainingWords: state.remainingWords.skip(1).toList(),
      currentIndex: state.currentIndex + 1,
      showAnswer: false,
    );
  }

  /// 跳转到上一个单词
  Future<void> previousWord() async {
    if (state.currentIndex <= 0) return;

    // 重建当前和剩余单词列表
    final previousIndex = state.currentIndex - 1;
    final allWords = <WordModel>[
      if (state.currentWord != null) state.currentWord!,
      ...state.remainingWords,
    ];

    if (previousIndex < allWords.length) {
      state = state.copyWith(
        currentWord: allWords[previousIndex],
        remainingWords: previousIndex < allWords.length - 1
            ? allWords.skip(previousIndex + 1).toList()
            : <WordModel>[],
        currentIndex: previousIndex,
        showAnswer: false,
      );
    }
  }

  /// 切换显示答案
  void toggleAnswer() {
    state = state.copyWith(showAnswer: !state.showAnswer);
    }

  /// 重置会话
  void resetSession() {
    state = const LearningSessionState();
  }

  /// 重新开始学习
  void restartLearning() {
    state = const LearningSessionState();
    startLearning();
  }

  /// 设置学习模式
  void setLearningMode(String mode) {
    // TODO: 实现不同的学习模式
  }

  /// 计算下次复习时间（简化版）
  DateTime _calculateNextReviewTime(int status) {
    final now = DateTime.now();
    switch (status) {
      case 0: // 未学习
        return now.add(const Duration(hours: 1));
      case 1: // 学习中
        return now.add(const Duration(days: 1));
      case 2: // 已掌握
        return now.add(const Duration(days: 7));
      default:
        return now.add(const Duration(days: 1));
    }
  }

  /// 计算下次复习间隔（简化版）
  int _calculateNextReviewInterval(int status) {
    switch (status) {
      case 0: return 1;
      case 1: return 3;
      case 2: return 7;
      default: return 1;
    }
  }

  /// 计算难度因子（简化版）
  double _calculateNextEaseFactor(int status) {
    switch (status) {
      case 0: return 2.5;
      case 1: return 2.3;
      case 2: return 2.6;
      default: return 2.5;
    }
  }

  /// 加载收藏单词统计
  Future<_FavoritedWordsStats> _loadFavoritedWordStats(
    AppDatabase database,
  ) async {
    try {
      // 获取总数
      final totalCountExpr = database.favoritesTable.id.count();
      final totalResult = await (database.selectOnly(database.favoritesTable)
            ..addColumns([totalCountExpr])
            ..where(database.favoritesTable.isFavorited.equals(true)))
        .getSingle();
      final total = totalResult.read(totalCountExpr) ?? 0;

      // 获取已掌握数量
      final masteredCountExpr = database.favoritesTable.id.count();
      final masteredResult = await (database.selectOnly(database.favoritesTable)
            ..addColumns([masteredCountExpr])
            ..where(database.favoritesTable.isFavorited.equals(true) &
                    database.favoritesTable.learningStatus.equals(2))) // 已掌握
        .getSingle();
      final mastered = masteredResult.read(masteredCountExpr) ?? 0;

      return _FavoritedWordsStats(total: total, mastered: mastered);
    } catch (e) {
      print('加载收藏统计失败: $e');
      return _FavoritedWordsStats(total: 0, mastered: 0);
    }
  }
}

/// 学习会话状态
@freezed
class LearningSessionState with _$LearningSessionState {
  const factory LearningSessionState({
    @Default(false) bool isLoading,
    WordModel? currentWord,
    @Default([]) List<WordModel> remainingWords,
    @Default(0) int currentIndex,
    @Default(0) int completedCount,
    @Default(false) bool showAnswer,
    @Default(false) bool isCompleted,
    @Default(false) bool hasFavoritedWords,
    @Default(false) bool allFavoritedMastered,
  }) = _LearningSessionState;

  const LearningSessionState._();

  // 计算属性
  int get totalWords => completedCount + remainingWords.length + (currentWord != null ? 1 : 0);

  int get remainingCount => remainingWords.length;

  double get progress => totalWords > 0 ? completedCount / totalWords : 0.0;
}