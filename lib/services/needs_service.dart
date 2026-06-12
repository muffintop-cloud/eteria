// handles everything related to the character's needs (hunger, 
// thirst, class need) and the daily reset

import 'package:eteria/models/character.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/services/quest_service.dart';

class NeedsService {
  // passive drain constants (once per daily reset)
  static const int passiveHungerDrain = 30;
  static const int passiveThirstDrain = 40;
  static const int passiveClassNeedDrain = 20;

  // activity drain constants (per completed quest)
  static const int questHungerDrain = 10;
  static const int questThirstDrain = 15;
  static const int questClassNeedDrain = 10;

  // class need gain constant (quest matches class need)
  static const int classNeedGain = 20;

  // restoration constants
  static const int hungerRestoreAmount = 30;
  static const int thirstRestoreAmount = 35;
  static const int foodHpRestoreAmount = 5;

  // passive drain logic
  static Future<void> _applyPassiveDrain() async {
    final c = CharacterService.current;
    if (c == null) return;

    c.hunger = (c.hunger - passiveHungerDrain).clamp(0, 100);
    c.thirst = (c.thirst - passiveThirstDrain).clamp(0, 100);
    c.classNeed = (c.classNeed - passiveClassNeedDrain).clamp(0, 100);

    await CharacterService.applyDailyReset(); // apply hp penalty based on needs' states at daily reset
  }

  static Future<void> applyQuestDrain(Character c, List<int> skillIndices) async {
    final classSkill = c.classSkill; // gets the skill associated with the character's class
    final questFeedsClassNeed = skillIndices.any((i) // .any goes through all skill indices one by one and checks if any of them match the class skill
    {
      if (i < 0 || i >= Skill.values.length) return false; // invalid index, ignore
      return Skill.values[i] == classSkill; // check if the skill matches the character's class skill (e.g. skill.values[0] == skill.artistry --> skill.wisdom == skill.artistry --> FALSE)
    });

    c.hunger = (c.hunger - questHungerDrain).clamp(0, 100);
    c.thirst = (c.thirst - questThirstDrain).clamp(0, 100);
    
    if(questFeedsClassNeed) {
      c.classNeed = (c.classNeed + classNeedGain).clamp(0, 100); // if the quest's skill matches the character's class need, gain class need
    } else {
      c.classNeed = (c.classNeed - questClassNeedDrain).clamp(0, 100); // if not, drain class need
    }

    await c.save();
    CharacterService.notify();
  }

  static Future<void> logFood() async {
    final c = CharacterService.current; // get current character
    if (c == null) return;
    c.hunger = (c.hunger + hungerRestoreAmount).clamp(0, 100);
    c.hp = (c.hp + foodHpRestoreAmount).clamp(0, c.maxHp);
    await c.save();
    CharacterService.notify();
  } // log food activity, restore hunger

  static Future<void> logWater() async {
    final c = CharacterService.current;
    if (c == null) return;
    c.thirst = (c.thirst + thirstRestoreAmount).clamp(0, 100);
    await c.save();
    CharacterService.notify();
  } // log water activity, restore thirst

  static String _today() {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    return '$day-$month-$year';
  }

  // daily reset logic:

  static Future<void> checkForDailyReset() async { // called once in main.dart at startup
    final c = CharacterService.current;
    if (c == null) return;
    String today = _today(); // looks at today's date
    if (c.lastResetDate == null || c.lastResetDate != today) {
      await triggerDailyReset(); // if dates are different, it means a new day has begun --> runs triggerDailyReset()
    }
  } 

  static Future<void> triggerDailyReset() async { // does the actual reset work
    final c = CharacterService.current;
    if (c == null) return;
    await _applyPassiveDrain(); // passive need drain, applies hp penalty based on need state
    await QuestService.resetDailyQuests(); // resets all daily quests
    c.lastResetDate = _today(); // saves today's date so it doesn't reset again until tomorrow
    await c.save();
    CharacterService.notify();
  }
}