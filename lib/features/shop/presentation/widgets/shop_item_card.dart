import 'package:flutter/material.dart';
import 'package:honey/core/extensions/context_extensions.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/utils/animation_constants.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_enums.dart';

class ShopItemCard extends StatefulWidget {
  final ShopItemEntity item;
  final VoidCallback onTap;
  final Color? rarityBorderColor;

  const ShopItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.rarityBorderColor,
  }) : super(key: key);

  @override
  State<ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<ShopItemCard> {
  double _scale = 1.0;

  @override
  void didUpdateWidget(ShopItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.equipped != oldWidget.item.equipped) {
      _pulse();
    }
  }

  void _pulse() async {
    setState(() => _scale = 1.05);
    await Future.delayed(AnimationDurations.fast);
    if (mounted) setState(() => _scale = 1.0);
  }

  Color _getRarityColor() {
    switch (widget.item.rarity) {
      case ItemRarity.common:
        return Colors.grey.shade400;
      case ItemRarity.rare:
        return Colors.amber.shade600;
      case ItemRarity.epic:
        return Colors.amber.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: AnimationDurations.fast,
        curve: AnimationCurves.standard,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: AnimationDurations.fast,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _getRarityColor(),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: context.surface,
              ),
              child: Stack(
                children: [
                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emoji/Icon
                      Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      // Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Bonus indicator (if any)
                      if (item.happinessMultiplier > 1.0)
                        Text(
                          '😊x${item.happinessMultiplier.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 9, color: context.textSecondary),
                        ),
                      if (item.coinMultiplier > 1.0)
                        Text(
                          '🍯x${item.coinMultiplier.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 9, color: context.textSecondary),
                        ),
                      if (item.decayReduction > 0.0)
                        Text(
                          '🔄-${(item.decayReduction * 100).toInt()}%',
                          style: TextStyle(fontSize: 9, color: context.textSecondary),
                        ),
                    ],
                  ),
                  // Lock or Checkmark
                  Positioned(
                    top: 8,
                    right: 8,
                    child: item.equipped
                        ? Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          )
                        : item.owned
                            ? const SizedBox.shrink()
                            : Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                  ),
                  // Price (for unowned items)
                  if (!item.owned)
                    Positioned(
                      bottom: 4,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '${item.price}🍯',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Equipped highlight ring (fades in/out independently of rarity border)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: item.equipped ? 1.0 : 0.0,
                duration: AnimationDurations.fast,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
