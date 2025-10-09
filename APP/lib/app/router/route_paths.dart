/// 路由路径常量
class RoutePaths {
  RoutePaths._();

  // === 认证相关路由 ===
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // === 主要页面路由 ===
  static const String home = '/';
  static const String words = '/words';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // === 详情页面路由 ===
  static const String wordDetail = '/word/:id';
  static const String accountManagement = '/account';
  static const String collectedWords = '/collected-words';
  static const String learning = '/learning';

  // === 路由构建辅助方法 ===
  
  /// 构建单词详情页路由
  static String buildWordDetailPath(int wordId) => '/word/$wordId';
  
  /// 构建带搜索查询参数的单词详情页路由
  static String buildWordDetailPathWithQuery(int wordId, String query) {
    return '/word/$wordId?q=${Uri.encodeComponent(query)}';
  }
  
  /// 构建带查询参数的路由
  static String buildPathWithQuery(String path, Map<String, String> queryParams) {
    if (queryParams.isEmpty) return path;
    
    final query = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$path?$query';
  }
}

/// 路由名称常量
class RouteNames {
  RouteNames._();

  // === 认证相关路由名称 ===
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';

  // === 主要页面路由名称 ===
  static const String home = 'home';
  static const String words = 'words';
  static const String profile = 'profile';
  static const String settings = 'settings';

  // === 详情页面路由名称 ===
  static const String wordDetail = 'wordDetail';
  static const String accountManagement = 'accountManagement';
  static const String collectedWords = 'collectedWords';
  static const String learning = 'learning';
}

/// 底部导航栏标签枚举
enum BottomNavTab {
  words(
    tabIndex: 0,
    path: RoutePaths.home,
    name: RouteNames.home,
    icon: 'book',
    label: '单词',
  ),
  profile(
    tabIndex: 1,
    path: RoutePaths.profile,
    name: RouteNames.profile,
    icon: 'person',
    label: '我的',
  ),
  settings(
    tabIndex: 2,
    path: RoutePaths.settings,
    name: RouteNames.settings,
    icon: 'settings',
    label: '设置',
  );

  const BottomNavTab({
    required this.tabIndex,
    required this.path,
    required this.name,
    required this.icon,
    required this.label,
  });

  final int tabIndex;
  final String path;
  final String name;
  final String icon;
  final String label;

  /// 根据路径获取标签
  static BottomNavTab? fromPath(String path) {
    for (final tab in BottomNavTab.values) {
      if (tab.path == path) return tab;
    }
    return null;
  }

  /// 根据索引获取标签
  static BottomNavTab fromIndex(int index) {
    return BottomNavTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => BottomNavTab.words,
    );
  }
}