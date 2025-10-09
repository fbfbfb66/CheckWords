import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_provider.g.dart';
part 'locale_provider.freezed.dart';

/// 支持的语言枚举
enum AppLocale {
  zhCN('zh', 'CN', '简体中文'),
  enUS('en', 'US', 'English');

  const AppLocale(this.languageCode, this.countryCode, this.displayName);

  final String languageCode;
  final String countryCode;
  final String displayName;

  Locale get locale => Locale(languageCode, countryCode);

  static AppLocale fromLanguageCode(String languageCode) {
    return AppLocale.values.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => AppLocale.zhCN,
    );
  }

  static AppLocale fromValue(String value) {
    final parts = value.split('_');
    if (parts.length == 2) {
      return AppLocale.values.firstWhere(
        (locale) =>
            locale.languageCode == parts[0] && locale.countryCode == parts[1],
        orElse: () => AppLocale.zhCN,
      );
    }
    return AppLocale.zhCN;
  }

  String get value => '${languageCode}_$countryCode';
}

@freezed
class LocaleState with _$LocaleState {
  const factory LocaleState({
    required AppLocale currentLocale,
    required bool isLoading,
    String? error,
  }) = _LocaleState;

  const LocaleState._();
}

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const String _localeKey = 'app_locale';

  @override
  LocaleState build() {
    return const LocaleState(
      currentLocale: AppLocale.zhCN,
      isLoading: false,
    );
  }

  Future<void> initialize() async {
    state = const LocaleState(
      currentLocale: AppLocale.zhCN,
      isLoading: true,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleValue = prefs.getString(_localeKey);

      final currentLocale = savedLocaleValue != null
          ? AppLocale.fromValue(savedLocaleValue)
          : AppLocale.zhCN;

      state = LocaleState(
        currentLocale: currentLocale,
        isLoading: false,
      );
    } catch (e) {
      state = LocaleState(
        currentLocale: AppLocale.zhCN,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> changeLocale(AppLocale newLocale) async {
    if (state.currentLocale == newLocale) return;

    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.value);

      state = LocaleState(
        currentLocale: newLocale,
        isLoading: false,
      );
    } catch (e) {
      state = LocaleState(
        currentLocale: state.currentLocale,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}

@riverpod
Locale currentLocale(CurrentLocaleRef ref) {
  final localeState = ref.watch(localeNotifierProvider);
  return localeState.currentLocale.locale;
}

@riverpod
AppLocale currentAppLocale(CurrentAppLocaleRef ref) {
  final localeState = ref.watch(localeNotifierProvider);
  return localeState.currentLocale;
}
