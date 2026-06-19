import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';

/// Standard card component for Honey App
class HoneyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const HoneyCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Card(
      backgroundColor: backgroundColor,
      elevation: elevation ?? 1,
      shape: RoundedRectangleBorder(borderRadius: borderRadius ?? AppRadius.cardRadius),
      margin: margin ?? EdgeInsets.zero,
      child: Container(
        decoration: gradient != null
            ? BoxDecoration(
              gradient: gradient,
              borderRadius: borderRadius ?? AppRadius.cardRadius,
            )
            : null,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
