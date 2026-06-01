// shows the list of daily quests on the home screen

import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/quest.dart';

class DailyQuestPanel extends StatelessWidget {
  final List<MapEntry<int, Quest>> dailyQuests; // shows a list of daily quests, each one with its own key and value (title)
  final void Function(int key) onToggle; // called when a checkbox is toggled, passes the quest's key so the parent knows which quest to mark complete
  const DailyQuestPanel({
    super.key,
    required this.dailyQuests,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: AppStyles.panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // header
          Row(
            children: [
              const Icon(
                Icons.wb_sunny_outlined,
                size: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 6),
              Text(
                'Daily Quests',
                style: AppStyles.titleSmall.copyWith(color: AppStyles.categoryColor(QuestCategory.daily)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // quest panel  
          if(dailyQuests.isEmpty)
            const Text(
              'No daily quests. Add some in the Quests tab.',
              style: AppStyles.description,
            )
          
          else
          Column( // column with a list of widgets built from dailyQuests with a for loop
            children: [
              for (MapEntry<int, Quest> entry in dailyQuests)
                _buildQuestRow(context, entry),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestRow(BuildContext context, MapEntry<int, Quest> entry) {
    int key = entry.key;
    Quest quest = entry.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              value: quest.isCompleted,
              visualDensity: VisualDensity.compact, // removes extra padding around the checkbox
              onChanged: (bool? newValue) {
                onToggle(key);
              }
            ),
          ),
          const SizedBox(width: 6),

          Expanded(
            child: Text(
              quest.title,
              style: AppStyles.bodyText.copyWith(
                decoration: quest.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
                color: quest.isCompleted
                  ? Colors.grey
                  : null,
              ),
            ),
          ),

          _XpLabel(
            xpAmount: quest.xpReward,
            questDifficulty: quest.difficulty,
          ),
        ],
      ),
    );
  }
}

class _XpLabel extends StatelessWidget {
  final int xpAmount;
  final Difficulty questDifficulty;

  const _XpLabel({
    required this.xpAmount,
    required this.questDifficulty,
  });

  Color getDifficultyColor() {
    switch(questDifficulty)
    {
      case(Difficulty.low):
        return AppStyles.difficultyColor(Difficulty.low);
      case(Difficulty.medium):
        return AppStyles.difficultyColor(Difficulty.medium);
      case(Difficulty.high):
        return AppStyles.difficultyColor(Difficulty.high);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color labelColor = getDifficultyColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border:Border.all(color: labelColor, width: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '+${xpAmount}XP',
        style: TextStyle(
          fontSize: 11, 
          fontWeight: FontWeight.bold,
        )
      ),
    );
  }
}

