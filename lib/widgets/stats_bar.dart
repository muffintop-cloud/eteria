import 'package:eteria/services/character_service.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CharacterService.notifier,
      builder: (context, value, child) {
        var character = CharacterService.current;
        if (character == null) {
          return const SizedBox.shrink();
        }

        double xpProgress = 0.0;
        if (character.xpThreshold > 0) {
          xpProgress = character.xp / character.xpThreshold;
        } // calculates how full the xp bar should be

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: AppStyles.panelDecoration(),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo,
                ),
                alignment: Alignment.center,
                child: Text('${character.level}', style: AppStyles.statNumber),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${character.xp} / ${character.xpThreshold} XP',
                      style: AppStyles.xpLabel,
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: xpProgress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 1, height: 32, color: Colors.grey.shade300),
              const SizedBox(width: 12),
              Row(
                mainAxisSize:
                    MainAxisSize.min, // row shrinks to fit its content
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: AppStyles.coinColor,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${character.coins}',
                        style: AppStyles.statNumber,
                      ),
                      const Text(
                        'Coins',
                        style: AppStyles.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ],
          ),
        );
      },
    );
  }
}
