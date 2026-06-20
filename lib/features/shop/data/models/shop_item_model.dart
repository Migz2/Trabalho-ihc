import 'package:hive/hive.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_enums.dart';

part 'shop_item_model.g.dart';

@HiveType(typeId: 9)
class ShopItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String emoji;

  @HiveField(4)
  final int category;

  @HiveField(5)
  final int rarity;

  @HiveField(6)
  final int price;

  @HiveField(7)
  final double happinessMultiplier;

  @HiveField(8)
  final double coinMultiplier;

  @HiveField(9)
  final double decayReduction;

  @HiveField(10)
  final bool owned;

  @HiveField(11)
  final bool equipped;

  @HiveField(12)
  final String? backgroundColorHex;

  ShopItemModel({
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

  factory ShopItemModel.fromEntity(ShopItemEntity entity) {
    return ShopItemModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      emoji: entity.emoji,
      category: entity.category.index,
      rarity: entity.rarity.index,
      price: entity.price,
      happinessMultiplier: entity.happinessMultiplier,
      coinMultiplier: entity.coinMultiplier,
      decayReduction: entity.decayReduction,
      owned: entity.owned,
      equipped: entity.equipped,
      backgroundColorHex: entity.backgroundColorHex,
    );
  }

  ShopItemEntity toEntity() {
    return ShopItemEntity(
      id: id,
      name: name,
      description: description,
      emoji: emoji,
      category: ItemCategory.values[category],
      rarity: ItemRarity.values[rarity],
      price: price,
      happinessMultiplier: happinessMultiplier,
      coinMultiplier: coinMultiplier,
      decayReduction: decayReduction,
      owned: owned,
      equipped: equipped,
      backgroundColorHex: backgroundColorHex,
    );
  }

  ShopItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    int? category,
    int? rarity,
    int? price,
    double? happinessMultiplier,
    double? coinMultiplier,
    double? decayReduction,
    bool? owned,
    bool? equipped,
    String? backgroundColorHex,
  }) {
    return ShopItemModel(
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
  String toString() => 'ShopItemModel(id: $id, name: $name)';
}
