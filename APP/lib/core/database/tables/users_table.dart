import 'package:drift/drift.dart';

/// 用户表定义（极简版）
@DataClassName('UsersTableData')
class UsersTable extends Table {
  @override
  String get tableName => 'users_table';

  /// 用户ID (UUID)
  TextColumn get id => text().withLength(min: 36, max: 36)();

  /// 用户名/昵称
  TextColumn get name => text().withLength(min: 1, max: 50).withDefault(const Constant('学习者'))();

  /// 头像路径 (本地文件路径)
  TextColumn get avatarPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 扩展方法暂时注释，等代码生成冲突解决后再启用
// extension UsersTableDataExtension on UsersTableData {
//   String get displayName => name.isEmpty ? email.split('@')[0] : name;
//   bool get hasAvatar => avatarPath != null && avatarPath!.isNotEmpty;
//   String get avatarText => name.isNotEmpty ? name.substring(0, 1).toUpperCase() : email.substring(0, 1).toUpperCase();
// }