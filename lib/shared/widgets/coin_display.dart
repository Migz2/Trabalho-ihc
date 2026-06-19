import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';

/// Widget to display coin amount in Honey app
/// Shows the honey emoji (🍯) with coin count
class CoinDisplay extends StatelessWidget {
  final int coins;
  final TextStyle? textStyle;
  final MainAxisAlignment alignment;
  final bool showBackground;

  const CoinDisplay({
    Key? key,
    required this.coins,
    this.textStyle,
    this.alignment = MainAxisAlignment.center,
    this.showBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = this.textStyle ?? theme.textTheme.labelLarge!;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        Text(
          '🍯',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          coins.toString(),
          style: textStyle,
        ),
      ],
    );

    if (!showBackground) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1,
        ),
      ),
      child: content,
    );
  }
}

/// Simple coin amount text widget
class CoinText extends StatelessWidget {
  final int coins;
  final TextStyle? style;

  const CoinText({
    Key? key,
    required this.coins,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '🍯 $coins',
      style: style ?? Theme.of(context).textTheme.labelLarge,
    );
  }
}
