import 'package:eteria/models/character_class.dart';
import 'package:eteria/models/skill.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:eteria/models/character.dart';

class CharacterService {
  static Box<Character> get _box {
    return Hive.box<Character>('characterBox');
  } // _box: underscore makes it private to this file

  static final ValueNotifier<int> notifier = ValueNotifier<int>(0); // update signal for character changes

  static void notify() {
    notifier.value++; // every time data changes, increment the notifier to trigger UI updates
  }

  static bool get exists {
    return _box.isNotEmpty;
  }

  static Character? get current {
    return _box.get(0); // user only has one character, stored at key 0 || returns character or null
  }

  static Future<void> create(Character character) async {
    await _box.put(0, character); // save character at key 0
    notify(); // notify listeners of change
  }

  static Future<void> deleteCharacter() async {
    await _box.clear(); // remove all data from the box
    notify();
  }

  static Future<void> updateAppearance({
    required String body,
    required String hair,
    required String eyes,
    required String outfit,
  }) async {
    Character? c = current;
    if (c == null) return;
    c.body = body;
    c.hair = hair;
    c.eyes = eyes;
    c.outfit = outfit;
    await c.save(); // save changes to Hive
    notify();
  } // update existing character's appearance

  static Future<void> updateClass(CharacterClass newClass) async {
    Character? c = current;
    if (c == null) return;
    c.classIndex = newClass.index; // store class as index for easier Hive storage
    await c.save();
    notify();
  }

  static Future<void> addXp(int amount) async {
    Character? c = current;
    if (c == null) return;
    c.addXp(amount);
    await c.save();
    notify();
  } // add xp to character and level up if threshold is reached

  static Future<void> addSkillXp(Skill skill, int amount) async {
    Character? c = current;
    if (c == null) return;
    c.addSkillXp(skill, amount);
    await c.save();
    notify();
  } // add xp to a skill and level up if threshold is reached

  static Future<void> addCoins(int amount) async {
    Character? c = current;
    if (c == null) return;
    c.coins += amount;
    await c.save();
    notify();
  } // add coins to character
  
  static Future<void> updateNeeds({
    int? hunger,
    int? thirst,
    int? traitNeed,
  }) async {
    Character? c = current; 
    if (c == null) return;
    if (hunger != null) c.hunger = hunger.clamp(0, 100);
    if (thirst != null) c.thirst = thirst.clamp(0, 100);
    if (traitNeed != null) c.traitNeed = traitNeed.clamp(0, 100);
    await c.save();
    notify();
  } // update character's needs, clamp ensures values are between 0 and 100

  static Future<void> restoreHp(int amount) async {
    Character? c = current;
    if (c == null) return;
    c.hp = (c.hp + amount).clamp(0, c.maxHp);
    await c.save();
    notify();
  }

  static Future<void> applyDailyReset() async {
    Character? c = current;
    if (c == null) return;
    c.applyDailyReset(); // apply hp penalty based on needs' states at daily reset
    await c.save();
    notify();
  }
}