import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

class HpBar extends StatelessWidget {
  final double value;
  final int current;
  final int max;

  const HpBar({
    super.key,
    required this.value,
    required this.current,
    required this.max,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite, color: AppColors.red, size: 16),
            const SizedBox(width: 4),
            Text(
              '$current/$max',
              style: AppStyles.hpLabel,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppStyles.smallRadius),
            border: Border.all(
              color: AppColors.mainBrown, width: 1
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.smallRadius),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.red.withValues(alpha: 0.35),
              valueColor: const AlwaysStoppedAnimation(AppColors.red),
            ),
          ),
        ),
      ],
    );
  }

  
}