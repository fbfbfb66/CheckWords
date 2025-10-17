import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/design_tokens.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../l10n/generated/l10n_simple.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/debug_service.dart';

/// 设置页面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.settings),
        centerTitle: true,
      ),
      body: themeSettings.when(
        data: (settings) => _buildSettingsContent(context, ref, settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('${S.current.error}: $error')),
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
            title: Text(S.current.themeSettings),
            subtitle: Text(S.current.appearanceCustomization),
          ),
          
          const Divider(height: 1),
          
          // 主题模式选择
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(S.current.themeMode),
            subtitle: Text(_getThemeModeDisplayName(settings.mode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeModeDialog(context, ref, settings.mode),
          ),
          
          const Divider(height: 1),
          
          // 字体设置
          ListTile(
            leading: const Icon(Icons.font_download_outlined),
            title: Text(S.current.font),
            subtitle: Text(_getFontDisplayName(settings.font)),
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
            title: Text(S.current.learningSettings),
            subtitle: Text(S.current.learningSettingsDescription),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(S.current.studyReminder),
            subtitle: Text(S.current.studyReminderDescription),
            trailing: Switch(
              value: true, // TODO: 从设置中读取
              onChanged: (value) {
                // TODO: 保存设置
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.featureNotImplemented)),
                );
              },
            ),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.volume_up_outlined),
            title: Text(S.current.autoPlayPronunciation),
            subtitle: Text(S.current.autoPlayPronunciationDescription),
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
            title: Text(S.current.reviewInterval),
            subtitle: Text(S.current.reviewIntervalDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
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
            title: Text(S.current.dataManagement),
            subtitle: Text(S.current.dataManagementDescription),
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text(S.current.dataSync),
            subtitle: Text(S.current.dataSyncDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(S.current.importWordbook),
            subtitle: Text(S.current.importWordbookDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
              );
            },
          ),
  
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: Text(S.current.exportData),
            subtitle: Text(S.current.exportDataDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
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
              S.current.clearData,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            subtitle: Text(S.current.clearDataDescription),
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
            title: Text(S.current.other),
            subtitle: Text(S.current.otherSettingsDescription),
          ),
          
          const Divider(height: 1),
          
          Consumer(
              builder: (context, ref, child) {
                final localeState = ref.watch(localeNotifierProvider);
                final currentLocale = localeState.currentLocale;
                return ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(S.current.language),
                  subtitle: Text(currentLocale.displayName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog<AppLocale>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(S.current.language),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: AppLocale.values.map((locale) => RadioListTile<AppLocale>(
                            value: locale,
                            groupValue: currentLocale,
                            title: Text(locale.displayName),
                            onChanged: (value) => Navigator.of(context).pop(value),
                          )).toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(S.current.cancel),
                          ),
                        ],
                      ),
                    ).then((selectedLocale) {
                      if (selectedLocale != null && selectedLocale != currentLocale) {
                        ref.read(localeNotifierProvider.notifier).changeLocale(selectedLocale);
                      }
                    });
                  },
                );
              },
            ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: Text(S.current.privacySettings),
            subtitle: Text(S.current.privacySettingsDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(S.current.feedback),
            subtitle: Text(S.current.feedbackDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
              );
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(S.current.rateApp),
            subtitle: Text(S.current.rateAppDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.featureNotImplemented)),
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
              S.current.offlineFirst,
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
        title: Text(S.current.themeMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) => RadioListTile<AppThemeMode>(
            value: mode,
            groupValue: currentMode,
            title: Text(_getThemeModeDisplayName(mode)),
            onChanged: (value) => Navigator.of(context).pop(value),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.cancel),
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
        title: Text(S.current.clearData),
        content: Text(S.current.clearDataWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.current.clear),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        // TODO: 实现清除数据功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.featureNotImplemented)),
        );
      }
    });
  }

  
  /// 显示字体选择对话框
  void _showFontSelectionDialog(BuildContext context, WidgetRef ref, AppFont currentFont) {
    showDialog<AppFont>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.font),
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
                              _getFontDisplayName(font),
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
            child: Text(S.current.cancel),
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

  /// 获取字体显示名称（国际化）
  String _getFontDisplayName(AppFont font) {
    switch (font) {
      case AppFont.system:
        return S.current.appDefault; // 使用系统默认
      case AppFont.inter:
        return S.current.fontInter; // Inter
      case AppFont.sourceHanSans:
        return S.current.fontSourceHanSans; // 思源黑体
    }
  }

  /// 获取主题模式显示名称（国际化）
  String _getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return S.current.followSystem; // 跟随系统
      case AppThemeMode.light:
        return S.current.lightMode; // 浅色模式
      case AppThemeMode.dark:
        return S.current.darkMode; // 深色模式
    }
  }


}