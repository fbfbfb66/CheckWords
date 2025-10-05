import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/debug_service.dart';
import '../../words/presentation/debug_helper.dart';

/// 设置页面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: themeSettings.when(
        data: (settings) => _buildSettingsContent(context, ref, settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败：$error')),
      ),
    );
  }

  /// 构建设置内容
  Widget _buildSettingsContent(BuildContext context, WidgetRef ref, ThemeSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        children: [
          // 外观设置
          _buildAppearanceSection(context, ref, settings),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 学习设置
          _buildLearningSection(context, ref),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 数据设置
          _buildDataSection(context, ref),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 其他设置
          _buildOtherSection(context),
          
          const SizedBox(height: DesignTokens.spacingXLarge),
          
          // 版本信息
          _buildVersionInfo(context),
        ],
      ),
    );
  }

  /// 构建外观设置区域
  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref, ThemeSettings settings) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.palette_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('外观设置'),
            subtitle: const Text('自定义应用的外观和感觉'),
          ),
          
          const Divider(height: 1),
          
          // 主题模式选择
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('主题模式'),
            subtitle: Text(_getThemeDisplayText(context, settings.mode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeModeDialog(context, ref, settings.mode),
          ),
          
          const Divider(height: 1),
          
          // 字体设置
          ListTile(
            leading: const Icon(Icons.font_download_outlined),
            title: const Text('字体'),
            subtitle: Text(settings.font.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFontSelectionDialog(context, ref, settings.font),
          ),
        ],
      ),
    );
  }

  /// 构建学习设置区域
  Widget _buildLearningSection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.school_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('学习设置'),
            subtitle: const Text('配置学习相关的选项'),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('学习提醒'),
            subtitle: const Text('设置定时学习提醒'),
            trailing: Switch(
              value: true, // TODO: 从设置中读取
              onChanged: (value) {
                // TODO: 保存设置
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('学习提醒功能待实现')),
                );
              },
            ),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.volume_up_outlined),
            title: const Text('自动播放发音'),
            subtitle: const Text('查看单词时自动播放发音'),
            trailing: Switch(
              value: false, // TODO: 从设置中读取
              onChanged: (value) {
                // TODO: 保存设置
              },
            ),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.speed_outlined),
            title: const Text('复习间隔'),
            subtitle: const Text('调整记忆曲线的复习间隔'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('复习间隔设置待实现')),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建数据设置区域
  Widget _buildDataSection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.storage_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('数据管理'),
            subtitle: const Text('管理您的学习数据'),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: const Text('数据同步'),
            subtitle: const Text('将数据同步到云端'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('数据同步功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('导入单词库'),
            subtitle: const Text('从文件导入单词数据'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('导入单词库功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.build_outlined),
            title: const Text('数据库诊断'),
            subtitle: const Text('检查数据库状态和修复问题'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => DebugHelper.showQuickDiagnosis(context, ref),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('导出数据'),
            subtitle: const Text('导出您的学习数据'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('导出数据功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              '清除数据',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            subtitle: const Text('清除所有本地数据'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }

  /// 构建其他设置区域
  Widget _buildOtherSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('其他'),
            subtitle: const Text('更多设置选项'),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('语言'),
            subtitle: const Text('简体中文'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('语言设置功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('隐私设置'),
            subtitle: const Text('管理隐私相关设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('隐私设置功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('意见反馈'),
            subtitle: const Text('向我们提供您的建议'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('意见反馈功能待实现')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('评价应用'),
            subtitle: const Text('在应用商店给我们评分'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('评价功能待实现')),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建版本信息
  Widget _buildVersionInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          children: [
            Icon(
              Icons.book_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              'CheckWords',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSmall),
            
            Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSmall),
            
            Text(
              '离线优先的词汇学习应用',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示主题模式选择对话框
  void _showThemeModeDialog(BuildContext context, WidgetRef ref, AppThemeMode currentMode) {
    showDialog<AppThemeMode>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择主题模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) => RadioListTile<AppThemeMode>(
            value: mode,
            groupValue: currentMode,
            title: Text(mode.label),
            onChanged: (value) => Navigator.of(context).pop(value),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    ).then((selectedMode) {
      if (selectedMode != null && selectedMode != currentMode) {
        ref.read(themeSettingsNotifierProvider.notifier).updateThemeMode(selectedMode);
      }
    });
  }

  /// 显示清除数据对话框
  void _showClearDataDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除数据'),
        content: const Text('此操作将清除所有本地数据，包括收藏的单词、学习记录等，且无法恢复。确定要继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('清除'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        // TODO: 实现清除数据功能
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('清除数据功能待实现')),
        );
      }
    });
  }

  /// 获取主题显示文本
  String _getThemeDisplayText(BuildContext context, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        final brightness = MediaQuery.of(context).platformBrightness;
        final currentMode = brightness == Brightness.dark ? '深色' : '浅色';
        return '跟随系统 (当前: $currentMode)';
      case AppThemeMode.light:
        return '浅色模式';
      case AppThemeMode.dark:
        return '深色模式';
    }
  }

  /// 显示字体选择对话框
  void _showFontSelectionDialog(BuildContext context, WidgetRef ref, AppFont currentFont) {
    showDialog<AppFont>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择字体'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppFont.values.map((font) => Container(
              margin: const EdgeInsets.only(bottom: DesignTokens.spacingSmall),
              decoration: BoxDecoration(
                border: Border.all(
                  color: currentFont == font 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  width: currentFont == font ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                onTap: () => Navigator.of(context).pop(font),
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<AppFont>(
                            value: font,
                            groupValue: currentFont,
                            onChanged: (value) => Navigator.of(context).pop(value),
                          ),
                          Expanded(
                            child: Text(
                              font.label,
                              style: TextStyle(
                                fontFamily: font.fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacingSmall),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getFontPreviewText(font),
                              style: TextStyle(
                                fontFamily: font.fontFamily,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFontPreviewEnglish(font),
                              style: TextStyle(
                                fontFamily: font.fontFamily,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    ).then((selectedFont) {
      if (selectedFont != null && selectedFont != currentFont) {
        ref.read(themeSettingsNotifierProvider.notifier).updateFont(selectedFont);
      }
    });
  }

  /// 获取字体预览文本（中文）
  String _getFontPreviewText(AppFont font) {
    switch (font) {
      case AppFont.system:
        return '跟随系统设置，通常为默认字体';
      case AppFont.inter:
        return '现代化设计，适合阅读英文内容';
      case AppFont.sourceHanSans:
        return '专为中文优化，清晰易读的无衬线字体';
    }
  }

  /// 获取字体预览文本（英文）
  String _getFontPreviewEnglish(AppFont font) {
    switch (font) {
      case AppFont.system:
        return 'System Default Font - Aa Bb Cc 123';
      case AppFont.inter:
        return 'Inter Font - Aa Bb Cc 123 /ˈɪntər/';
      case AppFont.sourceHanSans:
        return 'Source Han Sans - Aa Bb Cc 123';
    }
  }

}