import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'core/services/data_import_service.dart';
import 'l10n/generated/l10n_simple.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/words_provider.dart';
import 'shared/utils/app_logger.dart';
import 'shared/utils/permission_helper.dart';

Future<void> main() async {
  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 🔐 请求存储权限（真机数据导入必需）
      print('🔐 [MAIN] 检查存储权限...');
      final hasPermissions = await PermissionHelper.requestStoragePermissions();
      if (!hasPermissions) {
        print('❌ [MAIN] 存储权限被拒绝，数据导入可能失败');
      } else {
        print('✅ [MAIN] 存储权限检查通过');
      }

      // 显示权限状态
      final permissionStatus = await PermissionHelper.getPermissionStatus();
      print('📋 [MAIN] 权限状态: $permissionStatus');

      final database = await AppDatabase.initialize();

      try {
        print('🚀 [MAIN] Starting data import from assets...');
        print('🚀 [MAIN] Database initialized: ${database.runtimeType}');

        // 导入词汇数据
        final importSuccess = await DataImportService.importWordsData(database);
        if (importSuccess) {
          print('✅ [MAIN] Data import completed successfully');
        } else {
          print('❌ [MAIN] Data import failed');
        }

        // 检查导入结果
        final countResult = await database.customSelect('SELECT COUNT(*) as count FROM words_table').getSingle();
        final wordCount = countResult.data['count'] as int;
        print('📊 [MAIN] Total words in database after import: $wordCount');

        print('✅ [MAIN] Data initialization process completed');
      } catch (error, stackTrace) {
        print('❌ [MAIN] Initial data preparation failed: $error');
        AppLogger.error(
          'Initial data preparation failed',
          error: error,
          stackTrace: stackTrace,
        );
      }

      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(database)],
      );

      Timer(const Duration(seconds: 5), () async {
        try {
          final status = await container.read(databaseStatusProvider.future);
          if (status.totalWords > 0) {
            AppLogger.verbose('Word data import succeeded');
            AppLogger.verbose('Total words: ${status.totalWords}');
            AppLogger.verbose(
                'Words with pronunciation: ${status.wordsWithPronunciation}');
            AppLogger.verbose(
              'Sample words: ${status.sampleWords.take(5).join(', ')}',
            );

            const testWords = [
              'access',
              'accident',
              'accidentally',
              'accompany',
              'accomplish',
              'accord',
              'account',
              'accumulate',
              'accurate',
              'accuse',
            ];
            for (final word in testWords) {
              try {
                final wordResult =
                    await container.read(wordByNameProvider(word).future);
                if (wordResult != null) {
                  AppLogger.verbose(
                      'Test word available: $word (ID: ${wordResult.id})');
                } else {
                  AppLogger.debug('Test word missing: $word');
                }
              } catch (lookupError) {
                AppLogger.debug(
                    'Test word lookup failed for $word: $lookupError');
              }
            }
          } else {
            AppLogger.debug(
                'Word data import finished but produced zero rows.');
          }
        } catch (statusError) {
          AppLogger.debug('Failed to verify database status: $statusError');
        }
      });

      await container.read(localeNotifierProvider.notifier).initialize();

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const CheckWordsApp(),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.error(
        'Uncaught top-level error',
        error: error,
        stackTrace: stackTrace,
      );
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        if (_shouldSuppressPrint(line)) {
          return;
        }
        parent.print(zone, line);
      },
    ),
  );
}

bool _shouldSuppressPrint(String message) {
  final trimmed = message.trimLeft();
  if (trimmed.isEmpty) {
    return true;
  }

  final lower = trimmed.toLowerCase();
  if (lower.contains('error') || trimmed.contains('错误')) {
    return false;
  }

  const noisyPrefixes = <String>[
    '🔍',
    // '✅', // 保留成功日志用于调试
    // '❌', // 保留错误日志用于调试
    '🚨',
    '🧪',
    '🧹',
    '🔄',
    '   -',
  ];

  for (final prefix in noisyPrefixes) {
    if (trimmed.startsWith(prefix)) {
      return true;
    }
  }

  return false;
}

class CheckWordsApp extends ConsumerWidget {
  const CheckWordsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentFont = ref.watch(currentFontProvider);
    final localeState = ref.watch(localeNotifierProvider);

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
