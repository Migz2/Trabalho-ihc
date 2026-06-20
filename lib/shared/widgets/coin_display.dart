import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/utils/animation_constants.dart';

/// Widget to display coin amount in Honey app
/// Shows the honey emoji (🍯) with coin count.
/// Animates with a count-up + scale pulse whenever [coins] increases.
class CoinDisplay extends StatefulWidget {
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
  State<CoinDisplay> createState() => _CoinDisplayState();
}

class _CoinDisplayState extends State<CoinDisplay>
    with SingleTickerProviderStateMixin {
  late int _previousCoins;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _previousCoins = widget.coins;
    _pulseController = AnimationController(
      vsync: this,
      duration: AnimationDurations.fast,
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _pulseController,
      curve: AnimationCurves.standard,
    ));
  }

  @override
  void didUpdateWidget(CoinDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coins != oldWidget.coins) {
      _previousCoins = oldWidget.coins;
      if (widget.coins > oldWidget.coins) {
        _pulseController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: _buildCoinDisplay(context));
  }

  Widget _buildCoinDisplay(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = widget.textStyle ?? theme.textTheme.labelLarge!;

    final content = ScaleTransition(
      scale: _pulseAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.alignment,
        children: [
          const Text(
            '🍯',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(width: AppSpacing.xs),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: _previousCoins, end: widget.coins),
            duration: AnimationDurations.crawl,
            builder: (context, value, _) {
              return Text(
                value.toString(),
                style: textStyle,
              );
            },
          ),
        ],
      ),
    );

    if (!widget.showBackground) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: AppRadius.radiusFull,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
