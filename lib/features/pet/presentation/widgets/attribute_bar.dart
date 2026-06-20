import 'package:flutter/material.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/core/utils/animation_constants.dart';

class AttributeBar extends StatelessWidget {
  final String label;
  final double value; // 0-100
  final Color barColor;

  const AttributeBar({
    Key? key,
    required this.label,
    required this.value,
    required this.barColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = value.round().toString();
    final trackColor =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final clampedValue = value.clamp(0.0, 100.0);

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 12,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: clampedValue),
                  duration: AnimationDurations.slow,
                  curve: AnimationCurves.standard,
                  builder: (context, animatedValue, _) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: animatedValue / 100,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 44,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }
}
