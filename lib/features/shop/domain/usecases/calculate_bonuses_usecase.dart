import 'package:honey/features/shop/domain/entities/purchase_result_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';

class CalculateBonusesUseCase {
  /// Calculate total bonuses from equipped items
  /// Returns BonusResult with multipliers and reductions
  BonusResult calculateBonuses(List<ShopItemEntity> equippedItems) {
    double totalHappinessMultiplier = 1.0;
    double totalCoinMultiplier = 1.0;
    double totalDecayReduction = 0.0;

    for (final item in equippedItems) {
      // Multiply happiness multipliers together
      totalHappinessMultiplier *= item.happinessMultiplier;

      // Multiply coin multipliers together (capped at 3.0)
      totalCoinMultiplier *= item.coinMultiplier;

      // Sum decay reductions (capped at 0.50)
      totalDecayReduction += item.decayReduction;
    }

    // Cap multipliers and reductions
    totalCoinMultiplier = totalCoinMultiplier > 3.0 ? 3.0 : totalCoinMultiplier;
    totalDecayReduction =
        totalDecayReduction > 0.50 ? 0.50 : totalDecayReduction;

    return BonusResult(
      totalHappinessMultiplier: totalHappinessMultiplier,
      totalCoinMultiplier: totalCoinMultiplier,
      totalDecayReduction: totalDecayReduction,
    );
  }
}
