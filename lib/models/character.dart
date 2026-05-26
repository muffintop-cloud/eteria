import 'package:eteria/models/inventory_item.dart';
import 'package:hive/hive.dart';

part 'character.g.dart';

enum NeedState { stable, low, critical, depleted }

@HiveType(typeId: 0)
class Character extends HiveObject {
  // Basic info
  @HiveField(0)
  String name;

  @HiveField(1)
  int classIndex;

  // Stats
  @HiveField(2)
  int hp;

  @HiveField(3)
  int maxHp;

  // Needs (0-100)
  @HiveField(4)
  int hunger;

  @HiveField(5)
  int thirst;

  @HiveField(6)
  int traitNeed; // class-based need

  // xp and level
  @HiveField(7)
  int xp;

  @HiveField(8)
  int level;

  // Currencies
  @HiveField(9)
  int coins;

  @HiveField(10)
  int spirit;

  // Skill xp
  @HiveField(11)
  int wisdomXp;

  @HiveField(12)
  int vitalityXp;

  @HiveField(13)
  int artistryXp;

  @HiveField(14)
  int charismaXp;

  // Skill levels
  @HiveField(15)
  int wisdomLevel;

  @HiveField(16)
  int vitalityLevel;

  @HiveField(17)
  int artistryLevel;

  @HiveField(18)
  int charismaLevel;

  // Appearance
  @HiveField(19)
  String body;

  @HiveField(20)
  String hair;

  @HiveField(21)
  String eyes;

  @HiveField(22)
  String outfit;

  @HiveField(23)
  List<String>? unlockedItems;

  @HiveField(24)
  List<InventoryItem>? inventoryItems;

  Character({
    required this.name,
    required this.classIndex,
    this.hp = 100,
    this.maxHp = 100,
    this.hunger = 100,
    this.thirst = 100,
    this.traitNeed = 100,
    this.xp = 0,
    this.level = 1,
    this.coins = 0,
    this.spirit = 0,
    this.wisdomXp = 0,
    this.vitalityXp = 0,
    this.artistryXp = 0,
    this.charismaXp = 0,
    this.wisdomLevel = 1,
    this.vitalityLevel = 1,
    this.artistryLevel = 1,
    this.charismaLevel = 1,
    this.body = 'body_1',
    this.hair = 'hair_1',
    this.eyes = 'eye_1',
    this.outfit = 'outfit_1',
    List<String>? unlockedItems, // Optional constructor parameters, can be null
    List<InventoryItem>? inventoryItems,
  }) {
    this.unlockedItems = unlockedItems ?? []; // If null, initialize as empty list
    this.inventoryItems = inventoryItems ?? [];
  }
}

