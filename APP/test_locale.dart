import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 简化的语言枚举
enum AppLocale {
  zhCN('zh', 'CN', '简体中文'),
  enUS('en', 'US', 'English');

  const AppLocale(this.languageCode, this.countryCode, this.displayName);

  final String languageCode;
  final String countryCode;
  final String displayName;

  Locale get locale => Locale(languageCode, countryCode);

  static AppLocale fromValue(String value) {
    final parts = value.split('_');
    if (parts.length == 2) {
      return AppLocale.values.firstWhere(
        (locale) => locale.languageCode == parts[0] && locale.countryCode == parts[1],
        orElse: () => AppLocale.zhCN,
      );
    }
    return AppLocale.zhCN;
  }

  String get value => '${languageCode}_$countryCode';
}

// 简化的语言提供者
final localeProvider = StateProvider<AppLocale>((ref) => AppLocale.zhCN);

// 测试应用
void main() {
  runApp(
    const ProviderScope(
      child: LocaleTestApp(),
    ),
  );
}

class LocaleTestApp extends ConsumerWidget {
  const LocaleTestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Language Switch Test',
      locale: currentLocale.locale,
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      home: LocaleTestPage(),
    );
  }
}

class LocaleTestPage extends ConsumerWidget {
  const LocaleTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('语言切换测试'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '当前语言: ${currentLocale.displayName}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Language: ${currentLocale.displayName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final newLocale = currentLocale == AppLocale.zhCN
                    ? AppLocale.enUS
                    : AppLocale.zhCN;
                ref.read(localeProvider.notifier).state = newLocale;
              },
              child: Text('切换语言 / Switch Language'),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '测试文本 / Test Text',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '设置 / Settings',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '主题 / Theme',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '关于 / About',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}