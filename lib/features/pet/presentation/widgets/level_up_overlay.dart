import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Full-screen celebration shown when the pet levels up.
class LevelUpOverlay {
  static void show(BuildContext context, {required int newLevel}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _LevelUpContent(
        newLevel: newLevel,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 3200), () {
      entry.remove();
    });
  }
}

class _LevelUpContent extends StatelessWidget {
  final int newLevel;
  final VoidCallback onDismiss;

  const _LevelUpContent({required this.newLevel, required this.onDismiss});

  Widget _star(double angleDeg, int delayMs) {
    final rad = angleDeg * math.pi / 180;
    final offset = Offset(math.cos(rad) * 110, math.sin(rad) * 110);
    return Positioned(
      left: 130 + offset.dx,
      top: 130 + offset.dy,
      child: const Text('⭐', style: TextStyle(fontSize: 20))
          .animate(delay: delayMs.ms)
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 500.ms,
            curve: Curves.elasticOut,
          )
          .then(delay: 600.ms)
          .fadeOut(duration: 400.ms),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.black.withOpacity(0.45),
        child: Center(
          child: SizedBox(
            width: 280,
            height: 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _star(-70, 0),
                _star(-20, 150),
                _star(40, 300),
                _star(110, 450),
                _star(180, 600),
                Container(
                  width: 260,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🐻', style: TextStyle(fontSize: 56))
                          .animate(onPlay: (c) => c.repeat())
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.15, 1.15),
                            duration: 500.ms,
                          )
                          .then()
                          .scale(
                            begin: const Offset(1.15, 1.15),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                          ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Mel subiu de nível!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Nível $newLevel',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ).animate().scale(delay: 300.ms, curve: Curves.elasticOut),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}
