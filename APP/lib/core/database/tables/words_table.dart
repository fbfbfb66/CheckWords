import 'dart:convert';
import 'package:drift/drift.dart';

/// 单词表定义（匹配kajweb/dict JSON格式）
@DataClassName('WordsTableData')
class WordsTable extends Table {
  @override
  String get tableName => 'words_table';

  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 单词唯一标识符 (content.word.wordId)
  TextColumn get wordId => text()();

  /// 单词书ID (用于分类)
  TextColumn get bookId => text()();

  /// 单词序号 (wordRank)
  IntColumn get wordRank => integer()();

  /// 单词本身 (headWord/content.word.wordHead)
  TextColumn get headWord => text().withLength(min: 1, max: 50)();

  /// 美式音标
  TextColumn get usphone => text().nullable()();

  /// 英式音标
  TextColumn get ukphone => text().nullable()();

  /// 美式发音参数
  TextColumn get usspeech => text().nullable()();

  /// 英式发音参数
  TextColumn get ukspeech => text().nullable()();

  /// 释义信息 (JSON格式, content.word.content.trans)
  TextColumn get trans => text().withDefault(const Constant('[]'))();

  /// 例句 (JSON格式, content.word.content.sentence.sentences)
  TextColumn get sentences => text().withDefault(const Constant('[]'))();

  /// 短语 (JSON格式, content.word.content.phrase.phrases)
  TextColumn get phrases => text().withDefault(const Constant('[]'))();

  /// 同近义词 (JSON格式, content.word.content.syno.synos)
  TextColumn get synonyms => text().withDefault(const Constant('[]'))();

  /// 同根词 (JSON格式, content.word.content.relWord.rels)
  TextColumn get relWords => text().withDefault(const Constant('[]'))();

  /// 考试题目 (JSON格式, content.word.content.exam)
  TextColumn get exams => text().withDefault(const Constant('[]'))();

  /// 搜索用的文本内容 (包含单词、释义、例句等)
  TextColumn get searchContent => text().withDefault(const Constant(''))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {wordId},
  ];
}


// 扩展方法暂时注释，等代码生成冲突解决后再启用
// extension WordsTableDataExtension on WordsTableData {
//   String get primaryMeaning => '';
//   String? get ipa => null;
//   bool get hasAudio => false;
//   String? get firstSentence => null;
// }