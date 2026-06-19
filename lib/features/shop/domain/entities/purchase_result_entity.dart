import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';

class PurchaseResultEntity {
  final bool success;
  final String message;
  final int coinsSpent;
  final ShopItemEntity? item;

  PurchaseResultEntity({
    required this.success,
    required this.message,
    required this.coinsSpent,
    this.item,
  });

  @override
  String toString() =>
      'PurchaseResultEntity(success: $success, coinsSpent: $coinsSpent)';
}

class BonusResult {
  final double totalHappinessMultiplier;
  final double totalCoinMultiplier;
  final double totalDecayReduction;

  BonusResult({
    required this.totalHappinessMultiplier,
    required this.totalCoinMultiplier,
    required this.totalDecayReduction,
  });

  @override
  String toString() =>
      'BonusResult(happiness: $totalHappinessMultiplier, coins: $totalCoinMultiplier, decay: $totalDecayReduction)';
}
