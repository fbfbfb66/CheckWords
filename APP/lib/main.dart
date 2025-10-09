import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'shared/providers/locale_provider.dart';
import 'core/database/app_database.dart';
import 'core/services/data_import_service.dart';
import 'l10n/generated/l10n_simple.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await AppDatabase.initialize();

  try {
    await DataImportService.importWordsData(database);
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
