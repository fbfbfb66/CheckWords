import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 用户模型（极简版）
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    String? avatarPath,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

/// 用户状态（极简版）
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool hasUser,
    UserModel? user,
  }) = _UserState;

  factory UserState.fromJson(Map<String, dynamic> json) => _$UserStateFromJson(json);
}

/// 用户状态扩展方法
extension UserStateExtension on UserState {
  /// 是否有用户
  bool get isValid => hasUser && user != null;

  /// 用户显示名称
  String get displayName {
    if (user == null) return '学习者';
    return user!.name.isEmpty ? '学习者' : user!.name;
  }

  /// 用户头像文字
  String get avatarText {
    if (user == null) return '学';
    if (user!.name.isNotEmpty) {
      return user!.name.substring(0, 1).toUpperCase();
    }
    return '学';
  }
}

/// 更新用户资料请求模型
@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    String? name,
    String? avatarPath,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);
}