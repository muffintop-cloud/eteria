import 'package:eteria/styles/app_colors.dart';
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
    if (xpThreshold == 0) { progress = 0.0; } 
    else { progress = currentXp / xpThreshold; }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // skill icon box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppStyles.smallRadius),
              border: Border.all(color: AppColors.mainBrown, width: 1),
            ),
            child: Icon(AppStyles.skillIcon(skill), color: color, size: 20),
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
                    Text(skill.label, style: AppStyles.label),
                    Text(
                      'Lv $level',
                      style: AppStyles.label,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppStyles.smallRadius),
                    border: Border.all(color: AppColors.mainBrown, width: 1),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppStyles.smallRadius),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 9,
                      backgroundColor: color.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}