// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 4;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
      difficultyIndex: fields[2] as int,
      deadlineTimestamp: fields[3] as int?,
      categoryIndex: fields[4] as int,
      objectives: (fields[5] as List?)?.cast<String>(),
      objectivesDone: (fields[6] as List?)?.cast<bool>(),
      skillIndices: (fields[7] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.difficultyIndex)
      ..writeByte(3)
      ..write(obj.deadlineTimestamp)
      ..writeByte(4)
      ..write(obj.categoryIndex)
      ..writeByte(5)
      ..write(obj.objectives)
      ..writeByte(6)
      ..write(obj.objectivesDone)
      ..writeByte(7)
      ..write(obj.skillIndices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
