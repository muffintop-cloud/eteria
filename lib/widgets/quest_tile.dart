// displays a quest as a card with a checkbox, title, category, difficulty, xp reward, deadline and objectives
// swipe to delete, tap checkbox to toggle complete

import 'package:flutter/material.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:eteria/widgets/xp_reward_badge.dart';

class QuestTile extends StatelessWidget {
  final Quest quest;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final void Function(int) onToggleObjective;

  const QuestTile({
    super.key,
    required this.quest,
    required this.onToggle,
    required this.onDelete,
    required this.onToggleObjective,
  });

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppStyles.difficultyColor(quest.difficulty);
    final categoryColor = AppStyles.categoryColor(quest.category);

    return Dismissible(
      // allows swipe-to-delete
      key: ValueKey(
        quest.key,
      ), // unique key for each quest so flutter knows which one to delete upon swipe
      direction: DismissDirection.endToStart,

      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ), // red background with delete icon when swiping

      onDismissed: (direction) {
        onDelete();
      }, // delete quest when swiped

      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppStyles.mediumPadding,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: AppStyles.smallPadding,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: quest.isCompleted,
                    onChanged: (_) =>
                        onToggle(), // toggle complete when checkbox is tapped
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: AppStyles.titleMedium.copyWith(
                            decoration: quest.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: quest.isCompleted
                                ? Colors.grey
                                : AppStyles.titleMedium.color,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Wrap(
                          spacing: AppStyles.smallPadding,
                          runSpacing: 4,
                          children: [
                            _Badge(
                              label: quest.category.label,
                              color: categoryColor,
                            ),
                            _Badge(
                              label: quest.difficulty.label,
                              color: difficultyColor,
                            ),
                            _Badge(
                              label:
                                  '${quest.xpReward} XP  '
                                  '+${quest.coinReward} coins',
                              color: difficultyColor,
                            ),
                            if (quest.deadline != null)
                              _Badge(
                                label: AppStyles.deadlineFormat(
                                  quest.deadline!,
                                ),
                                color: quest.isOverdue
                                    ? Colors.red
                                    : Colors.grey,
                                icon: Icons.calendar_today,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (quest.category == QuestCategory.main &&
                  quest.objectives!.isNotEmpty)
                _buildObjectives(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObjectives(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, right: 8, bottom: 4),
      child: Column(
        children: [
          for (int i = 0; i < quest.objectives!.length; i++)
            _buildObjectiveRow(context, i),
        ],
      ),
    );
  }

  Widget _buildObjectiveRow(BuildContext context, int index) {
    bool isDone = false;
    if (index < quest.objectivesDone!.length) {
      isDone = quest.objectivesDone![index];
    }

    return InkWell(
      // makes the whole row tappable
      onTap: () {
        onToggleObjective(index);
      },
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_box : Icons.check_box_outline_blank,
            size: 18,
            color: isDone ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              quest.objectives![index],
              style: AppStyles.bodyText.copyWith(
                fontSize: 13,
                color: isDone ? Colors.grey : AppStyles.bodyText.color,
                decoration: isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// badge widget

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _Badge({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.smallPadding,
        vertical: 2,
      ),
      decoration: AppStyles.badgeDecoration(color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppStyles.badgeText.copyWith(color: color)),
        ],
      ),
    );
  }
}
