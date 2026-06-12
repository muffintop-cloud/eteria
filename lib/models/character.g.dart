// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      name: fields[0] as String,
      classIndex: fields[1] as int,
      hp: fields[2] as int,
      maxHp: fields[3] as int,
      hunger: fields[4] as int,
      thirst: fields[5] as int,
      classNeed: fields[6] as int,
      xp: fields[7] as int,
      level: fields[8] as int,
      coins: fields[9] as int,
      wisdomXp: fields[11] as int,
      vitalityXp: fields[12] as int,
      artistryXp: fields[13] as int,
      charismaXp: fields[14] as int,
      wisdomLevel: fields[15] as int,
      vitalityLevel: fields[16] as int,
      artistryLevel: fields[17] as int,
      charismaLevel: fields[18] as int,
      body: fields[19] as String,
      hair: fields[20] as String,
      eyes: fields[21] as String,
      outfit: fields[22] as String,
      unlockedItems: (fields[23] as List?)?.cast<String>(),
      inventoryItems: (fields[24] as List?)?.cast<InventoryItem>(),
      lastResetDate: fields[25] as String?,
    )..unusedSpirit = fields[10] as int;
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.classIndex)
      ..writeByte(2)
      ..write(obj.hp)
      ..writeByte(3)
      ..write(obj.maxHp)
      ..writeByte(4)
      ..write(obj.hunger)
      ..writeByte(5)
      ..write(obj.thirst)
      ..writeByte(6)
      ..write(obj.classNeed)
      ..writeByte(7)
      ..write(obj.xp)
      ..writeByte(8)
      ..write(obj.level)
      ..writeByte(9)
      ..write(obj.coins)
      ..writeByte(10)
      ..write(obj.unusedSpirit)
      ..writeByte(11)
      ..write(obj.wisdomXp)
      ..writeByte(12)
      ..write(obj.vitalityXp)
      ..writeByte(13)
      ..write(obj.artistryXp)
      ..writeByte(14)
      ..write(obj.charismaXp)
      ..writeByte(15)
      ..write(obj.wisdomLevel)
      ..writeByte(16)
      ..write(obj.vitalityLevel)
      ..writeByte(17)
      ..write(obj.artistryLevel)
      ..writeByte(18)
      ..write(obj.charismaLevel)
      ..writeByte(19)
      ..write(obj.body)
      ..writeByte(20)
      ..write(obj.hair)
      ..writeByte(21)
      ..write(obj.eyes)
      ..writeByte(22)
      ..write(obj.outfit)
      ..writeByte(23)
      ..write(obj.unlockedItems)
      ..writeByte(24)
      ..write(obj.inventoryItems)
      ..writeByte(25)
      ..write(obj.lastResetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
