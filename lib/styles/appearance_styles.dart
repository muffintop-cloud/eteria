import 'package:flutter/material.dart';

class AppearanceStyles {
  // asset path
  static String assetPath(String category, String option) {
    return 'assets/$category/$option.png';
  }

  // layout constants
  static const double panelHeight = 230.0;
  static const double panelRadius = 20.0;
  static const double tabHeight = 36.0;
  static const double tabRadius = 10.0;
  static const double tileSize = 68.0;
  static const double tileSpacing = 8.0;
  static const double tileRadius = 10.0;

  // tabs
  static const List<AppearanceTab> tabs = [
    AppearanceTab(id: 'body', label: 'Body', icon: Icons.accessibility_new),
    AppearanceTab(id: 'hair', label: 'Hair', icon: Icons.face_retouching_natural),
    AppearanceTab(id: 'eyes', label: 'Eyes', icon: Icons.remove_red_eye_outlined),
    AppearanceTab(id: 'outfits', label: 'Outfits', icon: Icons.checkroom),
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
        color: accent.withValues(alpha: 0.12),
        border: Border.all(color: accent, width: 2.5),
        borderRadius: BorderRadius.circular(tileRadius),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.25),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      );
    } else {
      return BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey, width: 1),
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
    Color borderColor = active ? accent : Colors.transparent;
    Color backgroundColor = active ? Colors.grey.shade200 : Colors.grey.shade400;

    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: borderColor, width: 1.5),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tabRadius),
        topRight: Radius.circular(tabRadius),
      ),
    );
  }

  // panel decoration
  static BoxDecoration panelDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(panelRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  // tab label text style
  static TextStyle tabLabelStyle({
    required bool active,
    required Color accent,
    required BuildContext context,
  }) {
    Color textColor = active ? accent : Colors.grey;
    FontWeight weight = active ? FontWeight.bold : FontWeight.normal;

    return TextStyle(fontSize: 10, fontWeight: weight, color: textColor);
  }

  // tile label text style
  static const TextStyle tileLabelStyle = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500);
}

// tab data
class AppearanceTab {
  final String id;
  final String label;
  final IconData icon;

  const AppearanceTab({
    required this.id,
    required this.label,
    required this.icon,
  });
}
