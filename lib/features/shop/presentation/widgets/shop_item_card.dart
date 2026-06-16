import 'package:flutter/material.dart';
import 'package:honey/core/theme/app_colors.dart';
import 'package:honey/core/theme/app_spacing.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_enums.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItemEntity item;
  final VoidCallback onTap;
  final Color? rarityBorderColor;

  const ShopItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.rarityBorderColor,
  }) : super(key: key);

  Color _getRarityColor() {
    switch (item.rarity) {
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: _getRarityColor(),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
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
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
                    style: const TextStyle(fontSize: 9),
                  ),
                if (item.coinMultiplier > 1.0)
                  Text(
                    '🍯x${item.coinMultiplier.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 9),
                  ),
                if (item.decayReduction > 0.0)
                  Text(
                    '🔄-${(item.decayReduction * 100).toInt()}%',
                    style: const TextStyle(fontSize: 9),
                  ),
              ],
            ),
            // Lock or Checkmark
            Positioned(
              top: 4,
              right: 4,
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
    );
  }
}
