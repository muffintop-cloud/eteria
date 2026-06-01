import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

class NeedMeter extends StatelessWidget {
  final double value;
  final Color color;
  final IconData icon;
  final String label;
  final double size;

  const NeedMeter({
    super.key,
    required this.value,
    required this.color,
    required this.icon,
    required this.label,
    this.size = 55,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  strokeWidth: 6,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                ),
              ),
              Icon(
                icon,
                color: color,
                size: size*0.36,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppStyles.needLabel.copyWith(color: color) // apply needLabel style but change the color to a need's color
        ),
      ],
    );
  } 
}