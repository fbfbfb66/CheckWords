import 'package:drift/drift.dart';

/// 用户表定义
@DataClassName('UsersTableData')
class UsersTable extends Table {
  @override
  String get tableName => 'users_table';

  /// 用户ID (UUID)
  TextColumn get id => text().withLength(min: 36, max: 36)();

  /// 用户名/昵称
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// 邮箱
  TextColumn get email => text().withLength(min: 5, max: 100)();

  /// 密码哈希 (使用bcrypt等安全哈希)
  TextColumn get passwordHash => text()();

  /// 头像路径 (本地文件路径或URL)
  TextColumn get avatarPath => text().nullable()();

  /// 是否已验证邮箱
  BoolColumn get emailVerified => boolean().withDefault(const Constant(false))();

  /// 用户偏好设置 (JSON格式)
  TextColumn get preferences => text().withDefault(const Constant('{}'))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// 最后登录时间
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {email},
  ];
}

// 扩展方法暂时注释，等代码生成冲突解决后再启用
// extension UsersTableDataExtension on UsersTableData {
//   String get displayName => name.isEmpty ? email.split('@')[0] : name;
//   bool get hasAvatar => avatarPath != null && avatarPath!.isNotEmpty;
//   String get avatarText => name.isNotEmpty ? name.substring(0, 1).toUpperCase() : email.substring(0, 1).toUpperCase();
// }