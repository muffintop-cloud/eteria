import 'package:flutter/material.dart';
import 'package:eteria/styles/app_styles.dart';

class XpRewardBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const XpRewardBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.smallPadding, vertical: 2),
      decoration: AppStyles.badgeDecoration(color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(label, style: AppStyles.badgeText),
        ],
      ),
    );
  }
}