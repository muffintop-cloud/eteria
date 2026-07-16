// displays a quest as a card with a checkbox, title, category, difficulty, xp reward, deadline and objectives
// swipe to delete, tap checkbox to toggle complete

import 'package:eteria/models/character.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/styles/app_styles.dart';

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

    Character? character = CharacterService.current;
    bool isBlocked = false;
    if (character != null && !quest.isCompleted) {
      isBlocked = !character.canCompleteQuest(
        // returns false when hp is too low for the quest's difficulty level
        quest.difficulty,
        quest.category,
      );
    } // check if quest is blocked because character's hp is too low

    return Opacity(
      opacity: isBlocked ? 0.45 : 1.0,
      child: Dismissible(
        // allows swipe-to-delete
        key: ValueKey(
          quest.key,
        ), // unique key for each quest so flutter knows which one to delete upon swipe
        direction: DismissDirection.endToStart,

        background: Container(
          color: AppColors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: AppColors.panel),
        ), // red background with delete icon when swiping

        onDismissed: (direction) {
          onDelete();
        }, // delete quest when swiped

        child: GestureDetector(
          onTap: () => _showDetails(context, isBlocked),
          
          // quest tile card
          child: Card(
            color: AppColors.panel,
            elevation: 2,
            shadowColor: AppColors.lightBrown,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
              side: BorderSide(color: AppColors.mainBrown, width: 1),
            ),
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
                      // checkbox
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (isBlocked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'You are too exhausted for this quest. '
                                  'Complete easier quests to restore HP.',
                                  style: AppStyles.label
                                ),
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          onToggle();
                        },
                        child: Checkbox(
                          value: quest.isCompleted,
                          onChanged: (_) => onToggle(),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quest.title,
                              style: AppStyles.bodyText.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: quest.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: quest.isCompleted
                                    ? AppColors.lightBrown
                                    : AppColors.mainBrown,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Wrap(
                              spacing: AppStyles.smallPadding,
                              runSpacing: 4,
                              children: [
                                _Badge(
                                  label: quest.difficulty.label,
                                  color: difficultyColor,
                                ),

                                if (quest.deadline != null)
                                  _Badge(
                                    label: AppStyles.deadlineFormat(
                                      quest.deadline!,
                                    ),
                                    color: quest.isOverdue
                                        ? AppColors.red
                                        : AppColors.inactive,
                                    icon: Icons.calendar_today,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.mainBrown,
                      ), // hint that it's tappable
                    ],
                  ),

                  if (quest.category == QuestCategory.main &&
                      quest.objectives !.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 44, top: 8),
                      child: Column(
                        children: quest.objectives!.asMap().entries.map((entry) {
                          final i = entry.key;
                          return _ObjectiveRow(
                            text: entry.value,
                            isDone: quest.objectivesDone![i],
                            onTap: () => onToggleObjective(i),
                          );
                        }).toList(),
                      ),
                    ), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // quest details
  void _showDetails(BuildContext context, bool isBlocked) {
    final difficultyColor = AppStyles.difficultyColor(quest.difficulty);
    final categoryColor = AppStyles.categoryColor(quest.category);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // lets the section size itself to its content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 24, 20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // decorative bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: AppColors.mainBrown),
                  ),
                ),
              ),

              // quest title
              Text(quest.title, style: AppStyles.titleLarge),
              const SizedBox(height: 16),

              // type/difficulty row
              _DetailSection(
                label: 'Quest details',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Badge(label: quest.category.label, color: categoryColor),
                    _Badge(
                      label: quest.difficulty.label,
                      color: difficultyColor,
                    ),
                  ],
                ),
              ),

              // rewards
              _DetailSection(
                label: 'Rewards',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Badge(
                      label: '+${quest.xpReward} XP',
                      color: AppColors.blue,
                      icon: Icons.star_outline,
                    ),
                    _Badge(
                      label: '+${quest.coinReward} coins',
                      color: AppColors.gold,
                      icon: Icons.monetization_on_outlined,
                    ),
                  ],
                ),
              ),

              // skills
              if ((quest.skillIndices ?? []).isNotEmpty)
                _DetailSection(
                  label: 'Skills rewarded',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      for (int skillIndex in quest.skillIndices!)
                        if (skillIndex >= 0 && skillIndex < Skill.values.length)
                          _Badge(
                            label: Skill.values[skillIndex].label,
                            color: AppStyles.skillColor(
                              Skill.values[skillIndex],
                            ),
                            icon: AppStyles.skillIcon(Skill.values[skillIndex]),
                          ),
                    ],
                  ),
                ),

              // deadline
              if (quest.deadline != null)
                _DetailSection(
                  label: 'Deadline',
                  child: _Badge(
                    label: AppStyles.deadlineFormat(quest.deadline!),
                    color: quest.isOverdue ? AppColors.red : AppColors.background,
                    icon: Icons.calendar_today,
                  ),
                ),

              // objectives
              if (quest.category == QuestCategory.main && (quest.objectives ?? []).isNotEmpty)
                _DetailSection(
                  label: 'Objectives', 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < quest.objectives!.length; i++)
                        _ObjectiveRow(
                          text: quest.objectives![i],
                          isDone: i < quest.objectivesDone!.length  
                              ? quest.objectivesDone![i]
                              : false,
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            onToggleObjective(i);
                          },
                        ),
                    ],
                  ),
                ),

                // blocked warning
                if (isBlocked) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(AppStyles.mediumPadding),
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
                      border: Border.all(color: AppColors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded, 
                          color: AppColors.red,
                          size: 20),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'You are too exhausted for this quest. '
                            'Complete easier quests to restore HP first.',
                            style: AppStyles.label.copyWith(color: AppColors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppStyles.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppStyles.label.copyWith(
              color: AppColors.mainBrown,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          child,
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
    final foregroundColor = color == AppColors.red ? AppColors.panel : AppColors.mainBrown;
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
            Icon(icon, size: 16, color: foregroundColor),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppStyles.badgeText.copyWith(color: foregroundColor)),
        ],
      ),
    );
  }
}

class _ObjectiveRow extends StatelessWidget {
  final String text;
  final bool isDone;
  final VoidCallback onTap;

  const _ObjectiveRow({
    required this.text,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: isDone ? AppColors.green : AppColors.lightBrown,
            ),
            const SizedBox(width: AppStyles.smallPadding),
            Expanded(
              child: Text(
                text,
                style: AppStyles.bodyText.copyWith(
                  color: isDone ? AppColors.lightBrown : AppColors.mainBrown,
                  decoration: isDone 
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
