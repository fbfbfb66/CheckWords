import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/home/presentation/main_scaffold.dart';
import '../../features/profile/presentation/account_management_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/words/presentation/collected_words_page.dart';
import '../../features/words/presentation/word_detail_page.dart';
import '../../features/words/presentation/words_page.dart';
import '../../features/learning/presentation/learning_page.dart';
import '../../shared/models/user_model.dart';
import '../../shared/providers/auth_provider.dart';
import '../../l10n/generated/l10n_simple.dart';
import 'route_paths.dart';

/// 应用程序路由器
final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final currentPath = state.fullPath ?? RoutePaths.home;
      final isAuthRoute = _isAuthRoute(currentPath);
      final isProtectedRoute = _isProtectedRoute(currentPath);

      return authAsync.when(
        data: (authState) {
          final isAuthenticated =
              authState.isAuthenticated && authState.isValid;

          if (isAuthenticated && isAuthRoute) {
            return RoutePaths.home;
          }

          if (!isAuthenticated && isProtectedRoute) {
            return RoutePaths.login;
          }

          return null;
        },
        loading: () => null,
        error: (_, __) {
          if (!isAuthRoute && isProtectedRoute) {
            return RoutePaths.login;
          }

          return null;
        },
      );
    },
    routes: [
      // === 鐠併倛鐦夐惄绋垮彠 ===
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // === 鐢箑锛撴担鎿勭礄鎼存洟鍎寸€佃壈鍩呴敍?==
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

      // === 閻欘剛鐝涙い鐢告桨 ===
      GoRoute(
        path: RoutePaths.wordDetail,
        name: RouteNames.wordDetail,
        builder: (context, state) {
          final rawWordId = state.pathParameters['id'];
          if (rawWordId == null) {
            throw Exception('閸楁洝鐦滻D娑撳秷鍏樻稉铏光敄');
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
        path: RoutePaths.accountManagement,
        name: RouteNames.accountManagement,
        builder: (context, state) => const AccountManagementPage(),
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
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(S.current.error)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              S.current.networkError,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? S.current.unknownError,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: Text(S.current.home),
            ),
          ],
        ),
      ),
    ),
  );
});

bool _isAuthRoute(String location) {
  const authRoutes = {
    RoutePaths.login,
    RoutePaths.register,
    RoutePaths.forgotPassword,
  };
  return authRoutes.contains(location);
}

bool _isProtectedRoute(String location) {
  const protectedRoutes = {
    RoutePaths.accountManagement,
    RoutePaths.collectedWords,
    RoutePaths.learning,
  };
  return protectedRoutes.contains(location);
}
