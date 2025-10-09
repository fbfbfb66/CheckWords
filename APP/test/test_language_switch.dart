import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:check_words/shared/providers/locale_provider.dart';
import 'package:check_words/l10n/generated/l10n_simple.dart';

void main() {
  group('语言切换功能测试', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('应该默认使用中文', () {
      final localeState = container.read(localeNotifierProvider);
      expect(localeState.currentLocale, AppLocale.zhCN);
    });

    test('应该能够切换到英文', () async {
      final notifier = container.read(localeNotifierProvider.notifier);

      // 切换到英文
      await notifier.changeLocale(AppLocale.enUS);

      // 等待状态更新
      await container.pump();

      final localeState = container.read(localeNotifierProvider);
      expect(localeState.currentLocale, AppLocale.enUS);
    });

    test('应该能够切换回中文', () async {
      final notifier = container.read(localeNotifierProvider.notifier);

      // 先切换到英文
      await notifier.changeLocale(AppLocale.enUS);
      await container.pump();
      expect(container.read(localeNotifierProvider).currentLocale, AppLocale.enUS);

      // 再切换回中文
      await notifier.changeLocale(AppLocale.zhCN);
      await container.pump();
      expect(container.read(localeNotifierProvider).currentLocale, AppLocale.zhCN);
    });

    test('中英文Locale对象应该正确', () {
      expect(AppLocale.zhCN.locale.languageCode, 'zh');
      expect(AppLocale.zhCN.locale.countryCode, 'CN');

      expect(AppLocale.enUS.locale.languageCode, 'en');
      expect(AppLocale.enUS.locale.countryCode, 'US');
    });

    test('语言显示名称应该正确', () {
      expect(AppLocale.zhCN.displayName, '简体中文');
      expect(AppLocale.enUS.displayName, 'English');
    });

    test('语言值应该正确', () {
      expect(AppLocale.zhCN.value, 'zh_CN');
      expect(AppLocale.enUS.value, 'en_US');
    });
  });
}