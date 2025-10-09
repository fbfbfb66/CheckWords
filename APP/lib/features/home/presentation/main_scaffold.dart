import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 主应用脚手架，包含底部导航栏
class MainScaffold extends ConsumerWidget {
  const MainScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 locale 变化以确保底部导航栏文本更新
    ref.watch(localeNotifierProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }
}

/// 底部导航栏
class _BottomNavigationBar extends ConsumerWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 locale 变化
    final localeState = ref.watch(localeNotifierProvider);
    final currentLocation = GoRouterState.of(context).fullPath ?? '/';
    final currentTab = _getCurrentTab(currentLocation);

    // 使用 Localizations.override 确保底部导航栏使用最新的语言环境
    return Localizations.override(
      context: context,
      locale: localeState.currentLocale.locale,
      child: Builder(
        builder: (context) {
          return NavigationBar(
            selectedIndex: currentTab.tabIndex,
            onDestinationSelected: (index) {
              final tab = BottomNavTab.fromIndex(index);
              if (currentLocation != tab.path) {
                context.go(tab.path);
              }
            },
            destinations: BottomNavTab.values.map((tab) {
              return NavigationDestination(
                icon: _buildIcon(tab.icon, false),
                selectedIcon: _buildIcon(tab.icon, true),
                label: _getTabLabel(tab, context),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  /// 获取当前选中的标签
  BottomNavTab _getCurrentTab(String location) {
    return BottomNavTab.fromPath(location) ?? BottomNavTab.words;
  }

  /// 获取标签文本（国际化）
  String _getTabLabel(BottomNavTab tab, BuildContext context) {
    switch (tab) {
      case BottomNavTab.words:
        return S.current.words; // 需要在 l10n 中添加 words
      case BottomNavTab.profile:
        return S.current.profile; // 需要在 l10n 中添加 profile
      case BottomNavTab.settings:
        return S.current.settings;
    }
  }

  /// 构建图标
  Widget _buildIcon(String iconName, bool isSelected) {
    IconData iconData;

    switch (iconName) {
      case 'book':
        iconData = isSelected ? Icons.book : Icons.book_outlined;
        break;
      case 'person':
        iconData = isSelected ? Icons.person : Icons.person_outline;
        break;
      case 'settings':
        iconData = isSelected ? Icons.settings : Icons.settings_outlined;
        break;
      default:
        iconData = Icons.help_outline;
    }

    return Icon(iconData);
  }
}