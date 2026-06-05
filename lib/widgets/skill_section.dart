// shows the skills section on the character screen

import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/character.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/widgets/skill_bar.dart';

class SkillSection extends StatelessWidget {
  final Character character;
  
  const SkillSection({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppStyles.panelDecoration(),
      child: Column(
        children: [
          for (Skill skill in Skill.values)
            SkillBar(
              skill: skill,
              level: character.getSkillLevel(skill),
              currentXp: character.getSkillXp(skill),
              xpThreshold: character.skillXpThreshold(character.getSkillLevel(skill)),
            ),
        ],
      ),
    );
  }
}