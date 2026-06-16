import 'package:honey/features/pet/domain/entities/pet_entity.dart';

abstract class PetRepository {
  Future<PetEntity?> getPet();
  Future<void> savePet(PetEntity pet);
  Future<PetEntity> getOrCreatePet();
}
