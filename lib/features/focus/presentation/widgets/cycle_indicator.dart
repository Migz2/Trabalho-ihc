import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/animation_constants.dart';

/// Indicator showing which cycle we're on (1 to 4)
class CycleIndicator extends StatelessWidget {
  final int currentCycle;
  final int totalCycles;
  final Brightness brightness;

  const CycleIndicator({
    Key? key,
    required this.currentCycle,
    required this.totalCycles,
    required this.brightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final accentColor =
        isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalCycles,
        (index) {
          final cycleNumber = index + 1;
          final isCompleted = cycleNumber < currentCycle;
          final isCurrent = cycleNumber == currentCycle;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: AnimatedContainer(
              duration: AnimationDurations.fast,
              curve: AnimationCurves.spring,
              width: isCurrent ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isCompleted
                    ? primaryColor
                    : isCurrent
                        ? accentColor
                        : dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}
