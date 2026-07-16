import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/character.dart';

class NeedMeter extends StatelessWidget {
  final double value; // 0.0 - 1.0, used for the progress bar
  final int rawValue; // 0 - 100, used for display
  final Color color;
  final IconData icon;
  final String label;
  final double size;

  const NeedMeter({
    super.key,
    required this.value,
    required this.rawValue,
    required this.color,
    required this.icon,
    required this.label,
    this.size = 55,
  });

  NeedState _needState() {
    switch (rawValue) {
      case 0:
        return NeedState.depleted;
      case <= 19:
        return NeedState.critical;
      case <= 49:
        return NeedState.low;
      default:
        return NeedState.stable;
    }
  } // converts rawValue into NeedState enum

  int _hpPenalty() {
    switch (_needState()) {
      case NeedState.stable:
        return 0;
      case NeedState.low:
        return 5;
      case NeedState.critical:
        return 15;
      case NeedState.depleted:
        return 30;
    }
  } // returns hp penalty for a need's current state

  String _stateLabel() {
    switch (_needState()) {
      case NeedState.stable:
        return 'Stable';
      case NeedState.low:
        return 'Low';
      case NeedState.critical:
        return 'Critical';
      case NeedState.depleted:
        return 'Depleted';
    }
  } // human readable state names

  Color _stateColor() {
    switch (_needState()) {
      case NeedState.stable:
        return AppColors.green;
      case NeedState.low:
        return AppColors.gold;
      case NeedState.critical:
        return AppColors.orange;
      case NeedState.depleted:
        return AppColors.red;
    }
  } // state label colors

  void _showInfoDialog(BuildContext context) {
    int penalty = _hpPenalty();
    String stateText = _stateLabel();
    Color stateColor = _stateColor();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyles.mediumRadius)),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: AppStyles.panelDecoration(),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppStyles.titleSmall,
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppStyles.mediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                leadingLabel: 'Current value: ',
                valueText: '$rawValue / 100',
                valueColor: color,
              ),
              const SizedBox(height: 10),
              _InfoRow(
                leadingLabel: 'State: ',
                valueText: stateText,
                valueColor: stateColor,
              ),
              const SizedBox(height: 10),
              _InfoRow(
                leadingLabel: 'Daily HP penalty: ',
                valueText: penalty == 0 ? 'None' : '-$penalty HP',
                valueColor: penalty == 0 ? AppColors.green : AppColors.red,
              ),

              const SizedBox(height: 16),

              // state descriptions
              Container(
                padding: const EdgeInsets.all(AppStyles.smallPadding),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
                ),
                child: Text(_stateDescription(), style: AppStyles.description),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  String _stateDescription() {
    switch (_needState()) {
      case NeedState.stable:
        return 'This need is well-maintained.';
      case NeedState.low:
        return 'This need is getting low. If it stays here until the daily reset, you\'ll lose 5 HP.';
      case NeedState.critical:
        return 'This need is critically low. You\'ll lose 15 HP at the daily reset unless you restore it.';
      case NeedState.depleted:
        return 'This need is depleted. If it stays here, you\'ll lose 30 HP at the daily reset.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInfoDialog(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            width: size + 9,
            height: size + 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.mainBrown, width: 1), // outer border
            ),
            
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // inner border
                    Container(
                      width: size - 7,
                      height: size - 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.mainBrown, width: 1),
                      ),
                    ),
                    
                    // progress bar
                    SizedBox(
                      width: size,
                      height: size,
                      child: CircularProgressIndicator(
                        value: value.clamp(0.0, 1.0),
                        strokeWidth: 7,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                    ),

                    Icon(icon, color: color, size: size * 0.36),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppStyles.label), // apply needLabel style but change the color to a need's color
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String leadingLabel;
  final String valueText;
  final Color valueColor;

  const _InfoRow({
    required this.leadingLabel,
    required this.valueText,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(leadingLabel, style: AppStyles.bodyText),
        Text(valueText, style: AppStyles.label.copyWith(color: valueColor)),
      ],
    );
  }
}
