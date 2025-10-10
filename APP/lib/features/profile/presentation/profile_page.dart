import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/favorites_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 我的页面
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // 监听 locale 变化以确保页面在语言切换时重建
    ref.watch(localeNotifierProvider);
    
    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text('${S.current.error}: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(authNotifierProvider),
                child: Text(S.current.retry),
              ),
            ],
          ),
        ),
      ),
      data: (authState) => _buildContent(context, authState.isAuthenticated),
    );
  }

  Widget _buildContent(BuildContext context, bool isAuthenticated) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.profile),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isAuthenticated 
            ? _buildAuthenticatedView(context) 
            : _buildUnauthenticatedView(context),
      ),
    );
  }

  /// 构建已登录视图
  Widget _buildAuthenticatedView(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        children: [
          // 用户信息卡片
          _buildUserInfoCard(context, currentUser),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 收录单词卡片
          _buildWordCollectionCard(context),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 功能列表
          _buildFunctionsList(context),
        ],
      ),
    );
  }

  /// 构建未登录视图
  Widget _buildUnauthenticatedView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: DesignTokens.spacingLarge),
            
            Text(
              S.current.pleaseLogin,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              S.current.loginToUseFullFeatures,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: DesignTokens.spacingXLarge),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(RoutePaths.login),
                child: Text(S.current.login),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            TextButton(
              onPressed: () => context.go(RoutePaths.register),
              child: Text(S.current.registerNowText),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserInfoCard(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Row(
          children: [
            // 头像
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: user?.avatarPath != null 
                  ? AssetImage(user!.avatarPath!) 
                  : null,
              child: user?.avatarPath == null 
                  ? Text(
                      user?.name?.substring(0, 1).toUpperCase() ?? 'G',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: DesignTokens.spacingLarge),
            
            // 用户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Goings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'user@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // 账号管理按钮
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(RoutePaths.accountManagement),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建收录单词卡片
  Widget _buildWordCollectionCard(BuildContext context) {
    final favoriteWordsCountAsync = ref.watch(favoriteWordsCountProvider);
    final favoriteWordsAsync = ref.watch(favoriteWordsProvider(limit: 3)); // 获取收藏的单词作为预览

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.collectedWords,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(RoutePaths.collectedWords),
                  child: Text(S.current.viewAll),
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacingMedium),

            // 显示收藏统计和预览
            favoriteWordsCountAsync.when(
              data: (count) {
                if (count == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLarge),
                      child: Text(
                        S.current.noCollectedData,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 统计信息
                    Text(
                      S.current.collectedCountWords(count),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (count > 0) ...[
                      const SizedBox(height: DesignTokens.spacingMedium),

                      // 最近收藏的单词预览
                      favoriteWordsAsync.when(
                        data: (words) {
                          if (words.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.recentWordsTitle,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: DesignTokens.spacingSmall),
                              Wrap(
                                spacing: DesignTokens.spacingSmall,
                                runSpacing: DesignTokens.spacingSmall,
                                children: words.take(3).map((word) {
                                  return Chip(
                                    label: Text(
                                      word.headWord,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        },
                        loading: () => const SizedBox(
                          height: 40,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (_, __) => Text(
                          '加载失败',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLarge),
                  child: Text(
                    '加载失败',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// 构建功能列表
  Widget _buildFunctionsList(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.history,
            title: S.current.learningRecordTitle,
            subtitle: S.current.learningRecordSubtitle,
            onTap: () {
              // TODO: 跳转到学习记录页面
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.trending_up,
            title: S.current.learningStatsTitle,
            subtitle: S.current.learningStatsSubtitle,
            onTap: () {
              // TODO: 跳转到学习统计页面
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.backup,
            title: S.current.dataBackupTitle,
            subtitle: S.current.dataBackupSubtitle,
            onTap: () {
              // TODO: 实现数据备份功能
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
              );
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: S.current.helpAndFeedbackTitle,
            subtitle: S.current.helpAndFeedbackSubtitle,
            onTap: () {
              // TODO: 跳转到帮助页面
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.info_outline,
            title: S.current.aboutTitle,
            subtitle: S.current.aboutSubtitle,
            onTap: () {
              // TODO: 显示关于对话框
              _showAboutDialog(context);
            },
          ),
          
        ],
      ),
    );
  }

  /// 构建列表项
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: titleColor != null 
            ? TextStyle(color: titleColor) 
            : null,
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'CheckWords',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.book, size: 48),
      children: [
        Text(S.current.appSubtitle),
        Text(S.current.appSubtitle),
      ],
    );
  }

}