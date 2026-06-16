import 'package:honey/features/shop/domain/entities/purchase_result_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';

class PurchaseItemUseCase {
  /// Purchase an item for the user
  /// Returns PurchaseResult with success status and message
  PurchaseResultEntity purchase({
    required String itemId,
    required ShopItemEntity item,
    required int userCoins,
  }) {
    // Check if already owned
    if (item.owned) {
      return PurchaseResultEntity(
        success: false,
        message: 'Você já tem este item!',
        coinsSpent: 0,
      );
    }

    // Check if user has enough coins
    if (userCoins < item.price) {
      final difference = item.price - userCoins;
      return PurchaseResultEntity(
        success: false,
        message:
            'Moedas insuficientes.\nVocê precisa de mais $difference moedas 🍯',
        coinsSpent: 0,
      );
    }

    // Purchase successful
    final purchasedItem = item.copyWith(owned: true);

    return PurchaseResultEntity(
      success: true,
      message: 'Você comprou ${item.name}! 🎉',
      coinsSpent: item.price,
      item: purchasedItem,
    );
  }
}
