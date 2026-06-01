import 'package:eteria/models/character_class.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/quest.dart';
import 'package:eteria/models/skill.dart';

class AppStyles {
  AppStyles._();

  // padding
  static const double smallPadding = 6;
  static const double mediumPadding = 12;
  static const double largePadding = 20;

  // radius
  static const double smallRadius = 4;
  static const double mediumRadius = 8;
  static const double largeRadius = 16;

  // text styles 
  static const TextStyle titleLarge = TextStyle( 
    fontSize: 20, 
    fontWeight: FontWeight.bold, 
    color: Color.fromARGB(255, 30, 30, 30)
  ); // character name, screen headings

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.bold, 
    letterSpacing: 0.5,
    color: Color.fromARGB(255, 30, 30, 30)
  ); // section titles
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 12, 
    fontWeight: FontWeight.bold, 
    color: Color.fromARGB(255, 30, 30, 30)
  ); // panel headers

  static const TextStyle bodyText = TextStyle(
    fontSize: 13,
    color: Color.fromARGB(255, 30, 30, 30)
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    color: Color.fromARGB(255, 30, 30, 30)
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle needLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600
  );

  static const TextStyle skillName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600
  );

  static const TextStyle skillLevel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold
  );

  static const TextStyle statNumber = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold
  );

  static const TextStyle hpLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 35, 72)
  );

  static const TextStyle xpLabel = TextStyle(
    fontSize: 10,
    color: Colors.grey
  );

  static const TextStyle classLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold
  );

  static const TextStyle description = TextStyle(
    fontSize: 11,
    color: Color.fromARGB(255, 100, 100, 100)
  );

  // difficulty
  static Color difficultyColor(Difficulty d) {
    switch(d) {
      case Difficulty.low: return const Color.fromARGB(255, 100, 181, 102);
      case Difficulty.medium: return const Color.fromARGB(255, 255, 159, 14);
      case Difficulty.high: return const Color.fromARGB(255, 213, 7, 55);
    }
  }

  // category
  static Color categoryColor(QuestCategory c) {
    switch(c) {
      case QuestCategory.daily: return const Color.fromARGB(255, 34, 69, 208);
      case QuestCategory.side: return const Color.fromARGB(255, 160, 95, 172);
      case QuestCategory.main: return const Color.fromARGB(255, 255, 164, 7);
    }
  }

  // skills
  static Color skillColor(Skill s) {
    switch(s) {
      case Skill.wisdom: return const Color.fromARGB(255, 124, 77, 255);
      case Skill.vitality: return const Color.fromARGB(255, 229, 68, 73);
      case Skill.artistry: return const Color.fromARGB(255, 16, 184, 190);
      case Skill.charisma: return const Color.fromARGB(255, 236, 189, 20);
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
      case CharacterClass.scholar: return const Color.fromARGB(255, 117, 50, 242);
      case CharacterClass.warrior: return const Color.fromARGB(255, 209, 24, 49);
      case CharacterClass.artisan: return const Color.fromARGB(255, 51, 165, 207);
      case CharacterClass.bard: return const Color.fromARGB(255, 255, 175, 37);
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

  // needs
  static const Color hungerColor = Color.fromARGB(255, 255, 100, 100);
  static const Color thirstColor = Color.fromARGB(255, 171, 209, 255);
  static const Color traitColor = Color.fromARGB(255, 176, 255, 111);
  static const Color hpColor = Color.fromARGB(255, 255, 35, 72);

  // coins
  static const Color coinColor = Color.fromARGB(255, 255, 196, 0);

  // deadline format
  static String deadlineFormat(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff == 0) { return 'Due today'; }
    else if (diff == 1) { return 'Due tomorrow'; }
    else if (diff < 0) { return 'Overdue by ${-diff} day(s)'; }
    else { return 'Due in $diff day(s)'; }
  }

  // container decorations
  static BoxDecoration panelDecoration() {
    return BoxDecoration(
      color: const Color.fromARGB(255, 245, 245, 245),
      borderRadius: BorderRadius.circular(largeRadius)
    );
  } // skills/class info/daily quests

  static BoxDecoration characterPanelDecoration(){
    return BoxDecoration(
      color: const Color.fromARGB(255, 230, 230, 230),
      borderRadius: BorderRadius.circular(largeRadius)
    );
  }

  static BoxDecoration badgeDecoration(Color color) {
    return BoxDecoration(
      border: Border.all(color: color, width: 0.8),
      borderRadius: BorderRadius.circular(smallRadius),
    ); // xp reward badge in a quest tile
  }
}