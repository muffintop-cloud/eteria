enum CharacterClass {scholar, warrior, artisan, bard}

extension CharacterClassExtension on CharacterClass {
  String get name {
    switch(this) {
      case CharacterClass.scholar: return 'Scholar';
      case CharacterClass.warrior: return 'Warrior';
      case CharacterClass.artisan: return 'Artisan';
      case CharacterClass.bard: return 'Bard';
    }
  }

  String get theme {
    switch (this) {
      case CharacterClass.scholar: return 'Mage';
      case CharacterClass.warrior: return 'Knight';
      case CharacterClass.artisan: return 'Artist';
      case CharacterClass.bard: return 'Entertainer';
    }
  }

  String get dailyRequirement {
    switch (this) {
      case CharacterClass.scholar: return 'Learning or studying';
      case CharacterClass.warrior: return 'Physical activity or training';
      case CharacterClass.artisan: return 'Creative activity';
      case CharacterClass.bard: return 'Social interaction or performance';
    }
  }

  String get bonusDescription {
    switch (this) {
      case CharacterClass.scholar: return '+20% Wisdom XP';
      case CharacterClass.warrior: return '+20% Vitality XP';
      case CharacterClass.artisan: return '+20% Artistry XP';
      case CharacterClass.bard: return '+20% Charisma XP';
    }
  }

  String get traitNeedLabel {
    switch (this) {
      case CharacterClass.scholar: return 'Study';
      case CharacterClass.warrior: return 'Train';
      case CharacterClass.artisan: return 'Create';
      case CharacterClass.bard: return 'Socialize';
    }
  }
}