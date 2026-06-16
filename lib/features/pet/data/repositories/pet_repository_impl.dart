import 'package:uuid/uuid.dart';
import 'package:honey/core/constants/hive_keys.dart';
import 'package:honey/core/errors/app_exceptions.dart';
import 'package:honey/core/services/hive_service.dart';
import 'package:honey/features/pet/data/models/pet_model.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';
import 'package:honey/features/pet/domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  static const String _tag = 'PetRepositoryImpl';

  @override
  Future<PetEntity?> getPet() async {
    try {
      final box = HiveService.getBox(HiveKeys.petBox);
      final petModel = box.get(HiveKeys.petKey) as PetModel?;
      return petModel?.toEntity();
    } catch (e) {
      throw HiveException('Failed to get pet: $e');
    }
  }

  @override
  Future<void> savePet(PetEntity pet) async {
    try {
      final box = HiveService.getBox(HiveKeys.petBox);
      final petModel = PetModel.fromEntity(pet);
      await box.put(HiveKeys.petKey, petModel);
    } catch (e) {
      throw HiveException('Failed to save pet: $e');
    }
  }

  @override
  Future<PetEntity> getOrCreatePet() async {
    try {
      final existingPet = await getPet();
      if (existingPet != null) {
        return existingPet;
      }

      // Create default pet
      final now = DateTime.now();
      final newPet = PetEntity(
        id: const Uuid().v4(),
        name: 'Mel',
        hunger: 80.0,
        hygiene: 75.0,
        happiness: 70.0,
        energy: 90.0,
        level: 1,
        experience: 0,
        lastInteraction: now,
        lastDecayCheck: now,
        equippedItems: [],
      );

      await savePet(newPet);
      return newPet;
    } catch (e) {
      throw HiveException('Failed to get or create pet: $e');
    }
  }
}
