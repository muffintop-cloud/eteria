import 'package:eteria/models/character.dart';
import 'package:eteria/models/character_class.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:eteria/widgets/character_options_menu.dart';
import 'package:eteria/widgets/character_panel.dart';
import 'package:eteria/widgets/skill_section.dart';
import 'package:eteria/widgets/info_dialog.dart';
import 'package:flutter/material.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CharacterService.notifier,
      builder: (context, character, child) {
        Character? character = CharacterService.current;

        if (character == null) {
          return const Center(child: Text('No character found.'));
        }
        return _CharacterView(character: character);
      },
    );
  }
}

class _CharacterView extends StatelessWidget {
  final Character character;
  const _CharacterView({required this.character});

  @override
  Widget build(BuildContext context) {
    double hpCurrent = character.hp / character.maxHp;
    String classNeedLabel = character.characterClass.classNeedLabel;
    Color classColor = AppStyles.classColor(character.characterClass);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(context, classColor),
          const SizedBox(height: AppStyles.mediumPadding),

          CharacterPanel(
            context: context,
            character: character,
            hpCurrent: hpCurrent,
            classNeedLabel: classNeedLabel,
          ),
          const SizedBox(height: AppStyles.mediumPadding),

          buildSkillSectionTitle(context),
          const SizedBox(height: AppStyles.smallPadding),

          SkillSection(character: character),
          const SizedBox(height: AppStyles.mediumPadding),
        ],
      ),
    );
  }

  // name, class, options button
  Widget buildHeader(BuildContext context, Color classColor) {
    return Row(
      children: [
        Text(character.name, style: AppStyles.titleLarge),

        const SizedBox(width: 8),

        GestureDetector(
          onTap: () =>
              InfoDialog.classDescription(context, character.characterClass),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: classColor,
              borderRadius: BorderRadius.circular(AppStyles.smallRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  character.characterClass.name,
                  style: AppStyles.classLabel,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.info_outline,
                  size: 11,
                  color: AppColors.panel,
                ),
              ],
            ),
          ),
        ),

        const Spacer(), // pushes the options button to the right

        GestureDetector(
          onTap: () {
            showCharacterOptionsMenu(context, character);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
            ),
            child: const Icon(Icons.more_vert, size: 20),
          ),
        ),
      ],
    );
  }

  

  // skill section title
  Widget buildSkillSectionTitle(BuildContext context) {
    // skills
    return Row(
      children: [
        Text('Skills', style: AppStyles.titleSmall),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => InfoDialog.skillDescription(context),
          child: const Icon(
            Icons.info_outline,
            size: 14,
            color: AppColors.lightBrown,
          ),
        ),
      ],
    );
  }
}
