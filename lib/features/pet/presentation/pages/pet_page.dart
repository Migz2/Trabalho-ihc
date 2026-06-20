import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:honey/core/extensions/context_extensions.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/theme/app_radius.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/focus/presentation/providers/user_provider.dart';
import 'package:honey/features/pet/presentation/providers/pet_provider.dart';
import 'package:honey/features/pet/presentation/widgets/action_button.dart';
import 'package:honey/features/pet/presentation/widgets/attribute_bar.dart';
import 'package:honey/features/pet/presentation/widgets/pet_display_widget.dart';
import 'package:honey/shared/widgets/coin_display.dart';
import 'package:honey/shared/widgets/honey_shimmer.dart';

class PetPage extends ConsumerWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);
    final userCoins = ref.watch(userProvider.select((u) => u.value?.coins ?? 0));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return petAsync.when(
      loading: () => _buildScaffold(
        context: context,
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const HoneyShimmer(width: double.infinity, height: 200),
              const SizedBox(height: AppSpacing.lg),
              const HoneyShimmer(width: double.infinity, height: 24),
              const SizedBox(height: 12),
              const HoneyShimmer(width: double.infinity, height: 24),
              const SizedBox(height: 12),
              const HoneyShimmer(width: double.infinity, height: 24),
            ],
          ),
        ),
      ),
      error: (error, stack) => _buildScaffold(
        context: context,
        isDark: isDark,
        child: Center(
          child: Text('Erro ao carregar Mel: $error'),
        ),
      ),
      data: (pet) {
        return _buildScaffold(
          context: context,
          isDark: isDark,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with pet info and coin display
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seu companheiro · ${pet.moodPT}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${pet.name} 🐾',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      CoinDisplay(coins: userCoins),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Pet card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        // Pet location and level info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '🏡 Quintal',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            Text(
                              'Nível ${pet.level} · x1.00🍯',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Pet display
                        RepaintBoundary(
                          child: PetDisplayWidget(
                            pet: pet,
                            size: 180,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Attribute bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        AttributeBar(
                          label: 'Fome',
                          value: pet.hunger,
                          barColor: isDark
                              ? AppColors.darkHungerBar
                              : AppColors.lightHungerBar,
                        ),
                        const SizedBox(height: 12),
                        AttributeBar(
                          label: 'Higiene',
                          value: pet.hygiene,
                          barColor: isDark
                              ? AppColors.darkHygieneBar
                              : AppColors.lightHygieneBar,
                        ),
                        const SizedBox(height: 12),
                        AttributeBar(
                          label: 'Felicidade',
                          value: pet.happiness,
                          barColor: isDark
                              ? AppColors.darkHappinessBar
                              : AppColors.lightHappinessBar,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        label: 'Alimentar',
                        icon: '🍖',
                        costText: '🍯 10',
                        iconBackgroundColor: AppColors.lightHungerBar
                            .withOpacity(isDark ? 0.25 : 0.15),
                        onTap: () => _handleFeed(context, ref),
                      ),
                      ActionButton(
                        label: 'Dar banho',
                        icon: '💧',
                        costText: '🍯 15',
                        iconBackgroundColor: AppColors.lightHygieneBar
                            .withOpacity(isDark ? 0.25 : 0.15),
                        onTap: () => _handleBathe(context, ref),
                      ),
                      ActionButton(
                        label: 'Carinho',
                        icon: '❤️',
                        costText: '🍯 5',
                        iconBackgroundColor: AppColors.lightHappinessBar
                            .withOpacity(isDark ? 0.25 : 0.15),
                        onTap: () => _handleLove(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScaffold({
    required BuildContext context,
    required bool isDark,
    required Widget child,
  }) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(child: child),
    );
  }

  Future<bool> _handleFeed(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(petProvider.notifier).feed();
    if (!context.mounted) return result.success;

    _showFeedback(context, result.message, result.success);
    return result.success;
  }

  Future<bool> _handleBathe(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(petProvider.notifier).bathe();
    if (!context.mounted) return result.success;

    _showFeedback(context, result.message, result.success);
    return result.success;
  }

  Future<bool> _handleLove(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(petProvider.notifier).giveLove();
    if (!context.mounted) return result.success;

    _showFeedback(context, result.message, result.success);
    return result.success;
  }

  void _showFeedback(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: success
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }
}
