import 'package:drift/drift.dart';

import 'words_table.dart';

/// 收藏单词表 (全局收藏，不关联用户)
@DataClassName('FavoritesTableData')
class FavoritesTable extends Table {
  @override
  String get tableName => 'favorites_table';

  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 单词ID
  IntColumn get wordId => integer().references(WordsTable, #id, onDelete: KeyAction.cascade)();

  /// 是否收藏
  BoolColumn get isFavorited => boolean().withDefault(const Constant(false))();

  /// 学习状态 (0: 未学习, 1: 学习中, 2: 已掌握)
  IntColumn get learningStatus => integer().withDefault(const Constant(0))();

  /// 复习次数
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();

  /// 正确次数
  IntColumn get correctCount => integer().withDefault(const Constant(0))();

  /// 错误次数
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();

  /// 记忆强度 (Spaced Repetition算法使用)
  RealColumn get memoryStrength => real().withDefault(const Constant(0.0))();

  /// 下次复习时间
  DateTimeColumn get nextReviewAt => dateTime().nullable()();

  /// 复习间隔 (天数)
  IntColumn get reviewInterval => integer().withDefault(const Constant(1))();

  /// 难度因子 (SuperMemo算法使用)
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();

  /// 学习笔记
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// 添加到收藏的时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// 最后复习时间
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {wordId},
  ];
}

/// 学习状态枚举
enum LearningStatus {
  notLearned(0, '未学习'),
  learning(1, '学习中'),
  mastered(2, '已掌握');

  const LearningStatus(this.value, this.label);

  final int value;
  final String label;

  static LearningStatus fromValue(int value) {
    return LearningStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LearningStatus.notLearned,
    );
  }
}

// 扩展方法暂时注释，等代码生成冲突解决后再启用
// extension UserWordsTableDataExtension on UserWordsTableData {
//   LearningStatus get status => LearningStatus.fromValue(learningStatus);
//   double get accuracyRate => correctCount + incorrectCount == 0 ? 0.0 : correctCount / (correctCount + incorrectCount);
//   bool get needsReview => nextReviewAt != null && DateTime.now().isAfter(nextReviewAt!);
// }