import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_database.dart';

part 'database_provider.g.dart';

/// 数据库实例 Provider
@riverpod
AppDatabase database(DatabaseRef ref) {
  // 这个provider会在main.dart中被覆盖
  throw UnimplementedError('数据库provider需要在应用启动时被覆盖');
}