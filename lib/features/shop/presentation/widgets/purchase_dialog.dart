import 'package:flutter/material.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/shop/domain/entities/purchase_result_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';

class PurchaseDialog extends StatelessWidget {
  final ShopItemEntity item;
  final BonusResult bonuses;
  final VoidCallback onPurchase;
  final bool isLoading;

  const PurchaseDialog({
    Key? key,
    required this.item,
    required this.bonuses,
    required this.onPurchase,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Header
              Row(
                children: [
                  Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Bonuses
              if (item.happinessMultiplier > 1.0 ||
                  item.coinMultiplier > 1.0 ||
                  item.decayReduction > 0.0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bônus do Item',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        if (item.happinessMultiplier > 1.0)
                          Chip(
                            label: Text(
                              '😊 Felicidade x${item.happinessMultiplier.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: Colors.pink.shade400,
                          ),
                        if (item.coinMultiplier > 1.0)
                          Chip(
                            label: Text(
                              '🍯 Moedas x${item.coinMultiplier.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: Colors.orange.shade400,
                          ),
                        if (item.decayReduction > 0.0)
                          Chip(
                            label: Text(
                              '🔄 Reduz fadiga ${(item.decayReduction * 100).toInt()}%',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: Colors.green.shade400,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),

              // Purchase button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onPurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Comprar por ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${item.price} 🍯',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
