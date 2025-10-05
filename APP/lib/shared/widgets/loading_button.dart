import 'package:flutter/material.dart';

import '../../app/theme/design_tokens.dart';

/// 带加载状态的按钮
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.loadingColor,
    this.disabledColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final Color? loadingColor;
  final Color? disabledColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  loadingColor ?? theme.colorScheme.onPrimary,
                ),
              ),
            )
          : child,
    );
  }
}

/// 带加载状态的文本按钮
class LoadingTextButton extends StatelessWidget {
  const LoadingTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.loadingColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  loadingColor ?? theme.colorScheme.primary,
                ),
              ),
            )
          : child,
    );
  }
}

/// 带加载状态的轮廓按钮
class LoadingOutlinedButton extends StatelessWidget {
  const LoadingOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.loadingColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  loadingColor ?? theme.colorScheme.primary,
                ),
              ),
            )
          : child,
    );
  }
}

/// 浮动操作按钮（带加载状态）
class LoadingFloatingActionButton extends StatelessWidget {
  const LoadingFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingColor,
    this.heroTag,
    this.elevation,
    this.mini = false,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? loadingColor;
  final Object? heroTag;
  final double? elevation;
  final bool mini;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      heroTag: heroTag,
      elevation: elevation,
      mini: mini,
      tooltip: tooltip,
      child: isLoading
          ? SizedBox(
              height: mini ? 16 : 20,
              width: mini ? 16 : 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  loadingColor ?? foregroundColor ?? theme.colorScheme.onPrimary,
                ),
              ),
            )
          : child,
    );
  }
}

/// 带图标和加载状态的按钮
class LoadingIconButton extends StatelessWidget {
  const LoadingIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.isLoading = false,
    this.style,
    this.loadingSize = 16,
    this.loadingColor,
    this.spacing = DesignTokens.spacingSmall,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Widget? label;
  final bool isLoading;
  final ButtonStyle? style;
  final double loadingSize;
  final Color? loadingColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buttonChild = isLoading
        ? SizedBox(
            height: loadingSize,
            width: loadingSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                loadingColor ?? theme.colorScheme.onPrimary,
              ),
            ),
          )
        : icon;

    if (label != null && !isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buttonChild,
          SizedBox(width: spacing),
          label!,
        ],
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: buttonChild,
    );
  }
}