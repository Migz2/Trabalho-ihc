import 'package:honey/features/pet/domain/entities/pet_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';

/// Service for calculating pet attribute decay over time
class PetDecayService {
  // Decay rates per hour
  static const double _hungerDecayPerHour = -8.0;
  static const double _hygieneDecayPerHour = -2.0;
  static const double _happinessDecayPerHour = -3.0;
  static const double _energyDecayPerHour = -1.5;

  // Multipliers for special conditions
  static const double _hungryHappinessMultiplier = 2.0; // 2x faster decay if hungry
  static const double _neglectedHygieneMultiplier = 1.5; // 1.5x faster decay if neglected

  /// Check if pet needs decay calculation
  /// Returns true if more than 1 minute has passed since last check
  bool needsDecayCheck(PetEntity pet) {
    final now = DateTime.now();
    final timeSinceLastCheck = now.difference(pet.lastDecayCheck);
    return timeSinceLastCheck.inMinutes >= 1;
  }

  /// Apply decay to a pet based on time elapsed
  /// Returns new PetEntity with updated attributes
  PetEntity applyDecay(PetEntity pet) {
    final now = DateTime.now();
    final timeSinceLastCheck = now.difference(pet.lastDecayCheck);
    final hoursElapsed = timeSinceLastCheck.inMinutes / 60.0;

    // Calculate decay amounts
    double newHunger = pet.hunger + (_hungerDecayPerHour * hoursElapsed);
    double newHygiene = pet.hygiene + (_hygieneDecayPerHour * hoursElapsed);
    double newHappiness = pet.happiness + (_happinessDecayPerHour * hoursElapsed);
    double newEnergy = pet.energy + (_energyDecayPerHour * hoursElapsed);

    // Apply multipliers for special conditions
    if (newHunger < 30) {
      newHappiness += (_happinessDecayPerHour * _hungryHappinessMultiplier * hoursElapsed);
    }

    if (pet.computedMood == PetMood.neglected) {
      newHygiene += (_hygieneDecayPerHour * _neglectedHygieneMultiplier * hoursElapsed);
    }

    // Clamp all attributes between 0 and 100
    newHunger = _clamp(newHunger, 0, 100);
    newHygiene = _clamp(newHygiene, 0, 100);
    newHappiness = _clamp(newHappiness, 0, 100);
    newEnergy = _clamp(newEnergy, 0, 100);

    return pet.copyWith(
      hunger: newHunger,
      hygiene: newHygiene,
      happiness: newHappiness,
      energy: newEnergy,
      lastDecayCheck: now,
    );
  }

  /// Clamp a value between min and max
  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
