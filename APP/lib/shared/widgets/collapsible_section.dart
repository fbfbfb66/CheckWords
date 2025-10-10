import 'package:flutter/material.dart';
import '../../app/theme/design_tokens.dart';

/// 可折叠的通用组件
/// 用于展示可以展开/折叠的内容区域，支持动画效果和状态保持
class CollapsibleSection extends StatefulWidget {
  /// 标题
  final String title;
  /// 内容项目数量（可选显示）
  final int? count;
  /// 子组件
  final Widget child;
  /// 是否默认展开
  final bool initiallyExpanded;
  /// 图标
  final IconData? icon;
  /// 是否显示边框
  final bool showBorder;
  /// 自定义颜色
  final Color? color;

  const CollapsibleSection({
    super.key,
    required this.title,
    this.count,
    required this.child,
    this.initiallyExpanded = false,
    this.icon,
    this.showBorder = true,
    this.color,
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: DesignTokens.animationDurationMedium,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return Card(
      elevation: widget.showBorder ? DesignTokens.elevationLow : DesignTokens.elevationNone,
      child: Column(
        children: [
          // 标题栏
          InkWell(
            onTap: _toggle,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(DesignTokens.radiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMedium),
              child: Row(
                children: [
                  // 图标
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 20,
                      color: color,
                    ),
                    const SizedBox(width: DesignTokens.spacingSmall),
                  ],

                  // 标题
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),

                  // 数量
                  if (widget.count != null && widget.count! > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                      ),
                      child: Text(
                        '${widget.count}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingSmall),
                  ],

                  // 展开/折叠图标
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: DesignTokens.animationDurationMedium,
                    child: Icon(
                      Icons.expand_more,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 内容区域
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: FadeTransition(
              opacity: _expandAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacingMedium),
                decoration: widget.showBorder
                    ? BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: theme.dividerColor,
                            width: DesignTokens.borderWidthThin,
                          ),
                        ),
                      )
                    : null,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 简化版的折叠组件，用于不需要复杂功能的场景
class SimpleCollapsibleSection extends StatelessWidget {
  /// 标题
  final String title;
  /// 子组件
  final Widget child;
  /// 是否默认展开
  final bool initiallyExpanded;
  /// 图标
  final IconData? icon;

  const SimpleCollapsibleSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CollapsibleSection(
      title: title,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
      showBorder: false,
      child: child,
    );
  }
}