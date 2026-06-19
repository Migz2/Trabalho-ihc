import 'package:hive/hive.dart';
import 'package:honey/features/shop/domain/entities/shop_item_enums.dart';

class ItemCategoryAdapter extends TypeAdapter<ItemCategory> {
  @override
  final int typeId = 6;

  @override
  ItemCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemCategory.accessory;
      case 1:
        return ItemCategory.background;
      case 2:
        return ItemCategory.toy;
      case 3:
        return ItemCategory.decoration;
      default:
        return ItemCategory.accessory;
    }
  }

  @override
  void write(BinaryWriter writer, ItemCategory obj) {
    writer.writeByte(obj.index);
  }
}

class ItemRarityAdapter extends TypeAdapter<ItemRarity> {
  @override
  final int typeId = 7;

  @override
  ItemRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemRarity.common;
      case 1:
        return ItemRarity.rare;
      case 2:
        return ItemRarity.epic;
      default:
        return ItemRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, ItemRarity obj) {
    writer.writeByte(obj.index);
  }
}
