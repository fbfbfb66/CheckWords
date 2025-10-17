import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/main_scaffold.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/user_profile_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/words/presentation/collected_words_page.dart';
import '../../features/words/presentation/word_detail_page.dart';
import '../../features/words/presentation/words_page.dart';
import '../../features/learning/presentation/learning_page.dart';
import '../../l10n/generated/l10n_simple.dart';
import 'route_paths.dart';

/// 应用程序路由器（无需登录验证）
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    routes: [
      // === 主要导航页面 ===
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) => const WordsPage(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),

      // === 详情和功能页面 ===
      GoRoute(
        path: RoutePaths.wordDetail,
        name: RouteNames.wordDetail,
        builder: (context, state) {
          final rawWordId = state.pathParameters['id'];
          if (rawWordId == null) {
            throw Exception('单词ID缺失');
          }

          final queryFromUri = state.uri.queryParameters['q'];
          String? searchQuery = queryFromUri;
          if (searchQuery == null && state.extra is Map) {
            final extraMap = state.extra as Map<dynamic, dynamic>;
            final extraQuery = extraMap['searchQuery'];
            if (extraQuery is String && extraQuery.isNotEmpty) {
              searchQuery = extraQuery;
            }
          }

          return WordDetailPage(
            wordId: int.parse(rawWordId),
            searchQuery: searchQuery,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.collectedWords,
        name: RouteNames.collectedWords,
        builder: (context, state) => const CollectedWordsPage(),
      ),
      GoRoute(
        path: RoutePaths.learning,
        name: RouteNames.learning,
        builder: (context, state) => const LearningPage(),
      ),
      GoRoute(
        path: RoutePaths.userProfile,
        name: RouteNames.userProfile,
        builder: (context, state) => const UserProfilePage(),
      ),
    ],
    errorBuilder: (context, state) {
      final error = state.error?.toString() ?? S.current.unknownError;
      String errorMessage;
      String errorTitle;

      // 添加调试日志
      print('🚨 GoRouter捕获错误: $error');
      print('🚨 错误类型: ${state.error.runtimeType}');

      // 简化错误分类逻辑 - 避免误判
      if (error.contains('not found') || error.contains('未找到') ||
                 error.contains('404') || error.contains('单词ID缺失')) {
        errorMessage = '请检查单词链接或返回首页';
        errorTitle = '页面未找到';
      } else {
        // 统一显示为加载失败，避免误判为网络错误
        errorMessage = '页面加载失败，请重试';
        errorTitle = '加载失败';
      }

      return Scaffold(
        appBar: AppBar(title: Text(errorTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              // 开发模式下显示详细错误信息
              Text(
                '错误详情: $error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '错误类型: ${state.error.runtimeType}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(RoutePaths.home),
                child: Text(S.current.home),
              ),
            ],
          ),
        ),
      );
    },
  );
});
