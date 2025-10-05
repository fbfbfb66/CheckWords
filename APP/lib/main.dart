import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'core/services/data_import_service.dart';
import 'l10n/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化数据库
  final database = await AppDatabase.initialize();

  // 导入预置的词汇数据（首次启动时）
  try {
    await DataImportService.importWordsData(database);
  } catch (e) {
    print('词汇数据导入失败: $e');
    // 继续启动应用，即使导入失败
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
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

    return MaterialApp.router(
      title: 'CheckWords',
      debugShowCheckedModeBanner: false,
      
      // 路由配置
      routerConfig: router,
      
      // 主题配置
      theme: AppTheme.light(fontFamily: currentFont.fontFamily),
      darkTheme: AppTheme.dark(fontFamily: currentFont.fontFamily),
      themeMode: themeMode,
      
      // 国际化配置
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('zh', 'CN'),
      
      // 构建器配置
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.4),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}