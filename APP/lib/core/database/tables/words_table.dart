import 'dart:convert';
import 'package:drift/drift.dart';

/// 单词表定义
@DataClassName('WordsTableData')
class WordsTable extends Table {
  @override
  String get tableName => 'words_table';

  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 单词本身
  TextColumn get word => text().withLength(min: 1, max: 50)();

  /// 词干/原形
  TextColumn get lemma => text().withLength(min: 1, max: 50).nullable()();

  /// 词性列表 (JSON: ["noun", "verb"])
  TextColumn get partsOfSpeech => text().withDefault(const Constant('[]'))();

  /// 词性含义 (JSON格式)
  TextColumn get posMeanings => text().withDefault(const Constant('[]'))();

  /// 例句短语 (JSON格式)
  TextColumn get phrases => text().withDefault(const Constant('[]'))();

  /// 例句 (JSON格式)
  TextColumn get sentences => text().withDefault(const Constant('[]'))();

  /// 音标和音频 (JSON格式)
  TextColumn get pronunciation => text().withDefault(const Constant('{}'))();

  /// CEFR等级 (A1, A2, B1, B2, C1, C2)
  TextColumn get level => text().nullable()();

  /// 词频 (用于排序)
  IntColumn get frequency => integer().withDefault(const Constant(0))();

  /// 标签 (JSON数组: ["academic", "business"])
  TextColumn get tags => text().withDefault(const Constant('[]'))();

  /// 同义词 (JSON数组)
  TextColumn get synonyms => text().withDefault(const Constant('[]'))();

  /// 反义词 (JSON数组)
  TextColumn get antonyms => text().withDefault(const Constant('[]'))();

  /// 搜索用的文本内容 (包含单词、含义、例句等)
  TextColumn get content => text().withDefault(const Constant(''))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // 不需要重写primaryKey，因为id已经是autoIncrement

  @override
  List<Set<Column>> get uniqueKeys => [
    {word},
  ];
}


// 扩展方法暂时注释，等代码生成冲突解决后再启用
// extension WordsTableDataExtension on WordsTableData {
//   String get primaryMeaning => '';
//   String? get ipa => null;
//   bool get hasAudio => false;
//   String? get firstSentence => null;
// }