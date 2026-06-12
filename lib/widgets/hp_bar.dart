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
            const Icon(Icons.favorite, color: AppStyles.hpColor, size: 13),
            const SizedBox(width: 4),
            Text(
              '$current/$max',
              style: AppStyles.hpLabel,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: const Color.fromARGB(255, 255, 136, 156),
            valueColor: const AlwaysStoppedAnimation(AppStyles.hpColor),
          ),
        ),
      ],
    );
  }

  
}