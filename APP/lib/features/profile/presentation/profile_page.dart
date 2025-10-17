import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/favorites_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 个人设置页面
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);

    // 监听 locale 变化以确保页面在语言切换时重建
    ref.watch(localeNotifierProvider);

    return userState.when(
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
                onPressed: () => ref.refresh(userNotifierProvider),
                child: Text(S.current.retry),
              ),
            ],
          ),
        ),
      ),
      data: (userState) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.profile),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildUserView(context),
      ),
    );
  }

  /// 构建用户设置视图
  Widget _buildUserView(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        children: [
          // 头像设置卡片
          _buildAvatarCard(context, currentUser),

          const SizedBox(height: DesignTokens.spacingLarge),

          // 学习统计卡片
          _buildLearningStatsCard(context),

          const SizedBox(height: DesignTokens.spacingLarge),

          // 应用设置列表
          _buildSettingsList(context),
        ],
      ),
    );
  }

  /// 构建头像设置卡片
  Widget _buildAvatarCard(BuildContext context, user) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: user?.avatarPath != null
              ? DecorationImage(
                  image: AssetImage(user!.avatarPath!) as ImageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            // 背景渐变效果
            if (user?.avatarPath == null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

            // 默认头像文字（当没有头像时）
            if (user?.avatarPath == null)
              Center(
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name.substring(0, 1).toUpperCase() : '学',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // 半透明渐变遮罩（用于确保文字清晰可见）
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // 左下角用户名
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                user?.name.isNotEmpty == true ? user!.name : '学习者',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),

            // 右上角details按钮
            Positioned(
              right: 16,
              top: 16,
              child: GestureDetector(
                onTap: () => _navigateToUserProfile(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'details',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2.0,
                          color: Colors.black45,
                        ),
                      ],
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

  /// 构建学习统计卡片
  Widget _buildLearningStatsCard(BuildContext context) {
    final favoriteWordsCountAsync = ref.watch(favoriteWordsCountProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '学习统计',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),

            // 显示收藏统计
            favoriteWordsCountAsync.when(
              data: (count) {
                return Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '已收藏 $count 个单词',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(
                '加载统计失败',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建应用设置列表
  Widget _buildSettingsList(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.bookmark_border_outlined),
            title: Text(S.current.myFavorites),
            onTap: () => context.push(RoutePaths.collectedWords),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text(S.current.learningMode),
            onTap: () => context.push(RoutePaths.learning),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(S.current.aboutApp),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  /// 显示头像选择选项
  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.current.fromGallery),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现从相册选择头像
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.featureInDevelopment)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.current.takePhoto),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现拍照头像
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.featureInDevelopment)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(S.current.removeAvatar),
              onTap: () {
                Navigator.pop(context);
                _removeAvatar();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 移除头像
  void _removeAvatar() async {
    try {
      await ref.read(userNotifierProvider.notifier).updateProfile(
        UpdateProfileRequest(avatarPath: null),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.avatarRemoved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.current.operationFailed}: $e')),
        );
      }
    }
  }

  /// 导航到用户详情页
  void _navigateToUserProfile(BuildContext context) {
    context.push('/user-profile');
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'CheckWords',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.book, size: 48),
      children: [
        Text(S.current.appDescription),
      ],
    );
  }
}