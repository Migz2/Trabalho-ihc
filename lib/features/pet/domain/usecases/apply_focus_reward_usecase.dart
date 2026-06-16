import 'package:honey/features/pet/domain/entities/pet_action_result_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';

class ApplyFocusRewardUseCase {
  static const double _happinessIncrease = 15.0;
  static const double _energyIncrease = 10.0;
  static const int _experienceIncrease = 20;

  /// Apply reward to pet for completing a focus session
  /// Increases happiness by 15, energy by 10, and experience by 20
  /// If experience reaches 100, level up the pet
  PetActionResultEntity applyFocusReward({
    required PetEntity pet,
  }) {
    // Calculate new values
    final newHappiness = (pet.happiness + _happinessIncrease).clamp(0.0, 100.0);
    final newEnergy = (pet.energy + _energyIncrease).clamp(0.0, 100.0);
    int newExperience = pet.experience + _experienceIncrease;
    int newLevel = pet.level;
    bool levelUpOccurred = false;

    // Check for level up
    if (newExperience >= 100) {
      newLevel += 1;
      newExperience -= 100;
      levelUpOccurred = true;
    }

    final updatedPet = pet.copyWith(
      happiness: newHappiness,
      energy: newEnergy,
      experience: newExperience,
      level: newLevel,
    );

    return PetActionResultEntity(
      success: true,
      message: levelUpOccurred
          ? 'Mel subiu de nível! 🎉 Agora é nível $newLevel!'
          : 'Que bom que você focou! Mel ficou feliz! 🎉',
      coinsSpent: 0,
      hungerDelta: 0,
      hygieneDelta: 0,
      happinessDelta: newHappiness - pet.happiness,
      newMood: updatedPet.computedMood,
      levelUpOccurred: levelUpOccurred,
    );
  }
}
