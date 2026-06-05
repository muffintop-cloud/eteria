import 'package:flutter/material.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/styles/app_styles.dart';

class SkillBar extends StatelessWidget {
  final Skill skill;
  final int level; 
  final int currentXp;
  final int xpThreshold;

  const SkillBar({
    super.key,
    required this.skill,
    required this.level,
    required this.currentXp,
    required this.xpThreshold,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppStyles.skillColor(skill);

    final double progress;
    if(xpThreshold == 0) { progress = 0.0; }
    else { progress = currentXp / xpThreshold; }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(AppStyles.smallRadius),
            ),
            child: 
              Icon(AppStyles.skillIcon(skill), color: color, size: 18),
          ),
          const SizedBox(width: 10),

          // bar and label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(skill.label,
                      style: AppStyles.skillName),
                    Text('Lv $level', style: AppStyles.skillLevel.copyWith(color: color)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppStyles.smallRadius),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 2),
                Text('$currentXp / $xpThreshold XP', style: AppStyles.labelSmall)
              ],
            ),
          ),
        ],
      ),
    );
  }
}