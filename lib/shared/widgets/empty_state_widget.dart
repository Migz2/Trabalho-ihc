import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/animation_constants.dart';

/// Generic empty/error state visual used across screens
/// (no sessions yet, shop failed to load, etc).
class EmptyStateWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyStateWidget({
    Key? key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 80))
              .animate(onPlay: (c) => c.repeat())
              .moveY(begin: 0, end: -8, duration: 2000.ms, curve: Curves.easeInOut)
              .then()
              .moveY(begin: -8, end: 0, duration: 2000.ms, curve: Curves.easeInOut),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AnimationDurations.slow)
        .slideY(begin: 0.1, end: 0, duration: AnimationDurations.slow);
  }
}
