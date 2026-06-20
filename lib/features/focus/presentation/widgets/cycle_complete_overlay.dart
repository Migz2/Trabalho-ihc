import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/animation_constants.dart';

/// Shows a celebratory overlay when a focus cycle completes, auto-dismissing
/// after 2.5s. Call [show] with the BuildContext from inside the screen.
class CycleCompleteOverlay {
  static void show(BuildContext context, {required int coinsEarned}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _CycleCompleteContent(coinsEarned: coinsEarned),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 2500), () {
      entry.remove();
    });
  }
}

class _CycleCompleteContent extends StatefulWidget {
  final int coinsEarned;

  const _CycleCompleteContent({required this.coinsEarned});

  @override
  State<_CycleCompleteContent> createState() => _CycleCompleteContentState();
}

class _CycleCompleteContentState extends State<_CycleCompleteContent> {
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted) setState(() => _dismissing = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedOpacity(
      opacity: _dismissing ? 0.0 : 1.0,
      duration: AnimationDurations.fast,
      child: Material(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 48))
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Ciclo completo!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '+${widget.coinsEarned} moedas',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                )
                    .animate()
                    .slideY(begin: 0.3, end: 0, delay: 300.ms)
                    .fadeIn(delay: 300.ms),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Mel ficou mais feliz 🐾',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 200.ms),
    );
  }
}
