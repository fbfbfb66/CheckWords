import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/words_provider.dart';
import 'core/database/app_database.dart';
import 'core/services/data_import_service.dart';
import 'l10n/generated/l10n_simple.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await AppDatabase.initialize();

  try {
    // 🧹 先检查并清洗数据库
    print('🧹 检查数据库是否需要清洗...');
    await DataImportService.cleanDatabase(database);

    // 等待清洗完成后再导入数据
    await Future.delayed(const Duration(seconds: 1));

    // 🔄 强制完全重置并重新导入，确保数据完整性
    print('🔄 强制完全重置数据库以确保数据完整性...');
    await DataImportService.fullReset(database);

    // 数据导入完成后检查状态
    print('🔍 开始检查数据库状态...');
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );

    // 延迟检查，确保导入完成
    Timer(const Duration(seconds: 5), () async {
      try {
        final status = await container.read(databaseStatusProvider.future);
        if (status.totalWords > 0) {
          print('✅ 数据导入成功！');
          print('   总单词数: ${status.totalWords}');
          print('   有音标的单词数: ${status.wordsWithPronunciation}');
          print('   样本单词: ${status.sampleWords.take(5).join(', ')}');

          // 测试一些常见CET4单词是否都能搜索到
          final testWords = ['access', 'accident', 'accidentally', 'accompany', 'accomplish', 'accord', 'account', 'accumulate', 'accurate', 'accuse'];
          print('🧪 测试常见CET4单词搜索:');
          for (final word in testWords) {
            try {
              final wordResult = await container.read(wordByNameProvider(word).future);
              if (wordResult != null) {
                print('   ✅ $word - 找到 (ID: ${wordResult.id})');
              } else {
                print('   ❌ $word - 未找到');
              }
            } catch (e) {
              print('   ❌ $word - 搜索出错: $e');
            }
          }
        } else {
          print('❌ 数据导入失败，单词数为0');
        }
      } catch (e) {
        print('❌ 检查数据库状态失败: $e');
      }
    });

  } catch (e) {
    print('词汇数据导入失败: $e');
  }

  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(database),
    ],
  );

  // 立即初始化语言设置，确保应用启动时语言正确
  await container.read(localeNotifierProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CheckWordsApp(),
    ),
  );
}

class CheckWordsApp extends ConsumerWidget {
  const CheckWordsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentFont = ref.watch(currentFontProvider);
    final localeState = ref.watch(localeNotifierProvider);

    // 在加载时也显示正确的语言
    if (localeState.isLoading) {
      return MaterialApp(
        title: 'CheckWords',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
        // 使用 locale provider 的状态，即使在加载中也使用中文作为默认
        locale: const Locale('zh', 'CN'),
        home: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp.router(
      title: 'CheckWords',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(fontFamily: currentFont.fontFamily),
      darkTheme: AppTheme.dark(fontFamily: currentFont.fontFamily),
      themeMode: themeMode,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      locale: localeState.currentLocale.locale,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: mediaQuery.textScaleFactor.clamp(0.8, 1.4),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
