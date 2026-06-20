import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';

class PetAssets {
  // Pet image assets
  static const String _petImagesPath = 'assets/images/pet';
  static const String melNormal = '$_petImagesPath/mel_normal.png';
  static const String melHappy = '$_petImagesPath/mel_happy.png';
  static const String melSleeping = '$_petImagesPath/mel_sleeping.png';

  /// Get asset path for pet based on mood
  static String getAssetForMood(PetMood mood) {
    switch (mood) {
      case PetMood.ecstatic:
      case PetMood.happy:
        return melHappy;
      case PetMood.content:
      case PetMood.neutral:
        return melNormal;
      case PetMood.sad:
      case PetMood.neglected:
        return melSleeping;
    }
  }
}
