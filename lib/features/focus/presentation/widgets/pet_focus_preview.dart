import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../pet/domain/entities/pet_entity.dart';
import '../../../pet/domain/entities/pet_mood_enum.dart';
import '../../../pet/presentation/constants/pet_assets.dart';
import '../../../pet/presentation/providers/pet_provider.dart';
import '../../../shop/presentation/providers/shop_provider.dart';

String _moodEmoji(PetMood mood) {
  switch (mood) {
    case PetMood.ecstatic:
      return '🤩';
    case PetMood.happy:
      return '😊';
    case PetMood.content:
      return '🙂';
    case PetMood.neutral:
      return '😐';
    case PetMood.sad:
      return '😢';
    case PetMood.neglected:
      return '😞';
  }
}

String _motivationalText(PetEntity pet) {
  if (pet.isHungry) return 'Com fome... 🍖';
  switch (pet.computedMood) {
    case PetMood.ecstatic:
      return 'Super animada! 🎉';
    case PetMood.happy:
      return 'Feliz com você 😊';
    case PetMood.sad:
    case PetMood.neglected:
      return 'Com saudade... 😢';
    default:
      return 'Esperando por você 🐾';
  }
}

/// Live pet preview shown on the Focus screen, connected to [petProvider].
class PetFocusPreview extends ConsumerWidget {
  const PetFocusPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);
    final pet = petAsync.value;
    if (pet == null) return const SizedBox.shrink();

    ref.watch(shopProvider);
    final coinMultiplier = ref.read(shopProvider.notifier).currentBonuses.totalCoinMultiplier;
    final nextCycleCoins = (12 * coinMultiplier).round();

    return InkWell(
      onTap: () => GoRouter.of(context).go('/pet'),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            // Pet image
            Container(
              width: 64,
              height: 64,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Image.asset(
                PetAssets.getAssetForMood(pet.computedMood),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => Container(
                  color: (context.isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary)
                      .withOpacity(0.2),
                  child: const Center(
                    child: Text('🐾', style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          pet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: context.textPrimary,
                              ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '· ${_moodEmoji(pet.computedMood)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _motivationalText(pet),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Felicidade ',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.textHint,
                            ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: LinearProgressIndicator(
                            value: pet.happiness / 100,
                            backgroundColor: context.dividerColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.isDark
                                  ? AppColors.darkHappinessBar
                                  : AppColors.lightHappinessBar,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Next cycle coins
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+$nextCycleCoins🍯',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                ),
                Text(
                  'próximo ciclo',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.textHint,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
