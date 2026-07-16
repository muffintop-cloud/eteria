// character display, need meters
import 'package:eteria/models/character.dart';
import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:eteria/widgets/character_display.dart';
import 'package:eteria/widgets/hp_bar.dart';
import 'package:eteria/widgets/info_dialog.dart';
import 'package:eteria/widgets/need_meter.dart';
import 'package:flutter/material.dart';

class CharacterPanel extends StatelessWidget {
  final BuildContext context;
  final Character character;
  final double hpCurrent;
  final String classNeedLabel;

  const CharacterPanel({super.key, 
    required this.context,
    required this.character,
    required this.hpCurrent,
    required this.classNeedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            
            // character display
            child: Container(
              decoration: AppStyles.characterPanelDecoration(),
              padding: const EdgeInsets.all(AppStyles.mediumPadding),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppStyles.mediumRadius,
                      ),
                      child: CharacterDisplay(character: character),
                    ),
                  ),

                  const SizedBox(height: 10),

                  HpBar(
                    value: hpCurrent,
                    current: character.hp,
                    max: character.maxHp,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppStyles.smallPadding),

          // need meters:
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => InfoDialog.needsDescription(context),
                    child: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.lightBrown,
                    ),
                  ),
                ),
                NeedMeter(
                  value: character.hunger / 100,
                  rawValue: character.hunger,
                  color: AppColors.red,
                  icon: Icons.restaurant,
                  label: 'Hunger',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeedMeter(
                      value: character.thirst / 100,
                      rawValue: character.thirst,
                      color: AppColors.blue,
                      icon: Icons.water_drop,
                      label: 'Thirst',
                    ),
                    const SizedBox(width: 16),
                    NeedMeter(
                      value: character.classNeed / 100,
                      rawValue: character.classNeed,
                      color: AppColors.green,
                      icon: Icons.self_improvement,
                      label: classNeedLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}