import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';

class PetEntity {
  final String id;
  final String name;
  final double hunger;
  final double hygiene;
  final double happiness;
  final double energy;
  final int level;
  final int experience;
  final DateTime lastInteraction;
  final DateTime lastDecayCheck;
  final List<String> equippedItems;

  PetEntity({
    required this.id,
    required this.name,
    required this.hunger,
    required this.hygiene,
    required this.happiness,
    required this.energy,
    required this.level,
    required this.experience,
    required this.lastInteraction,
    required this.lastDecayCheck,
    required this.equippedItems,
  });

  /// Computed properties
  bool get isNeglected => happiness < 15;
  bool get isHungry => hunger < 30;
  bool get needsBath => hygiene < 30;

  PetMood get computedMood {
    final avg = (hunger + hygiene + happiness) / 3;
    if (avg >= 90) return PetMood.ecstatic;
    if (avg >= 70) return PetMood.happy;
    if (avg >= 50) return PetMood.content;
    if (avg >= 30) return PetMood.neutral;
    if (avg >= 15) return PetMood.sad;
    return PetMood.neglected;
  }

  /// Get mood in portuguese for display
  String get moodPT {
    switch (computedMood) {
      case PetMood.ecstatic:
        return 'Eufórico';
      case PetMood.happy:
        return 'Feliz';
      case PetMood.content:
        return 'Contente';
      case PetMood.neutral:
        return 'Neutro';
      case PetMood.sad:
        return 'Triste';
      case PetMood.neglected:
        return 'Negligenciado';
    }
  }

  PetEntity copyWith({
    String? id,
    String? name,
    double? hunger,
    double? hygiene,
    double? happiness,
    double? energy,
    int? level,
    int? experience,
    DateTime? lastInteraction,
    DateTime? lastDecayCheck,
    List<String>? equippedItems,
  }) {
    return PetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      hygiene: hygiene ?? this.hygiene,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      lastDecayCheck: lastDecayCheck ?? this.lastDecayCheck,
      equippedItems: equippedItems ?? this.equippedItems,
    );
  }

  @override
  String toString() {
    return 'PetEntity(id: $id, name: $name, hunger: $hunger, hygiene: $hygiene, happiness: $happiness, energy: $energy, level: $level, experience: $experience, mood: ${computedMood.name})';
  }
}
