import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

part 'auth_provider.g.dart';

/// 简化的用户服务（极简版）
@riverpod
class UserNotifier extends _$UserNotifier {
  static const String _userIdKey = 'user_id';
  static const Uuid _uuid = Uuid();

  @override
  Future<UserState> build() async {
    return _loadOrCreateUser();
  }

  Future<UserState> _loadOrCreateUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString(_userIdKey);

      if (userId == null) {
        // 创建新的用户
        userId = _uuid.v4();
        await prefs.setString(_userIdKey, userId);
      }

      final userModel = UserModel(
        id: userId,
        name: '学习者',
        avatarPath: null,
      );

      return UserState(
        hasUser: true,
        user: userModel,
      );
    } catch (_) {
      // 如果发生错误，返回默认用户
      final userId = _uuid.v4();
      final userModel = UserModel(
        id: userId,
        name: '学习者',
        avatarPath: null,
      );

      return UserState(
        hasUser: true,
        user: userModel,
      );
    }
  }

  /// 更新用户资料（仅本地设置）
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final current = state.value;
    if (current == null || !current.hasUser || current.user == null) {
      throw Exception('用户不存在');
    }

    try {
      final updatedUser = current.user!.copyWith(
        name: request.name ?? current.user!.name,
        avatarPath: request.avatarPath ?? current.user!.avatarPath,
      );

      final updatedState = current.copyWith(user: updatedUser);
      state = AsyncValue.data(updatedState);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 重置用户（清除所有本地数据）
  Future<void> resetUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);

      // 重新创建用户
      state = const AsyncValue.loading();
      final newState = await _loadOrCreateUser();
      state = AsyncValue.data(newState);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// 当前用户
@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  final userState = ref.watch(userNotifierProvider);
  return userState.when(
    data: (state) => state.user,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// 是否有用户
@riverpod
bool hasUser(HasUserRef ref) {
  final userState = ref.watch(userNotifierProvider);
  return userState.when(
    data: (state) => state.isValid,
    loading: () => false,
    error: (_, __) => false,
  );
}