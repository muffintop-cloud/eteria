import 'package:eteria/models/character.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/services/needs_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:eteria/models/quest.dart';

class QuestService {
  static Box<Quest> get _box => Hive.box<Quest>('questBox');

  static final notifier = ValueNotifier<int>(0);
  static void _notify() => notifier.value++;
  // home and quest screens listen to this so they know when quests are added/completed/deleted --> know when to reload their lists

  static Future<void> addQuest({
    required String title,
    required Difficulty difficulty,
    required QuestCategory category,
    DateTime? deadline,
    List<String>? objectives,
    List<int>? skillIndices,
  }) async {
    
    List<bool> objectivesDone = [];
    if (objectives != null) {
      objectivesDone = List.filled(objectives.length, false);
    } // if objectives exist, create a matching checklist of false values, e.g. objective 1 not done, objective 2 not done, etc

    int? deadlineTimestamp;
    if (category == QuestCategory.daily) {
        deadlineTimestamp = null; // daily quests don't have a deadline, they automatically repeat every day
      } else {
        deadlineTimestamp = deadline?.millisecondsSinceEpoch;
      }

    final quest = Quest(
      title: title,
      difficultyIndex: difficulty.index,
      categoryIndex: category.index,
      deadlineTimestamp: deadlineTimestamp,
      objectives: objectives ?? [], // if no objectives are provided, use an empty list
      objectivesDone: objectivesDone,
      skillIndices: skillIndices ?? [], 
    );
    await _box.add(quest);
    _notify();
  }

  static List<MapEntry<int, Quest>> getAllQuests() {
    Map<dynamic, Quest> questMap = _box.toMap(); // can't do int here, _box.toMap() gives an error
    List<MapEntry<int, Quest>> questList = [];
    for(var entry in questMap.entries) {
      int key = entry.key as int; 
      Quest quest = entry.value;
      questList.add(
        MapEntry(key, quest),
      );
    }
    return questList;
  } // converts: hive quest box --> map --> list of map entries (because lists are easier to display in ui)

  static Future <({int xp, int coins})> toggleComplete(int key) async {
    final quest = _box.get(key);
    if (quest == null) return (xp: 0, coins: 0);

    quest.isCompleted = !quest.isCompleted; // toggle completion
    await quest.save();
    _notify();

    if(!quest.isCompleted) return (xp: 0, coins: 0); // uncompleting a quest gives no rewards

    Character? character = CharacterService.current;
    int xpEarned = quest.xpReward;
    int coinsEarned = quest.coinReward;

    if (character != null) {
      await NeedsService.applyQuestDrain(character, quest.skillIndices ?? []);
      // if skillIndices is null, pass an empty list instead
    }

    await CharacterService.addXp(xpEarned); // award xp
    await CharacterService.addCoins(coinsEarned); // award coins

    for (int skillIndex in quest.skillIndices ?? []) {
      if (skillIndex >= 0 && skillIndex < Skill.values.length) {
        Skill skill = Skill.values[skillIndex];
        int skillXp = xpEarned;
        if (character != null && skill == character.traitSkill){
          skillXp = (skillXp * 1.2).round();
        } // if this skill matches the character's class skill --> +20% skill xp --> e.g. scholar gets +20% wisdom xp
        await CharacterService.addSkillXp(skill, skillXp);
      }
    }
    return (xp: xpEarned, coins: coinsEarned);
  }

  static Future<void> toggleObjective(int questKey, int objectiveIndex) async {
    final Quest? quest = _box.get(questKey);
    if (quest == null) return;
    if (quest.objectivesDone == null) return;
    quest.objectivesDone![objectiveIndex] = !quest.objectivesDone![objectiveIndex];
    await quest.save();
    _notify();
  }

  static Future<void> deleteQuest(int key) async {
    await _box.delete(key);
    _notify();
  }
}