import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:honey/core/extensions/context_extensions.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/theme/app_radius.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/focus/presentation/providers/user_provider.dart';
import 'package:honey/features/pet/presentation/providers/pet_provider.dart';
import 'package:honey/features/pet/presentation/widgets/action_button.dart';
import 'package:honey/features/pet/presentation/widgets/attribute_bar.dart';
import 'package:honey/features/pet/presentation/widgets/pet_display_widget.dart';
import 'package:honey/features/shop/presentation/providers/shop_provider.dart';
import 'package:honey/features/shop/presentation/widgets/shop_item_card.dart';
import 'package:honey/shared/widgets/coin_display.dart';

class PetPage extends ConsumerWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);
    final userAsync = ref.watch(userProvider);
    final shopAsync = ref.watch(shopProvider);
    final isDark = context.isDark;

    return petAsync.when(
      loading: () => _buildScaffold(
        context: context,
        isDark: isDark,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildScaffold(
        context: context,
        isDark: isDark,
        child: Center(
          child: Text('Erro ao carregar Mel: $error'),
        ),
      ),
      data: (pet) {
        final userCoins = userAsync.value?.coins ?? 0;

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
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                        PetDisplayWidget(
                          pet: pet,
                          size: 180,
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
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                          barColor: const Color(0xFFE8736A),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AttributeBar(
                          label: 'Higiene',
                          value: pet.hygiene,
                          barColor: const Color(0xFF6AB4D4),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AttributeBar(
                          label: 'Felicidade',
                          value: pet.happiness,
                          barColor: const Color(0xFFF4A942),
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
                        iconBackgroundColor: const Color(0xFFFCE8E8),
                        onTap: () => _handleFeed(context, ref),
                      ),
                      ActionButton(
                        label: 'Dar banho',
                        icon: '💧',
                        costText: '🍯 15',
                        iconBackgroundColor: const Color(0xFFE3F3FB),
                        onTap: () => _handleBathe(context, ref),
                      ),
                      ActionButton(
                        label: 'Carinho',
                        icon: '❤️',
                        costText: '🍯 5',
                        iconBackgroundColor: const Color(0xFFFEF3E2),
                        onTap: () => _handleLove(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Shop section (preview with dynamic items)
                shopAsync.when(
                  data: (items) {
                    final ownedCount = items.where((item) => item.owned).length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lojinha',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Equipe para aumentar ganhos de felicidade',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                              Text(
                                '$ownedCount/${items.length}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Shop items grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ShopItemCard(
                                item: item,
                                onTap: () {
                                  context.go('/shop');
                                },
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // View full shop button
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/shop'),
                              child: Text(
                                'Ver loja completa →',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Back to focus button
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/focus'),
                              child: Text(
                                '← Voltar ao foco',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    );
                  },
                  loading: () => Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: Text('Erro ao carregar loja: $error')),
                  ),
                ),
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

  void _handleFeed(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(petProvider.notifier).feed();
    if (!context.mounted) return;

    _showFeedback(context, result.message, result.success);
  }

  void _handleBathe(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(petProvider.notifier).bathe();
    if (!context.mounted) return;

    _showFeedback(context, result.message, result.success);
  }

  void _handleLove(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(petProvider.notifier).giveLove();
    if (!context.mounted) return;

    _showFeedback(context, result.message, result.success);
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
