import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

class AppearanceStyles {
  // asset path
  static String assetPath(String category, String option) {
    return 'assets/$category/$option.png';
  }

  // layout constants
  static const double panelHeight = 230.0;
  static const double panelRadius = 10.0;
  static const double tabHeight = 36.0;
  static const double tabRadius = 10.0;
  static const double tileSize = 68.0;
  static const double tileSpacing = 8.0;
  static const double tileRadius = 10.0;

  // tabs
  static const List<AppearanceTab> tabs = [
    AppearanceTab(id: 'body', icon: Icons.accessibility_new),
    AppearanceTab(id: 'hair', icon: Icons.face_retouching_natural),
    AppearanceTab(id: 'eyes', icon: Icons.remove_red_eye_outlined),
    AppearanceTab(id: 'outfits', icon: Icons.checkroom),
  ];

  // style options per category
  static const Map<String, List<String>> options = {
    'body': ['body_1', 'body_2', 'body_3', 'body_4', 'body_5'],
    'hair': ['hair_1', 'hair_2', 'hair_3', 'hair_4', 'hair_5'],
    'eyes': ['eye_1', 'eye_2', 'eye_3', 'eye_4', 'eye_5'],
    'outfits': ['outfit_1', 'outfit_2'],
  };

  // default selections
  static const Map<String, String> defaultSelections = {
    'body': 'body_1',
    'hair': 'hair_1',
    'eyes': 'eye_1',
    'outfits': 'outfit_1',
  };

  // placeholder icons if png fails to load
  static IconData placeholderIcon(String category) {
    switch (category) {
      case ('body'): return Icons.accessibility_new;
      case ('hair'): return Icons.face_retouching_natural;
      case ('eyes'): return Icons.remove_red_eye_outlined;
      case ('outfits'): return Icons.checkroom_outlined;
      default: return Icons.help_outline;
    }
  }

  // tile decoration
  static BoxDecoration tileDecoration({
    required bool selected,
    required Color accent,
    required BuildContext context,
  }) {
    if (selected) {
      return BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: accent, width: 2.5),
        borderRadius: BorderRadius.circular(tileRadius),
        boxShadow: AppStyles.panelShadow
      );
    } else {
      return BoxDecoration(
        color: AppColors.inactive,
        border: Border.all(color: AppColors.lightBrown, width: 1.5),
        borderRadius: BorderRadius.circular(tileRadius),
      );
    }
  }

  // tab decoration
  static BoxDecoration tabDecoration({
    required bool active,
    required Color accent,
    required BuildContext context,
  }) {
    Color borderColor = active ? AppColors.mainBrown : AppColors.mainBrown;
    Color backgroundColor = active ? AppColors.orange : AppColors.extraLightBrown;

    return BoxDecoration(
      color: backgroundColor,
      border: Border(
        top: BorderSide(color: borderColor, width: 1.5),
        left: BorderSide(color: borderColor, width: 1.5),
        right: BorderSide(color: borderColor, width: 1.5),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppStyles.mediumRadius),
        topRight: Radius.circular(AppStyles.mediumRadius)),
    );
  }

  // panel decoration
  static BoxDecoration panelDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.panel,
      borderRadius: BorderRadius.circular(panelRadius),
      border: Border.all(color: AppColors.mainBrown, width: 1.5),
      boxShadow: AppStyles.panelShadow,
    );
  }

  // options panel decoration
  static BoxDecoration optionsPanel(BuildContext context) {
    return BoxDecoration(
      color: AppColors.panel,
      borderRadius: BorderRadius.circular(panelRadius),
      border: Border.all(color: AppColors.darkBrown, width: 1.5),
      boxShadow: AppStyles.panelShadow,
    );
  }
}

// tab data
class AppearanceTab {
  final String id;
  final IconData icon;

  const AppearanceTab({
    required this.id,
    required this.icon,
  });
}
