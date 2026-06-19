import 'package:flutter/material.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_spacing.dart';

/// Widget to display coin balance (Honey currency)
class CoinDisplay extends StatelessWidget {
  final int coins;
  final TextStyle? textStyle;
  final double? iconSize;
  final MainAxisAlignment mainAxisAlignment;

  const CoinDisplay({
    Key? key,
    required this.coins,
    this.textStyle,
    this.iconSize = 24,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '🍯',
          style: TextStyle(fontSize: iconSize),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          coins.toString(),
          style: textStyle ?? context.textTitleMedium,
        ),
      ],
    );
  }
}
