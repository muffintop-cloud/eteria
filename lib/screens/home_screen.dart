import 'package:eteria/models/character_class.dart';
import 'package:eteria/models/character.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/services/needs_service.dart';
import 'package:eteria/services/quest_service.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:eteria/widgets/character_display.dart';
import 'package:eteria/widgets/daily_quest_panel.dart';
import 'package:eteria/widgets/hp_bar.dart';
import 'package:eteria/widgets/need_meter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  List<MapEntry<int, Quest>> _dailyQuests = []; // list for showing daily quests --> starts empty, gets filled when _loadDailies() runs

  @override
  void initState() {
    super.initState();
    _loadDailies(); // load daily quests

  CharacterService.notifier.addListener(_loadDailies);
  QuestService.notifier.addListener(_loadDailies);
  }

  @override
  void dispose() {
    CharacterService.notifier.removeListener(_loadDailies);
    QuestService.notifier.removeListener(_loadDailies);
    super.dispose();
  }

  void _loadDailies() {
    if (!mounted) return; 

    setState(() {
      _dailyQuests = QuestService.getAllQuests().where((entry) {
        return entry.value.category == QuestCategory.daily;
      }) .toList();
    });
  }

  Future<void> _toggleDaily(int key) async {
    await QuestService.toggleComplete(key);
  } // called when the user ticks a daily quest checkbox

  Future<void> _logFood() async {
    await NeedsService.logFood(); // adds hunger pts and saves to hive
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hunger +${NeedsService.hungerRestoreAmount}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } // called when the user taps Log Food button

  Future<void> _logWater() async {
    await NeedsService.logWater(); // adds hunger pts and saves to hive
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thirst +${NeedsService.thirstRestoreAmount}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } // called when the user taps Log Food button

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CharacterService.notifier,
      builder: (context, value, child) {
        Character? character = CharacterService.current; // reads the character from hive every rebuild
        if (character == null) { return const SizedBox.shrink(); } // if there's no character, returns nothing

        double hpCurrent = character.hp / character.maxHp; // shows hp as a 0.0-1.0 value for the progress bar

        String traitLabel = character.characterClass.traitNeedLabel; // defined in CharacterClass

        return SingleChildScrollView( // makes the screen scrollable 
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight( // makes all row's children stretch to be the same hegiht as the taller child
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // makes all children fill the full height of IntrinsicHeight
                  children: [
                    Expanded(child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CharacterDisplay( 
                                character: character
                              )
                            ),
                          ),
                          const SizedBox(height: 10),
                          HpBar(
                            value: hpCurrent,
                            current: character.hp,
                            max: character.maxHp,
                          )
                        ],
                      ),
                    ),
                    ),
                    const SizedBox(width: 12),

                    // need meters: 
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeedMeter(
                            value: character.hunger / 100,
                            color: Colors.red,
                            icon: Icons.restaurant,
                            label: 'Hunger',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NeedMeter(
                                value: character.thirst / 100,
                                color: Colors.blue,
                                icon: Icons.water_drop,
                                label: 'Thirst',
                              ),
                              const SizedBox(width: 16),
                              NeedMeter(
                                value: character.traitNeed / 100,
                                color: Colors.green,
                                icon: Icons.self_improvement,
                                label: traitLabel,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LogButton(
                      icon: Icons.restaurant,
                      label: 'LogFood',
                      sublabel: '+${NeedsService.hungerRestoreAmount} Hunger',
                      color: Colors.red,
                      onTap: _logFood,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LogButton(
                      icon: Icons.water_drop,
                      label: 'Log Water',
                      sublabel: '+${NeedsService.thirstRestoreAmount} Water',
                      color: Colors.blue,
                      onTap: _logWater,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DailyQuestPanel(
                dailyQuests: _dailyQuests,
                onToggle: _toggleDaily,
              ),
            ],
          ),
        );
      }
    );
  }
}

class _LogButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap; // takes no arguments and returns nothing

  const _LogButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector( // makes a widget tappable
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6,),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: color)
                ),
                Text(
                  sublabel,
                  style: AppStyles.labelSmall.copyWith(color: color.withAlpha(1)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}