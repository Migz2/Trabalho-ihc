import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_enums.dart';

class EquipItemUseCase {
  /// Equip or unequip an item
  /// Returns updated list of all items
  List<ShopItemEntity> equip({
    required String itemId,
    required List<ShopItemEntity> allItems,
  }) {
    final itemToToggle = allItems.firstWhere((i) => i.id == itemId);

    // If item is not owned, return unchanged
    if (!itemToToggle.owned) {
      return allItems;
    }

    List<ShopItemEntity> updated = allItems.map((item) => item).toList();

    // If item is already equipped, unequip it
    if (itemToToggle.equipped) {
      updated = updated.map((item) =>
          item.id == itemId ? item.copyWith(equipped: false) : item).toList();
      return updated;
    }

    // Item is not equipped, so equip it
    // Apply category-specific rules

    if (itemToToggle.category == ItemCategory.accessory) {
      // Unequip any other accessory
      updated = updated.map((item) {
        if (item.category == ItemCategory.accessory && item.equipped) {
          return item.copyWith(equipped: false);
        }
        return item;
      }).toList();
    } else if (itemToToggle.category == ItemCategory.background) {
      // Unequip any other background
      updated = updated.map((item) {
        if (item.category == ItemCategory.background && item.equipped) {
          return item.copyWith(equipped: false);
        }
        return item;
      }).toList();
    } else if (itemToToggle.category == ItemCategory.toy) {
      // Max 2 toys equipped at once
      final equippedToys = updated.where((item) =>
          item.category == ItemCategory.toy && item.equipped);
      if (equippedToys.length >= 2) {
        // Unequip the first equipped toy
        final firstEquipped = equippedToys.first;
        updated = updated.map((item) =>
            item.id == firstEquipped.id ? item.copyWith(equipped: false) : item).toList();
      }
    } else if (itemToToggle.category == ItemCategory.decoration) {
      // Max 2 decorations equipped at once
      final equippedDecorations = updated.where((item) =>
          item.category == ItemCategory.decoration && item.equipped);
      if (equippedDecorations.length >= 2) {
        // Unequip the first equipped decoration
        final firstEquipped = equippedDecorations.first;
        updated = updated.map((item) =>
            item.id == firstEquipped.id ? item.copyWith(equipped: false) : item).toList();
      }
    }

    // Finally, equip the item
    updated = updated.map((item) =>
        item.id == itemId ? item.copyWith(equipped: true) : item).toList();

    return updated;
  }
}
