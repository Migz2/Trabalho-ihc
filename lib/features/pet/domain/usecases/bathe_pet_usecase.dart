import 'package:honey/features/pet/domain/entities/pet_action_result_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';

class BathePetUseCase {
  static const int _batheCost = 15;
  static const double _hygieneIncrease = 50.0;
  static const double _happinessIncrease = 5.0;

  /// Bathe the pet
  /// Costs 15 coins
  /// Increases hygiene by 50 and happiness by 5
  PetActionResultEntity bathe({
    required PetEntity pet,
    required int userCoins,
  }) {
    // Check if user has enough coins
    if (userCoins < _batheCost) {
      return PetActionResultEntity(
        success: false,
        message: 'Moedas insuficientes para dar banho em Mel! (🍯 $_batheCost)',
        coinsSpent: 0,
        hungerDelta: 0,
        hygieneDelta: 0,
        happinessDelta: 0,
        newMood: pet.computedMood,
      );
    }

    // Check if pet is already clean
    if (pet.hygiene >= 95) {
      return PetActionResultEntity(
        success: false,
        message: 'Mel já está limpinha! ✨',
        coinsSpent: 0,
        hungerDelta: 0,
        hygieneDelta: 0,
        happinessDelta: 0,
        newMood: pet.computedMood,
      );
    }

    // Calculate new values (capped at 100)
    final newHygiene = (pet.hygiene + _hygieneIncrease).clamp(0.0, 100.0);
    final newHappiness = (pet.happiness + _happinessIncrease).clamp(0.0, 100.0);

    return PetActionResultEntity(
      success: true,
      message: 'Mel saiu do banho cheirosa! Que limpinha! 🛁',
      coinsSpent: _batheCost,
      hungerDelta: 0,
      hygieneDelta: newHygiene - pet.hygiene,
      happinessDelta: newHappiness - pet.happiness,
      newMood: pet.copyWith(
        hygiene: newHygiene,
        happiness: newHappiness,
      ).computedMood,
    );
  }
}
