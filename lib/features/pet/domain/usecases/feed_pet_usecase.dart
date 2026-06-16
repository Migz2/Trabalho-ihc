import 'package:honey/features/pet/domain/entities/pet_action_result_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';

class FeedPetUseCase {
  static const int _feedCost = 10;
  static const double _hungerIncrease = 35.0;
  static const double _happinessIncrease = 10.0;

  /// Feed the pet
  /// Costs 10 coins
  /// Increases hunger by 35 and happiness by 10
  PetActionResultEntity feed({
    required PetEntity pet,
    required int userCoins,
  }) {
    // Check if user has enough coins
    if (userCoins < _feedCost) {
      return PetActionResultEntity(
        success: false,
        message: 'Moedas insuficientes para alimentar Mel! (🍯 $_feedCost)',
        coinsSpent: 0,
        hungerDelta: 0,
        hygieneDelta: 0,
        happinessDelta: 0,
        newMood: pet.computedMood,
      );
    }

    // Check if pet is already full
    if (pet.hunger >= 95) {
      return PetActionResultEntity(
        success: false,
        message: 'Mel ainda está satisfeita! 😊',
        coinsSpent: 0,
        hungerDelta: 0,
        hygieneDelta: 0,
        happinessDelta: 0,
        newMood: pet.computedMood,
      );
    }

    // Calculate new values (capped at 100)
    final newHunger = (pet.hunger + _hungerIncrease).clamp(0.0, 100.0);
    final newHappiness = (pet.happiness + _happinessIncrease).clamp(0.0, 100.0);

    return PetActionResultEntity(
      success: true,
      message: 'Mel comeu com delícia! Hmm, que gostoso! 🍖',
      coinsSpent: _feedCost,
      hungerDelta: newHunger - pet.hunger,
      hygieneDelta: 0,
      happinessDelta: newHappiness - pet.happiness,
      newMood: pet.copyWith(
        hunger: newHunger,
        happiness: newHappiness,
      ).computedMood,
    );
  }
}
