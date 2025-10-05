import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// 应用字体枚举
enum AppFont {
  system('system', '跟随系统', null),
  inter('inter', 'Inter', 'Inter'),
  sourceHanSans('sourceHanSans', '思源黑体', 'SourceHanSansSC');

  const AppFont(this.value, this.label, this.fontFamily);

  final String value;
  final String label;
  final String? fontFamily;

  /// 从字符串值创建枚举
  static AppFont fromValue(String value) {
    return AppFont.values.firstWhere(
      (font) => font.value == value,
      orElse: () => AppFont.system,
    );
  }
}

/// 主题模式枚举
enum AppThemeMode {
  system('system', '跟随系统'),
  light('light', '浅色模式'),
  dark('dark', '深色模式');

  const AppThemeMode(this.value, this.label);

  final String value;
  final String label;

  /// 转换为Flutter的ThemeMode
  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  /// 从字符串值创建枚举
  static AppThemeMode fromValue(String value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

/// 主题设置状态类
class ThemeSettings {
  const ThemeSettings({
    required this.mode,
    required this.font,
  });

  final AppThemeMode mode;
  final AppFont font;

  ThemeSettings copyWith({
    AppThemeMode? mode,
    AppFont? font,
  }) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      font: font ?? this.font,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettings &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          font == other.font;

  @override
  int get hashCode => mode.hashCode ^ font.hashCode;
}

/// SharedPreferences Provider
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

/// 主题设置 Provider
@riverpod
class ThemeSettingsNotifier extends _$ThemeSettingsNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _fontKey = 'app_font';

  @override
  FutureOr<ThemeSettings> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);

    final modeValue = prefs.getString(_themeModeKey) ?? AppThemeMode.system.value;
    final mode = AppThemeMode.fromValue(modeValue);
    
    final fontValue = prefs.getString(_fontKey) ?? AppFont.system.value;
    final font = AppFont.fromValue(fontValue);

    return ThemeSettings(
      mode: mode,
      font: font,
    );
  }

  /// 更新主题模式
  Future<void> updateThemeMode(AppThemeMode mode) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_themeModeKey, mode.value);
    
    final currentState = await future;
    state = AsyncValue.data(currentState.copyWith(mode: mode));
  }

  /// 更新字体设置
  Future<void> updateFont(AppFont font) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_fontKey, font.value);
    
    final currentState = await future;
    state = AsyncValue.data(currentState.copyWith(font: font));
  }
}

/// 主题模式 Provider (方便直接使用)
@riverpod
ThemeMode themeMode(ThemeModeRef ref) {
  final themeSettings = ref.watch(themeSettingsNotifierProvider);
  
  return themeSettings.when(
    data: (settings) => settings.mode.themeMode,
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
}

/// 当前字体 Provider
@riverpod
AppFont currentFont(CurrentFontRef ref) {
  final themeSettings = ref.watch(themeSettingsNotifierProvider);
  
  return themeSettings.when(
    data: (settings) => settings.font,
    loading: () => AppFont.system,
    error: (_, __) => AppFont.system,
  );
}