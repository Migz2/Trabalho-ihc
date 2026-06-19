import 'package:hive/hive.dart';
import 'package:honey/features/pet/domain/entities/pet_mood_enum.dart';

class PetMoodAdapter extends TypeAdapter<PetMood> {
  @override
  final int typeId = 5;

  @override
  PetMood read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PetMood.ecstatic;
      case 1:
        return PetMood.happy;
      case 2:
        return PetMood.content;
      case 3:
        return PetMood.neutral;
      case 4:
        return PetMood.sad;
      case 5:
        return PetMood.neglected;
      default:
        return PetMood.neutral;
    }
  }

  @override
  void write(BinaryWriter writer, PetMood obj) {
    writer.writeByte(obj.index);
  }
}
