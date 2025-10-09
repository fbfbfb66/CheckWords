// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentLocaleHash() => r'636bcdaf083f0c255d45f311d7c0e780df27d760';

/// See also [currentLocale].
@ProviderFor(currentLocale)
final currentLocaleProvider = AutoDisposeProvider<Locale>.internal(
  currentLocale,
  name: r'currentLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentLocaleRef = AutoDisposeProviderRef<Locale>;
String _$currentAppLocaleHash() => r'5e42f54e6bb29761d4a3cb32c5c8615553e37fbc';

/// See also [currentAppLocale].
@ProviderFor(currentAppLocale)
final currentAppLocaleProvider = AutoDisposeProvider<AppLocale>.internal(
  currentAppLocale,
  name: r'currentAppLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAppLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentAppLocaleRef = AutoDisposeProviderRef<AppLocale>;
String _$localeNotifierHash() => r'c4c1cdabf8c467041461cc313f1421faf784974c';

/// See also [LocaleNotifier].
@ProviderFor(LocaleNotifier)
final localeNotifierProvider =
    AutoDisposeNotifierProvider<LocaleNotifier, LocaleState>.internal(
  LocaleNotifier.new,
  name: r'localeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocaleNotifier = AutoDisposeNotifier<LocaleState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
