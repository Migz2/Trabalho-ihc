import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Self-contained shimmer placeholder (no external package) used while
/// loading list/card content.
class HoneyShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const HoneyShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  State<HoneyShimmer> createState() => _HoneyShimmerState();
}

class _HoneyShimmerState extends State<HoneyShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase;
    final highlight =
        isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final value = -1.0 + _controller.value * 3.0;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + value, 0),
              end: Alignment(value, 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}
