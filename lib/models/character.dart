import 'package:eteria/models/character_class.dart';
import 'package:eteria/models/inventory_item.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/models/skill.dart';
import 'package:hive/hive.dart';

part 'character.g.dart';

enum NeedState { stable, low, critical, depleted }
enum HpState { healthy, tired, fatigued, exhausted }

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
  @Deprecated('spirit removed')
  int unusedSpirit = 0;

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
    List<String>? unlockedItems, // optional constructor parameters, can be null
    List<InventoryItem>? inventoryItems,
  }) {
    this.unlockedItems = unlockedItems ?? []; // if null, initialize as empty list
    this.inventoryItems = inventoryItems ?? [];
  }

  // asset paths for appearance
  String get bodyAssetPath { return 'assets/body/$body.png'; }
  String get hairAssetPath { return 'assets/hair/$hair.png'; }
  String get eyesAssetPath { return 'assets/eyes/$eyes.png'; }
  String get outfitAssetPath { return 'assets/outfits/$outfit.png'; }

  CharacterClass get characterClass {
    return CharacterClass.values[classIndex];
  } // get the character's class based on the stored index

  int get xpThreshold { return level * 100; } // xp needed to level up

  int skillXpThreshold(int skillLevel) { return skillLevel * 100; } // xp needed to level up a skill

  int getSkillXp(Skill s) {
    switch(s) {
      case Skill.wisdom: return wisdomXp;
      case Skill.vitality: return vitalityXp;
      case Skill.artistry: return artistryXp;
      case Skill.charisma: return charismaXp;
    }
  } // get current xp for a skill

  int getSkillLevel(Skill s) {
    switch(s) {
      case Skill.wisdom: return wisdomLevel;
      case Skill.vitality: return vitalityLevel;
      case Skill.artistry: return artistryLevel;
      case Skill.charisma: return charismaLevel;
    }
  } // get current level for a skill

  void addXp(int amount) {
    xp += amount;
    while (xp >= xpThreshold) {
      xp -= xpThreshold;
      level++;
    } 
  } // method to gain xp and handle leveling up

  Skill get traitSkill {
    switch (characterClass) {
      case CharacterClass.scholar: return Skill.wisdom;
      case CharacterClass.warrior: return Skill.vitality;
      case CharacterClass.artisan: return Skill.artistry;
      case CharacterClass.bard: return Skill.charisma;
    }
  } // get the skill associated with the character's class (trait need)

  void addSkillXp(Skill s, int amount) {
    switch(s) {
      case Skill.wisdom:
        wisdomXp += amount;
        while (wisdomXp >= skillXpThreshold(wisdomLevel)) {
          wisdomXp -= skillXpThreshold(wisdomLevel);
          wisdomLevel++;
        }
        break;
      case Skill.vitality:
        vitalityXp += amount;
        while (vitalityXp >= skillXpThreshold(vitalityLevel)) {
          vitalityXp -= skillXpThreshold(vitalityLevel);
          vitalityLevel++;
        }
        break;
      case Skill.artistry:
        artistryXp += amount;
        while (artistryXp >= skillXpThreshold(artistryLevel)) {
          artistryXp -= skillXpThreshold(artistryLevel);
          artistryLevel++;
        }
        break;
      case Skill.charisma:
        charismaXp += amount;
        while (charismaXp >= skillXpThreshold(charismaLevel)) {
          charismaXp -= skillXpThreshold(charismaLevel);
          charismaLevel++;
        }
        break;
    }
  } // method to add xp to a skill and handle leveling up

  // Needs
  NeedState needState(int needValue) {
    switch(needValue) {
      case 0: return NeedState.depleted;
      case <= 19: return NeedState.critical;
      case <= 49: return NeedState.low;
      default: return NeedState.stable;
    }
  } // needs' states based on their values

  int hpPenalty(int needValue) {
    switch(needState(needValue)) {
      case NeedState.stable: return 0;
      case NeedState.low: return 5;
      case NeedState.critical: return 15;
      case NeedState.depleted: return 30;
    }
  } // hp penalty based on need state (calculated at daily reset)

  HpState get hpState {
    switch (hp) {
      case <= 0: return HpState.exhausted;
      case <= 39: return HpState.fatigued;
      case <= 69: return HpState.tired;
      default: return HpState.healthy;
    }
  } // character's hp state is used to determine what the character can and cannot do

  bool canDoDifficultQuest(Difficulty difficulty, QuestCategory category) {
    switch(hpState) {
      case HpState.exhausted: // exhausted character can only do low-diff. daily quests
        return category == QuestCategory.daily && difficulty == Difficulty.low;
      case HpState.fatigued: // fatigued character cannot do high-diff. quests
        return difficulty != Difficulty.high;
      case HpState.tired: // tired/healthy character has no restrictions
      case HpState.healthy: 
        return true;
    }
  }

  void applyDailyReset() {
    int penalty = hpPenalty(hunger) + hpPenalty(thirst) + hpPenalty(traitNeed);
    hp = (hp - penalty).clamp(0, maxHp);
  } // apply hp penalty based on needs' states at daily reset
}

