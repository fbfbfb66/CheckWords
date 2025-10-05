import 'package:drift/drift.dart';

import 'users_table.dart';

/// 搜索历史表
@DataClassName('SearchHistoryTableData')
class SearchHistoryTable extends Table {
  @override
  String get tableName => 'search_history_table';

  /// 主键ID
  IntColumn get id => integer().autoIncrement()();

  /// 用户ID
  TextColumn get userId => text().references(UsersTable, #id, onDelete: KeyAction.cascade)();

  /// 搜索查询词
  TextColumn get query => text().withLength(min: 1, max: 200)();

  /// 搜索结果数量
  IntColumn get resultCount => integer().withDefault(const Constant(0))();

  /// 搜索时间戳
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  // 不需要重写primaryKey，因为id已经是autoIncrement

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, query}, // 同一用户的同一查询词只保留最新的一条记录
  ];
}

// 扩展方法暂时注释，等代码生成冲突解决后再启用
// extension SearchHistoryTableDataExtension on SearchHistoryTableData {
//   String get formattedTime => '刚刚'; // 简化实现
//   bool get isPopular => resultCount > 10;
//   String get resultLevel => resultCount == 0 ? '无结果' : '有结果';
// }