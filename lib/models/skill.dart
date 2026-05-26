enum Skill {wisdom, vitality, artistry, charisma}

extension SkillExtension on Skill {
  String get label {
    switch(this) {
      case Skill.wisdom: return 'Wisdom';
      case Skill.vitality: return 'Vitality';
      case Skill.artistry: return 'Artistry';
      case Skill.charisma: return 'Charisma';
    }
  }

  String get iconAsset {
    switch(this) {
      case Skill.wisdom: return 'assets/skills/wisdom.png';
      case Skill.vitality: return 'assets/skills/vitality.png';
      case Skill.artistry: return 'assets/skills/artistry.png';
      case Skill.charisma: return 'assets/skills/charisma.png';
    }
  }
}

