import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';

class PetActionResultEntity {
  final bool success;
  final String message;
  final int coinsSpent;
  final double hungerDelta;
  final double hygieneDelta;
  final double happinessDelta;
  final PetMood newMood;
  final bool levelUpOccurred;

  PetActionResultEntity({
    required this.success,
    required this.message,
    required this.coinsSpent,
    required this.hungerDelta,
    required this.hygieneDelta,
    required this.happinessDelta,
    required this.newMood,
    this.levelUpOccurred = false,
  });

  @override
  String toString() =>
      'PetActionResultEntity(success: $success, message: $message, coinsSpent: $coinsSpent)';
}
