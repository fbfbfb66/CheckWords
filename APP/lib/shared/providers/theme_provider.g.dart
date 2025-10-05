// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'aa7ace48f3c0dce382957e3c6eac2449573583a9';

/// SharedPreferences Provider
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$themeModeHash() => r'f18593cc8b89ab322d6f0d5c831bf6e3899ca37e';

/// 主题模式 Provider (方便直接使用)
///
/// Copied from [themeMode].
@ProviderFor(themeMode)
final themeModeProvider = AutoDisposeProvider<ThemeMode>.internal(
  themeMode,
  name: r'themeModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeModeRef = AutoDisposeProviderRef<ThemeMode>;
String _$currentFontHash() => r'82c07586037ef3a156d72d6cc6990b85a42fcf43';

/// 当前字体 Provider
///
/// Copied from [currentFont].
@ProviderFor(currentFont)
final currentFontProvider = AutoDisposeProvider<AppFont>.internal(
  currentFont,
  name: r'currentFontProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentFontHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentFontRef = AutoDisposeProviderRef<AppFont>;
String _$themeSettingsNotifierHash() =>
    r'2beb9f5ba5289928251084f4901936df444c08f6';

/// 主题设置 Provider
///
/// Copied from [ThemeSettingsNotifier].
@ProviderFor(ThemeSettingsNotifier)
final themeSettingsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ThemeSettingsNotifier, ThemeSettings>.internal(
  ThemeSettingsNotifier.new,
  name: r'themeSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeSettingsNotifier = AutoDisposeAsyncNotifier<ThemeSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
