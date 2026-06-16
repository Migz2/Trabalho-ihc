import 'package:honey/features/shop/domain/entities/shop_item_enums.dart';

class ShopItemEntity {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final ItemCategory category;
  final ItemRarity rarity;
  final int price;
  final double happinessMultiplier;
  final double coinMultiplier;
  final double decayReduction;
  final bool owned;
  final bool equipped;
  final String? backgroundColorHex;

  ShopItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.category,
    required this.rarity,
    required this.price,
    required this.happinessMultiplier,
    required this.coinMultiplier,
    required this.decayReduction,
    required this.owned,
    required this.equipped,
    this.backgroundColorHex,
  });

  ShopItemEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    ItemCategory? category,
    ItemRarity? rarity,
    int? price,
    double? happinessMultiplier,
    double? coinMultiplier,
    double? decayReduction,
    bool? owned,
    bool? equipped,
    String? backgroundColorHex,
  }) {
    return ShopItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      price: price ?? this.price,
      happinessMultiplier: happinessMultiplier ?? this.happinessMultiplier,
      coinMultiplier: coinMultiplier ?? this.coinMultiplier,
      decayReduction: decayReduction ?? this.decayReduction,
      owned: owned ?? this.owned,
      equipped: equipped ?? this.equipped,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
    );
  }

  @override
  String toString() =>
      'ShopItemEntity(id: $id, name: $name, owned: $owned, equipped: $equipped)';
}
