import 'package:eteria/models/character.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/services/character_service.dart';

class NeedsService {
  // passive drain constants (once per daily reset)
  static const int passiveHungerDrain = 30;
  static const int passiveThirstDrain = 40;
  static const int passiveTraitDrain = 20;

  // activity drain constants (per completed quest)
  static const int questHungerDrain = 10;
  static const int questThirstDrain = 15;
  static const int questTraitDrain = 10;

  // trait need gain constant (quest matches trait need)
  static const int traitNeedGain = 20;

  // restoration constants
  static const int hungerRestoreAmount = 30;
  static const int thirstRestoreAmount = 35;

  // passive drain logic
  static Future<void> applyPassiveDrain() async {
    final c = CharacterService.current;
    if (c == null) return;

    c.hunger = (c.hunger - passiveHungerDrain).clamp(0, 100);
    c.thirst = (c.thirst - passiveThirstDrain).clamp(0, 100);
    c.traitNeed = (c.traitNeed - passiveTraitDrain).clamp(0, 100);

    await CharacterService.applyDailyReset(); // apply hp penalty based on needs' states at daily reset
  }

  static Future<void> applyQuestDrain(Character c, List<int> skillIndices) async {
    final traitSkill = c.traitSkill; // gets the skill associated with the character's class
    final questFeedsTraitNeed = skillIndices.any((i) // .any goes through all skill indices one by one and checks if any of them match the trait skill
    {
      if (i < 0 || i >= Skill.values.length) return false; // invalid index, ignore
      return Skill.values[i] == traitSkill; // check if the skill matches the character's trait skill (e.g. skill.values[0] == skill.artistry --> skill.wisdom == skill.artistry --> FALSE)
    });

    c.hunger = (c.hunger - questHungerDrain).clamp(0, 100);
    c.thirst = (c.thirst - questThirstDrain).clamp(0, 100);
    
    if(questFeedsTraitNeed) {
      c.traitNeed = (c.traitNeed + traitNeedGain).clamp(0, 100); // if the quest's skill matches the character's trait need, gain trait need
    } else {
      c.traitNeed = (c.traitNeed - questTraitDrain).clamp(0, 100); // if not, drain trait need
    }

    await c.save();
    CharacterService.notify();
  }

  static Future<void> logFood() async {
    final c = CharacterService.current; // get current character
    if (c == null) return;
    c.hunger = (c.hunger + hungerRestoreAmount).clamp(0, 100);
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
}