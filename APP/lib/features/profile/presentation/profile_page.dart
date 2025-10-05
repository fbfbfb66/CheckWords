import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/auth_provider.dart';

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
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(authNotifierProvider),
                child: const Text('重试'),
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
        title: const Text('我的'),
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
              '请登录',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              '登录后可以收藏单词、查看学习记录等功能',
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
                child: const Text('立即登录'),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            TextButton(
              onPressed: () => context.go(RoutePaths.register),
              child: const Text('还没有账户？立即注册'),
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
                  '收录单词',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(RoutePaths.collectedWords),
                  child: const Text('查看全部'),
                ),
              ],
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            // TODO: 实现从数据库获取真实统计数据
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLarge),
                child: Text(
                  '暂无收录数据',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            title: '学习记录',
            subtitle: '查看您的学习历史和进度',
            onTap: () {
              // TODO: 跳转到学习记录页面
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.trending_up,
            title: '学习统计',
            subtitle: '查看详细的学习数据分析',
            onTap: () {
              // TODO: 跳转到学习统计页面
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.backup,
            title: '数据备份',
            subtitle: '备份您的学习数据到云端',
            onTap: () {
              // TODO: 实现数据备份功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('数据备份功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: '帮助与反馈',
            subtitle: '获取帮助或提交反馈',
            onTap: () {
              // TODO: 跳转到帮助页面
            },
          ),
          
          const Divider(height: 1),
          
          _buildListTile(
            context,
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '应用版本和相关信息',
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
        const Text('一款离线优先的词汇学习应用'),
        const Text('帮助您更好地学习和记忆英语单词'),
      ],
    );
  }

}