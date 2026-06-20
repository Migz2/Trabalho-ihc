import 'package:honey/features/pet/domain/entities/pet_action_result_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';

class PetPetUseCase {
  static const int _petCost = 5;
  static const double _happinessIncrease = 20.0;
  static const int _cooldownSeconds = 30;

  /// Give love/pet to the pet
  /// Costs 5 coins
  /// Increases happiness by 20
  /// Has a 30-second cooldown between pets
  PetActionResultEntity giveLove({
    required PetEntity pet,
    required int userCoins,
  }) {
    // Check if user has enough coins
    if (userCoins < _petCost) {
      return PetActionResultEntity(
        success: false,
        message: 'Moedas insuficientes para dar carinho em Mel! (🍯 $_petCost)',
        coinsSpent: 0,
        hungerDelta: 0,
        hygieneDelta: 0,
        happinessDelta: 0,
        newMood: pet.computedMood,
      );
    }

    // Check cooldown
    final timeSinceLastPet = DateTime.now().difference(pet.lastInteraction);
    if (timeSinceLastPet.inSeconds < _cooldownSeconds) {
      final remainingSeconds = _cooldownSeconds - timeSinceLastPet.inSeconds;
      return PetActionResultEntity(
        success: false,
        message: 'Mel precisa de um tempinho... Espera $remainingSeconds segundos! ⏳',
        coinsSpent: 0,
        hungerDelta: 0,
        hygieneDelta: 0,
        happinessDelta: 0,
        newMood: pet.computedMood,
      );
    }

    // Calculate new values (capped at 100)
    final newHappiness = (pet.happiness + _happinessIncrease).clamp(0.0, 100.0);

    return PetActionResultEntity(
      success: true,
      message: 'Mel amou o carinho! Que delícia! 💕',
      coinsSpent: _petCost,
      hungerDelta: 0,
      hygieneDelta: 0,
      happinessDelta: newHappiness - pet.happiness,
      newMood: pet.copyWith(
        happiness: newHappiness,
      ).computedMood,
    );
  }
}
