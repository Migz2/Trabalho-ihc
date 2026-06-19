// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetModelAdapter extends TypeAdapter<PetModel> {
  @override
  final int typeId = 4;

  @override
  PetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      hunger: fields[2] as double,
      hygiene: fields[3] as double,
      happiness: fields[4] as double,
      energy: fields[5] as double,
      level: fields[6] as int,
      experience: fields[7] as int,
      mood: fields[8] as int,
      lastInteraction: fields[9] as DateTime,
      lastDecayCheck: fields[10] as DateTime,
      equippedItems: (fields[11] as List).cast<String>(),
      lastPetTime: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PetModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hunger)
      ..writeByte(3)
      ..write(obj.hygiene)
      ..writeByte(4)
      ..write(obj.happiness)
      ..writeByte(5)
      ..write(obj.energy)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.experience)
      ..writeByte(8)
      ..write(obj.mood)
      ..writeByte(9)
      ..write(obj.lastInteraction)
      ..writeByte(10)
      ..write(obj.lastDecayCheck)
      ..writeByte(11)
      ..write(obj.equippedItems)
      ..writeByte(12)
      ..write(obj.lastPetTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
