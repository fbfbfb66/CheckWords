// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'5d0e79d899b2ded88c6002632cc1f2a4b6db7fe3';

/// 当前用户
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = AutoDisposeProviderRef<UserModel?>;
String _$hasUserHash() => r'd7ec075b5015df9580b9e561cb05c89b972933c8';

/// 是否有用户
///
/// Copied from [hasUser].
@ProviderFor(hasUser)
final hasUserProvider = AutoDisposeProvider<bool>.internal(
  hasUser,
  name: r'hasUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasUserRef = AutoDisposeProviderRef<bool>;
String _$userNotifierHash() => r'ac22c84ff21ec3d9d39069b4739d963054759233';

/// 简化的用户服务（极简版）
///
/// Copied from [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UserNotifier, UserState>.internal(
  UserNotifier.new,
  name: r'userNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserNotifier = AutoDisposeAsyncNotifier<UserState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
