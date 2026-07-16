// provides short explanation pop-up dialogs when the user taps
// the info icons next to needs, skills, class

import 'package:eteria/models/character_class.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

class InfoDialog {
  InfoDialog._(); // private constructor

  static void _show(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
    String? nextButtonText,
    VoidCallback? onNext,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.mediumRadius)),
        child: Container(
          decoration: AppStyles.panelDecoration(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppStyles.smallPadding),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppStyles.smallRadius),
                      border: Border.all(color: AppColors.mainBrown, width: 1),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title, style: AppStyles.titleMedium),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(body, style: AppStyles.bodyText),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Close', style: AppStyles.titleSmall),
                  ),
                  if(onNext != null)
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onNext();
                      },
                      child: Text(
                        nextButtonText ?? 'Next',
                        style: AppStyles.titleSmall,
                      ),
                    ),
                ],
              ),
            ],
          ), 
        ),
      ),
    );
  }

  // needs description
  static void needsDescription(BuildContext context) {
    Container(
      decoration: AppStyles.panelDecoration()
    );
    _show(
      context,
      icon: Icons.favorite_border,
      iconColor: AppColors.red,
      title: 'Needs',
      nextButtonText: 'Next',
      onNext: () => stateDescription(context),
      body: 
        'Each need is a meter ranging from 0 to 100. They drain passively upon daily reset, as well as each time you complete a quest.\n\n'
        'Hunger: daily reset -30, quest -10\n'
        'Thirst: daily reset -40, quest -15\n'
        'Class need: daily reset -20\n\n'
        'Log food and water when you satiate yourself in real life to restore your character\'s hunger and thirst.\n\n'
        'Your character\'s class need is restored by completing quests tagged with your class skill. Do at least one of these quests each day to keep your class need up.\n\n'
        'Tap a need meter to see its current value, state, and the HP penalty it will impose at the next daily reset.\n\n'
    );
  }

  // state description
  static void stateDescription(BuildContext context) {
    Container(
      decoration: AppStyles.panelDecoration()
    );
    _show(
      context, 
      icon: Icons.assessment_outlined, 
      iconColor: AppColors.red, 
      title: 'Hp and Need States', 
      body:
      'NEED STATES\n'
      'Each need has a state based on its current value:\n\n'
      'Stable (50-100): no HP penalty\n'
      'Low (20-49): -5 HP at daily reset\n'
      'Critical (1-19): -15 HP at daily reset\n'
      'Depleted (0): -30 HP at daily reset\n\n'
      'Penalties from all three needs stack, so if all three are '
      'depleted, you lose 90 HP at the next daily reset.\n\n'
      '* * *\n\n'
      'HP STATES\n'
      'Your character\'s HP state represents their wellbeing and may have some restrictions:\n\n'
      'Healthy (70-100): no restrictions\n'
      'Tired (40-69): no restrictions\n'
      'Fatigued (1-39): cannot do High difficulty quests\n'
      'Exhausted (0): can only do Low difficulty Daily quests\n\n'
      'Complete quests to restore HP and recover from bad states.',
    );
  }

  // skill description
  static void skillDescription(BuildContext context) {
    Container(
      decoration: AppStyles.panelDecoration()
    );
    _show(
      context,
      icon: Icons.auto_graph,
      iconColor: AppStyles.skillColor(Skill.wisdom),
      title: 'Skills',
      body: 
        'Skills represent your character\'s areas of growth.\n\n'
        'Wisdom: mental growth\n'
        'Vitality: physical strength\n'
        'Artistry: creative expression\n'
        'Charisma: social aptitude\n\n'
        'Level up your character\'s skills by completing quests with the matching tags.\n'
        'Your class gives a +20% XP bonus to its related skill.\n'
        'Higher skill levels reflect your real-life growth in that area.'
    );
  }

  // class description
  static void classDescription(BuildContext context, CharacterClass c) {
    Container(
      decoration: AppStyles.panelDecoration()
    );
    Color color = AppStyles.classColor(c);
    String classDesc;
    switch(c) {
      case CharacterClass.scholar:
        classDesc = 'Scholars are erudites dedicated to learning and improving their understanding of the world.';
        break;
      case CharacterClass.warrior:
        classDesc = 'Warriors are an archetype of courage and discipline dedicated to battling their limitations and overcoming challenges.';
        break;
      case CharacterClass.artisan:
        classDesc = 'Artisans are passionate creators on a ceaseless pursuit of developing their artistic skills.';
        break;
      case CharacterClass.bard:
        classDesc = 'Bards are storytellers and performers dedicated to highlighting the importance of human connection through tales of old.';
        break;
    }
    _show(
      context,
      icon: AppStyles.classIcon(c),
      iconColor: color,
      title: '${c.name} — ${c.theme}',
      body: 
        '$classDesc\n\n'
        'Daily requirement: ${c.dailyRequirement}\n'
        'Fulfilling this restores your ${c.classNeedLabel} need meter. '
        'Neglecting it drains it, and a depleted meter costs you 30 HP at daily reset.\n\n'
        'CLASS BONUS:\n'
        '${c.bonusDescription} on every quest tagged with your class skill. '
    );
  }
}