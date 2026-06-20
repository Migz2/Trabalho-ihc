import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:honey/core/theme/app_radius.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/shop/presentation/providers/shop_provider.dart';
import 'package:honey/features/shop/presentation/widgets/purchase_dialog.dart';
import 'package:honey/features/shop/presentation/widgets/shop_item_card.dart';
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
      body: shopState.when(
        data: (items) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coming-soon banner
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4A942).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: const Color(0xFFF4A942).withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.update_rounded,
                          color: Color(0xFFF4A942),
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loja em atualização',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Novos itens e funcionalidades chegam em breve. Os itens disponíveis já podem ser desbloqueados normalmente.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

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
                            if (shopNotifier.currentBonuses.totalHappinessMultiplier >
                                1.0)
                              Chip(
                                label: Text(
                                  '😊 x${shopNotifier.currentBonuses.totalHappinessMultiplier.toStringAsFixed(2)}',
                                ),
                              ),
                            if (shopNotifier.currentBonuses.totalCoinMultiplier >
                                1.0)
                              Chip(
                                label: Text(
                                  '🍯 x${shopNotifier.currentBonuses.totalCoinMultiplier.toStringAsFixed(2)}',
                                ),
                              ),
                            if (shopNotifier.currentBonuses.totalDecayReduction >
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
                                final result = await shopNotifier.purchase(item.id);
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
            itemBuilder: (context, index) =>
                const HoneyShimmer(width: double.infinity, height: double.infinity),
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
    );
  }
}
