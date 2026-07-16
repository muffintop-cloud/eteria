import 'package:eteria/models/character_class.dart';
import 'package:eteria/models/character.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/services/needs_service.dart';
import 'package:eteria/services/quest_service.dart';
import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:eteria/widgets/character_panel.dart';
import 'package:eteria/widgets/daily_quest_panel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MapEntry<int, Quest>> _dailyQuests =
      []; // list for showing daily quests --> starts empty, gets filled when _loadDailies() runs

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
      }).toList();
    });
  }

  Future<void> _testDailyReset() async {
    await NeedsService.triggerDailyReset();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Daily reset executed')));
  }

  Future<void> _toggleDaily(int key) async {
    await QuestService.toggleComplete(key);
  } // called when the user ticks a daily quest checkbox

  Future<void> _logFood() async {
    await NeedsService.logFood(); // adds hunger pts and saves to hive
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '+${NeedsService.hungerRestoreAmount} Hunger\n+${NeedsService.foodHpRestoreAmount} HP',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } // called when the user taps Log Food button

  Future<void> _logWater() async {
    await NeedsService.logWater(); // adds hunger pts and saves to hive
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thirst +${NeedsService.thirstRestoreAmount}'),
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
        Character? character = CharacterService
            .current; // reads the character from hive every rebuild
        if (character == null) {
          return const SizedBox.shrink();
        } // if there's no character, returns nothing

        double hpCurrent =
            character.hp /
            character.maxHp; // shows hp as a 0.0-1.0 value for the progress bar

        String classNeedLabel = character
            .characterClass
            .classNeedLabel; // defined in CharacterClass

        return SingleChildScrollView(
          // makes the screen scrollable
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              CharacterPanel(
                context: context,
                character: character,
                hpCurrent: hpCurrent,
                classNeedLabel: classNeedLabel,
              ),
              const SizedBox(height: AppStyles.mediumPadding),
              
              buildLogButtons(),
              const SizedBox(height: AppStyles.mediumPadding),
              
              DailyQuestPanel(
                dailyQuests: _dailyQuests,
                onToggle: _toggleDaily,
              ),
              const SizedBox(height: AppStyles.mediumPadding),
              
              Row(
                children: [
                  const SizedBox(width: AppStyles.mediumPadding),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _testDailyReset,
                      child: const Text('Test Daily Reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // BUILD METHODS
  Widget buildLogButtons() {
    return Row(
      children: [
        Expanded(
          child: _LogButton(
            icon: Icons.restaurant,
            label: 'Log Food',
            color: AppColors.red,
            onTap: _logFood,
          ),
        ),
        const SizedBox(width: AppStyles.mediumPadding),
        Expanded(
          child: _LogButton(
            icon: Icons.water_drop,
            label: 'Log Water',
            color: AppColors.blue,
            onTap: _logWater,
          ),
        ),
      ],
    );
  }
}

  // WIDGETS
class _LogButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap; // takes no arguments and returns nothing

  const _LogButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // makes a widget tappable
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.extraLightBrown,
          border: Border.all(color: AppColors.mainBrown, width: 1.5),
          borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
          boxShadow: AppStyles.panelShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppStyles.titleSmall),
          ],
        ),
      ),
    );
  }
}
