import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';

/// 主应用脚手架，包含底部导航栏
class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavigationBar(),
    );
  }
}

/// 底部导航栏
class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).fullPath ?? '/';
    final currentTab = _getCurrentTab(currentLocation);

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
          label: tab.label,
        );
      }).toList(),
    );
  }

  /// 获取当前选中的标签
  BottomNavTab _getCurrentTab(String location) {
    return BottomNavTab.fromPath(location) ?? BottomNavTab.words;
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