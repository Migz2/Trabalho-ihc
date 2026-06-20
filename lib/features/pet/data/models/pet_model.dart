import 'package:hive/hive.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';

part 'pet_model.g.dart';

@HiveType(typeId: 0)
class PetModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double hunger;

  @HiveField(3)
  final double hygiene;

  @HiveField(4)
  final double happiness;

  @HiveField(5)
  final double energy;

  @HiveField(6)
  final int level;

  @HiveField(7)
  final int experience;

  @HiveField(8)
  final int mood; // stored as index

  @HiveField(9)
  final DateTime lastInteraction;

  @HiveField(10)
  final DateTime lastDecayCheck;

  @HiveField(11)
  final List<String> equippedItems;

  @HiveField(12)
  final DateTime? lastPetTime;

  PetModel({
    required this.id,
    required this.name,
    required this.hunger,
    required this.hygiene,
    required this.happiness,
    required this.energy,
    required this.level,
    required this.experience,
    required this.mood,
    required this.lastInteraction,
    required this.lastDecayCheck,
    required this.equippedItems,
    this.lastPetTime,
  });

  /// Convert PetEntity to PetModel
  factory PetModel.fromEntity(PetEntity entity) {
    return PetModel(
      id: entity.id,
      name: entity.name,
      hunger: entity.hunger,
      hygiene: entity.hygiene,
      happiness: entity.happiness,
      energy: entity.energy,
      level: entity.level,
      experience: entity.experience,
      mood: entity.computedMood.index,
      lastInteraction: entity.lastInteraction,
      lastDecayCheck: entity.lastDecayCheck,
      equippedItems: entity.equippedItems,
    );
  }

  /// Convert PetModel to PetEntity
  PetEntity toEntity() {
    return PetEntity(
      id: id,
      name: name,
      hunger: hunger,
      hygiene: hygiene,
      happiness: happiness,
      energy: energy,
      level: level,
      experience: experience,
      lastInteraction: lastInteraction,
      lastDecayCheck: lastDecayCheck,
      equippedItems: equippedItems,
    );
  }

  PetModel copyWith({
    String? id,
    String? name,
    double? hunger,
    double? hygiene,
    double? happiness,
    double? energy,
    int? level,
    int? experience,
    int? mood,
    DateTime? lastInteraction,
    DateTime? lastDecayCheck,
    List<String>? equippedItems,
    DateTime? lastPetTime,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      hygiene: hygiene ?? this.hygiene,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      mood: mood ?? this.mood,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      lastDecayCheck: lastDecayCheck ?? this.lastDecayCheck,
      equippedItems: equippedItems ?? this.equippedItems,
      lastPetTime: lastPetTime ?? this.lastPetTime,
    );
  }

  @override
  String toString() => 'PetModel(name: $name, level: $level)';
}
