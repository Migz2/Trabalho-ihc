import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:honey/core/theme/app_radius.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/shop/presentation/providers/shop_provider.dart';
import 'package:honey/features/shop/presentation/widgets/purchase_dialog.dart';
import 'package:honey/features/shop/presentation/widgets/shop_item_card.dart';
import 'package:honey/shared/navigation/app_routes.dart';
import 'package:honey/shared/widgets/empty_state_widget.dart';
import 'package:honey/shared/widgets/honey_button.dart';
import 'package:honey/shared/widgets/honey_shimmer.dart';

class ShopPage extends ConsumerWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopProvider);
    final shopNotifier = ref.read(shopProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          shopState.when(
            data: (items) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bonuses section
                      if (shopNotifier.equippedItems.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bônus Equipados',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: [
                                if (shopNotifier.currentBonuses
                                        .totalHappinessMultiplier >
                                    1.0)
                                  Chip(
                                    label: Text(
                                      '😊 x${shopNotifier.currentBonuses.totalHappinessMultiplier.toStringAsFixed(2)}',
                                    ),
                                  ),
                                if (shopNotifier
                                        .currentBonuses.totalCoinMultiplier >
                                    1.0)
                                  Chip(
                                    label: Text(
                                      '🍯 x${shopNotifier.currentBonuses.totalCoinMultiplier.toStringAsFixed(2)}',
                                    ),
                                  ),
                                if (shopNotifier
                                        .currentBonuses.totalDecayReduction >
                                    0.0)
                                  Chip(
                                    label: Text(
                                      '🔄 -${(shopNotifier.currentBonuses.totalDecayReduction * 100).toInt()}%',
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                        ),

                      // Shop grid
                      Text(
                        'Catálogo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ShopItemCard(
                            item: item,
                            onTap: () async {
                              if (item.owned) {
                                // Owned items: tapping toggles equip/unequip.
                                HapticFeedback.lightImpact();
                                await shopNotifier.equip(item.id);
                                return;
                              }
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => PurchaseDialog(
                                  item: item,
                                  bonuses: shopNotifier.currentBonuses,
                                  onPurchase: () async {
                                    final result =
                                        await shopNotifier.purchase(item.id);
                                    if (result.success) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(result.message),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(result.message),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                                isScrollControlled: true,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.72,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => const HoneyShimmer(
                    width: double.infinity, height: double.infinity),
              ),
            ),
            error: (error, stackTrace) => EmptyStateWidget(
              emoji: '🛍️',
              title: 'Loja indisponível',
              subtitle: 'Tente novamente em instantes',
              action: HoneyButton(
                label: 'Tentar novamente',
                variant: ButtonVariant.outlined,
                onPressed: () => ref.invalidate(shopProvider),
              ),
            ),
          ),
          const _ComingSoonOverlay(),
        ],
      ),
    );
  }
}

/// Full-screen "coming soon" overlay that sits on top of the shop catalog,
/// blocking interaction with it while still letting users peek at the items
/// behind through the scrim.
class _ComingSoonOverlay extends StatelessWidget {
  const _ComingSoonOverlay();

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.tertiary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final dividerColor = Theme.of(context).colorScheme.outline;
    final textHint = Theme.of(context).textTheme.labelSmall?.color;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.65)),
        ),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_clock_outlined,
                    size: 40,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('🍯', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  'Loja em breve',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Novos itens, acessórios e\nfundos exclusivos chegam\nna próxima atualização!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 0.75),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOut,
                    builder: (_, value, __) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: dividerColor,
                      valueColor: AlwaysStoppedAnimation(accentColor),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '75% concluído',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textHint,
                      ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => GoRouter.of(context).go(AppRoutes.focus),
          ),
        ),
      ],
    );
  }
}
