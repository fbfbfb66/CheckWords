import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 用户模型
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? avatarPath,
    @Default(false) bool emailVerified,
    @Default({}) Map<String, dynamic> preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

/// 认证状态
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    UserModel? user,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
}

/// 认证状态扩展方法
extension AuthStateExtension on AuthState {
  /// 是否已登录且有效
  bool get isValid {
    if (!isAuthenticated || user == null || accessToken == null) {
      return false;
    }
    
    // 检查token是否过期
    if (tokenExpiry != null && DateTime.now().isAfter(tokenExpiry!)) {
      return false;
    }
    
    return true;
  }

  /// 是否需要刷新token
  bool get needsRefresh {
    if (tokenExpiry == null || refreshToken == null) return false;
    
    // 如果距离过期时间少于10分钟，需要刷新
    final threshold = tokenExpiry!.subtract(const Duration(minutes: 10));
    return DateTime.now().isAfter(threshold);
  }

  /// 用户显示名称
  String get displayName {
    if (user == null) return '';
    return user!.name.isEmpty ? user!.email.split('@')[0] : user!.name;
  }

  /// 用户头像文字
  String get avatarText {
    if (user == null) return '';
    if (user!.name.isNotEmpty) {
      return user!.name.substring(0, 1).toUpperCase();
    }
    return user!.email.substring(0, 1).toUpperCase();
  }
}

/// 登录请求模型
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
    @Default(true) bool rememberMe,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

/// 注册请求模型
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String name,
    @Default(true) bool agreeToTerms,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
}

/// 忘记密码请求模型
@freezed
class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({
    required String email,
  }) = _ForgotPasswordRequest;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestFromJson(json);
}

/// 更新用户资料请求模型
@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    String? name,
    String? avatarPath,
    Map<String, dynamic>? preferences,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);
}

/// 修改密码请求模型
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);
}