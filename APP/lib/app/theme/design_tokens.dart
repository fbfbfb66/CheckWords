/// 设计规范 - Design Tokens
/// 包含间距、字体、圆角、阴影等设计原子
class DesignTokens {
  // 私有构造函数
  DesignTokens._();

  // === 间距系统 (基于4pt网格) ===
  static const double spacingXSmall = 4.0;   // 4pt
  static const double spacingSmall = 8.0;    // 8pt
  static const double spacingMedium = 16.0;  // 16pt
  static const double spacingLarge = 24.0;   // 24pt
  static const double spacingXLarge = 32.0;  // 32pt
  static const double spacingXXLarge = 48.0; // 48pt

  // === 圆角系统 ===
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusFull = 9999.0; // 完全圆角

  // === 字体系统 ===
  static const String defaultFontFamily = 'Inter';
  static const String chineseFontFamily = 'SourceHanSansSC';

  // 字体大小
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;

  // 字重
  static const int fontWeightRegular = 400;
  static const int fontWeightMedium = 500;
  static const int fontWeightSemiBold = 600;
  static const int fontWeightBold = 700;

  // === 触控目标尺寸 ===
  static const double minTouchTarget = 48.0; // 最小触控目标 (Material Design)
  static const double minListItemHeight = 44.0; // 最小列表项高度

  // === 阴影层级 ===
  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMedium = 3.0;
  static const double elevationHigh = 6.0;
  static const double elevationMax = 12.0;

  // === 动画时长 ===
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 250);
  static const Duration animationDurationSlow = Duration(milliseconds: 400);

  // === 动画曲线 ===
  // 使用Material Design推荐的缓动曲线
  // 标准缓动 - 用于页面转换
  static const List<double> easingStandard = [0.2, 0.0, 0, 1.0];
  // 减速缓动 - 用于进入动画
  static const List<double> easingDecelerate = [0.0, 0.0, 0.2, 1.0];
  // 加速缓动 - 用于退出动画  
  static const List<double> easingAccelerate = [0.4, 0.0, 1.0, 1.0];
  // 强调缓动 - 用于重要的状态变化
  static const List<double> easingEmphasized = [0.2, 0.0, 0, 1.0];

  // === 断点系统 ===
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointLargeDesktop = 1440.0;

  // === Z-Index层级 ===
  static const int zIndexBase = 0;
  static const int zIndexDropdown = 1000;
  static const int zIndexModal = 1050;
  static const int zIndexPopover = 1060;
  static const int zIndexTooltip = 1070;
  static const int zIndexToast = 1080;

  // === 透明度 ===
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;

  // === 边框宽度 ===
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 4.0;
}

/// 响应式设计辅助类
class ResponsiveBreakpoints {
  // 私有构造函数
  ResponsiveBreakpoints._();

  /// 检查是否为移动端
  static bool isMobile(double width) => width < DesignTokens.breakpointTablet;

  /// 检查是否为平板端
  static bool isTablet(double width) =>
      width >= DesignTokens.breakpointTablet && width < DesignTokens.breakpointDesktop;

  /// 检查是否为桌面端
  static bool isDesktop(double width) => width >= DesignTokens.breakpointDesktop;

  /// 获取响应式间距
  static double getResponsiveSpacing(double width) {
    if (isMobile(width)) return DesignTokens.spacingMedium;
    if (isTablet(width)) return DesignTokens.spacingLarge;
    return DesignTokens.spacingXLarge;
  }

  /// 获取响应式字体大小倍数
  static double getResponsiveFontScale(double width) {
    if (isMobile(width)) return 1.0;
    if (isTablet(width)) return 1.1;
    return 1.2;
  }
}