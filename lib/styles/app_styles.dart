import 'package:eteria/models/character_class.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/models/skill.dart';
import 'package:eteria/styles/app_colors.dart';

class AppStyles {
  AppStyles._();
  static const String fontFamily = 'Afacad';

  // padding
  static const double smallPadding = 8;
  static const double mediumPadding = 16;
  static const double largePadding = 20;

  // radius
  static const double smallRadius = 4;
  static const double mediumRadius = 8;
  static const double largeRadius = 16;

  // text styles 
  static const TextStyle titleLarge = TextStyle( 
    fontFamily: 'Afacad',
    fontSize: 32, 
    fontWeight: FontWeight.bold, 
    color: AppColors.mainBrown,
  ); // character name, screen headings

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 24, 
    fontWeight: FontWeight.bold, 
    letterSpacing: 0.5,
    color: AppColors.mainBrown
  ); // section titles
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 18, 
    fontWeight: FontWeight.bold, 
    color: AppColors.mainBrown
  ); // panel headers

  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 16,
    color: AppColors.mainBrown
  );

  static const TextStyle badgeText = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.mainBrown,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.mainBrown,
  );

  static const TextStyle statNumber = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.panel
  );

  static const TextStyle hpLabel = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.red,
  );

  static const TextStyle xpLabel = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 16,
    color: AppColors.panel,
  );

  static const TextStyle classLabel = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.panel,
  );

  static const TextStyle description = TextStyle(
    fontFamily: 'Afacad',
    fontSize: 16,
    color: AppColors.lightBrown,
  );

  // difficulty
  static Color difficultyColor(Difficulty d) {
    switch(d) {
      case Difficulty.low: return AppColors.green;
      case Difficulty.medium: return AppColors.gold;
      case Difficulty.high: return AppColors.red;
    }
  }

  // category
  static Color categoryColor(QuestCategory c) {
    switch(c) {
      case QuestCategory.daily: return AppColors.blue;
      case QuestCategory.side: return AppColors.red;
      case QuestCategory.main: return AppColors.gold;
    }
  }

  // skills
  static Color skillColor(Skill s) {
    switch(s) {
      case Skill.wisdom: return AppColors.blue;
      case Skill.vitality: return AppColors.red;
      case Skill.artistry: return AppColors.green;
      case Skill.charisma: return AppColors.gold;
    }
  }

  static IconData skillIcon(Skill s) {
    switch(s) {
      case Skill.wisdom: return Icons.menu_book;
      case Skill.vitality: return Icons.fitness_center;
      case Skill.artistry: return Icons.palette;
      case Skill.charisma: return Icons.auto_awesome;
    }
  }

  // classes
  static Color classColor(CharacterClass c) {
    switch(c) {
      case CharacterClass.scholar: return AppColors.blue;
      case CharacterClass.warrior: return AppColors.red;
      case CharacterClass.artisan: return AppColors.green;
      case CharacterClass.bard: return AppColors.gold;
    }
  }

  static IconData classIcon(CharacterClass c) {
    switch(c) {
      case CharacterClass.scholar: return Icons.menu_book;
      case CharacterClass.warrior: return Icons.fitness_center;
      case CharacterClass.artisan: return Icons.palette;
      case CharacterClass.bard: return Icons.auto_awesome;
    }
  }

  // deadline format
  static String deadlineFormat(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff == 0) { return 'Today'; }
    else if (diff == 1) { return 'Tomorrow'; }
    else if (diff < 0) { return 'Overdue by ${-diff} day(s)'; }
    else { return '$diff day(s)'; }
  }

  // panel dropdown shadow
  static const List<BoxShadow> panelShadow = [
    BoxShadow(
      color: AppColors.lightBrown,
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -1,
    ),
  ];

  // panels
  static BoxDecoration panelDecoration() {
    return BoxDecoration(
      color: AppColors.panel,
      borderRadius: BorderRadius.circular(mediumRadius),
      border: Border.all(color: AppColors.mainBrown, width: 1),
      boxShadow: panelShadow
    );
  } // skills/class info/daily quests

  static BoxDecoration statsBarDecoration() {
    return BoxDecoration(
      color: AppColors.mainBrown,
      border: Border.all(color: AppColors.darkBrown),
      boxShadow: panelShadow,
    );
  }

  static BoxDecoration characterPanelDecoration(){
    return BoxDecoration(
      color: AppColors.panel,
      borderRadius: BorderRadius.circular(mediumRadius),
      border: Border.all(color: AppColors.mainBrown, width: 1),
      boxShadow: panelShadow,
    );
  }

  static BoxDecoration badgeDecoration(Color color) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: AppColors.mainBrown, width: 0.8),
      borderRadius: BorderRadius.circular(smallRadius)
    ); // xp reward badge in a quest tile
  }
}