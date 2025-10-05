import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../models/user_model.dart';

part 'auth_provider.g.dart';

/// 认证服务
@riverpod
class AuthNotifier extends _$AuthNotifier {
  static const String _authStateKey = 'auth_state';
  static const Uuid _uuid = Uuid();

  @override
  Future<AuthState> build() async {
    return _loadAuthState();
  }

  Future<AuthState> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authStateJson = prefs.getString(_authStateKey);
      if (authStateJson == null) {
        return const AuthState();
      }

      final authState = AuthState.fromJson(jsonDecode(authStateJson));
      if (authState.isValid) {
        return authState;
      }
    } catch (_) {
      // ignore persisted state errors and fall back to signed-out
    }

    return const AuthState();
  }

  Future<void> _saveAuthState(AuthState authState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authStateKey, jsonEncode(authState.toJson()));
  }

  Future<void> _clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authStateKey);
  }

  /// 登录
  Future<void> signIn(LoginRequest request) async {
    state = const AsyncValue.loading();

    try {
      final database = ref.read(databaseProvider);
      final user = await database.customSelect(
        'SELECT * FROM users_table WHERE email = ?',
        variables: [Variable.withString(request.email)],
      ).getSingleOrNull();

      if (user == null) {
        throw Exception('用户不存在');
      }

      final data = user.data;
      final passwordHash = _hashPassword(request.password);
      if (data['password_hash'] != passwordHash) {
        throw Exception('密码错误');
      }

      await database.customUpdate(
        'UPDATE users_table SET last_login_at = ? WHERE id = ?',
        variables: [
          Variable.withDateTime(DateTime.now()),
          Variable.withString(data['id'].toString()),
        ],
      );

      final preferencesJson = data['preferences']?.toString() ?? '{}';
      final userModel = UserModel(
        id: data['id'].toString(),
        name: data['name'].toString(),
        email: data['email'].toString(),
        avatarPath: data['avatar_path']?.toString(),
        emailVerified: _readBool(data['email_verified']),
        preferences: jsonDecode(preferencesJson) as Map<String, dynamic>,
        createdAt: DateTime.parse(data['created_at'].toString()),
        updatedAt: DateTime.parse(data['updated_at'].toString()),
        lastLoginAt: DateTime.now(),
      );

      final accessToken = _generateToken();
      final authState = AuthState(
        isAuthenticated: true,
        user: userModel,
        accessToken: accessToken,
        refreshToken: request.rememberMe ? _generateToken() : null,
        tokenExpiry: DateTime.now().add(const Duration(hours: 24)),
      );

      await _saveAuthState(authState);
      state = AsyncValue.data(authState);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      state = const AsyncValue.data(AuthState());
    }
  }

  /// 注册
  Future<void> signUp(RegisterRequest request) async {
    state = const AsyncValue.loading();

    try {
      final database = ref.read(databaseProvider);

      final existing = await database.customSelect(
        'SELECT id FROM users_table WHERE email = ?',
        variables: [Variable.withString(request.email)],
      ).getSingleOrNull();

      if (existing != null) {
        throw Exception('邮箱已被注册');
      }

      final userId = _uuid.v4();
      final passwordHash = _hashPassword(request.password);
      final now = DateTime.now();

      await database.customInsert(
        '''INSERT INTO users_table (
            id, name, email, password_hash, email_verified, preferences, created_at, updated_at
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
        variables: [
          Variable.withString(userId),
          Variable.withString(request.name),
          Variable.withString(request.email),
          Variable.withString(passwordHash),
          Variable.withBool(false),
          Variable.withString('{}'),
          Variable.withDateTime(now),
          Variable.withDateTime(now),
        ],
      );

      await signIn(LoginRequest(
        email: request.email,
        password: request.password,
        rememberMe: true,
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      state = const AsyncValue.data(AuthState());
    }
  }

  /// 忘记密码（占位实现）
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    final database = ref.read(databaseProvider);
    final user = await database.customSelect(
      'SELECT id FROM users_table WHERE email = ?',
      variables: [Variable.withString(request.email)],
    ).getSingleOrNull();

    if (user == null) {
      throw Exception('用户不存在');
    }

    throw Exception('重置密码邮件已发送，请查收');
  }

  /// 更新用户资料
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final current = state.value;
    if (current == null || !current.isAuthenticated || current.user == null) {
      throw Exception('用户未登录');
    }

    try {
      final database = ref.read(databaseProvider);
      final userId = current.user!.id;
      final updates = <String>[];
      final variables = <Variable>[];

      if (request.name != null) {
        updates.add('name = ?');
        variables.add(Variable.withString(request.name!));
      }

      if (request.avatarPath != null) {
        updates.add('avatar_path = ?');
        variables.add(Variable.withString(request.avatarPath!));
      }

      if (request.preferences != null) {
        updates.add('preferences = ?');
        variables.add(Variable.withString(jsonEncode(request.preferences)));
      }

      if (updates.isEmpty) {
        return;
      }

      updates.add('updated_at = ?');
      variables.add(Variable.withDateTime(DateTime.now()));
      variables.add(Variable.withString(userId));

      await database.customUpdate(
        'UPDATE users_table SET ${updates.join(', ')} WHERE id = ?',
        variables: variables,
      );

      final updatedUser = current.user!.copyWith(
        name: request.name ?? current.user!.name,
        avatarPath: request.avatarPath ?? current.user!.avatarPath,
        preferences: request.preferences ?? current.user!.preferences,
        updatedAt: DateTime.now(),
      );

      final updatedState = current.copyWith(user: updatedUser);
      await _saveAuthState(updatedState);
      state = AsyncValue.data(updatedState);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      state = const AsyncValue.data(AuthState());
    }
  }

  /// 修改密码
  Future<void> changePassword(ChangePasswordRequest request) async {
    final current = state.value;
    if (current == null || !current.isAuthenticated || current.user == null) {
      throw Exception('用户未登录');
    }

    if (request.newPassword != request.confirmPassword) {
      throw Exception('新密码确认不匹配');
    }

    try {
      final database = ref.read(databaseProvider);
      final userId = current.user!.id;

      final user = await database.customSelect(
        'SELECT password_hash FROM users_table WHERE id = ?',
        variables: [Variable.withString(userId)],
      ).getSingle();

      final currentHash = _hashPassword(request.currentPassword);
      if (user.data['password_hash'] != currentHash) {
        throw Exception('当前密码错误');
      }

      final newHash = _hashPassword(request.newPassword);
      await database.customUpdate(
        'UPDATE users_table SET password_hash = ?, updated_at = ? WHERE id = ?',
        variables: [
          Variable.withString(newHash),
          Variable.withDateTime(DateTime.now()),
          Variable.withString(userId),
        ],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 退出登录
  Future<void> signOut() async {
    await _clearAuthState();
    state = const AsyncValue.data(AuthState());
  }

  /// 刷新令牌
  Future<void> refreshToken() async {
    final current = state.value;
    if (current == null || current.refreshToken == null) {
      return;
    }

    try {
      final updated = current.copyWith(
        accessToken: _generateToken(),
        tokenExpiry: DateTime.now().add(const Duration(hours: 24)),
      );

      await _saveAuthState(updated);
      state = AsyncValue.data(updated);
    } catch (_) {
      await signOut();
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password + 'salt_key_here');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _generateToken() {
    final raw = '${DateTime.now().toIso8601String()}_${_uuid.v4()}';
    final digest = sha256.convert(utf8.encode(raw));
    return digest.toString();
  }

  bool _readBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }
}

/// 当前用户
@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (state) => state.user,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// 是否已认证
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (state) => state.isAuthenticated && state.isValid,
    loading: () => false,
    error: (_, __) => false,
  );
}
