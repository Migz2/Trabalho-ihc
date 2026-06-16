// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerStateModelAdapter extends TypeAdapter<TimerStateModel> {
  @override
  final int typeId = 3;

  @override
  TimerStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerStateModel(
      phaseIndex: fields[0] as int,
      remainingSeconds: fields[1] as int,
      currentCycle: fields[2] as int,
      totalCycles: fields[3] as int,
      isRunning: fields[4] as bool,
      isPaused: fields[5] as bool,
      sessionStartedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TimerStateModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.phaseIndex)
      ..writeByte(1)
      ..write(obj.remainingSeconds)
      ..writeByte(2)
      ..write(obj.currentCycle)
      ..writeByte(3)
      ..write(obj.totalCycles)
      ..writeByte(4)
      ..write(obj.isRunning)
      ..writeByte(5)
      ..write(obj.isPaused)
      ..writeByte(6)
      ..write(obj.sessionStartedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
