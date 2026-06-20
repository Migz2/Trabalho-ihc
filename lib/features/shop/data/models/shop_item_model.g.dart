// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopItemModelAdapter extends TypeAdapter<ShopItemModel> {
  @override
  final int typeId = 9;

  @override
  ShopItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopItemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      emoji: fields[3] as String,
      category: fields[4] as int,
      rarity: fields[5] as int,
      price: fields[6] as int,
      happinessMultiplier: fields[7] as double,
      coinMultiplier: fields[8] as double,
      decayReduction: fields[9] as double,
      owned: fields[10] as bool,
      equipped: fields[11] as bool,
      backgroundColorHex: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopItemModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.rarity)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.happinessMultiplier)
      ..writeByte(8)
      ..write(obj.coinMultiplier)
      ..writeByte(9)
      ..write(obj.decayReduction)
      ..writeByte(10)
      ..write(obj.owned)
      ..writeByte(11)
      ..write(obj.equipped)
      ..writeByte(12)
      ..write(obj.backgroundColorHex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
