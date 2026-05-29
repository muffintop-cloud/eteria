import 'package:hive/hive.dart';
part 'quest.g.dart';

enum Difficulty { low, medium, high }
enum QuestCategory { daily, side, main }

@HiveType(typeId: 4)
class Quest extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  int difficultyIndex;

  @HiveField(3)
  int? deadlineTimestamp;

  @HiveField(4)
  int categoryIndex;

  @HiveField(5)
  List<String>? objectives;

  @HiveField(6)
  List<bool>? objectivesDone;

  @HiveField(7)
  List<int>? skillIndices; // Skills related to the quest

  @HiveField(8)
  @Deprecated('reward type removed')
  int unusedRewardType = 0;

  Quest({
    required this.title,
    this.isCompleted = false,
    this.difficultyIndex = 0,
    this.deadlineTimestamp,
    this.categoryIndex = 1,
    List<String>? objectives,
    List<bool>? objectivesDone,
    List<int>? skillIndices,
  }) {
    this.objectives = objectives ?? [];
    this.objectivesDone = objectivesDone ?? [];
    this.skillIndices = skillIndices ?? [];
  }

  // getters 
  Difficulty get difficulty { return Difficulty.values[difficultyIndex]; }
  QuestCategory get category { return QuestCategory.values[categoryIndex]; }

  int get xpReward { return difficulty.xpReward; }
  int get coinReward { return difficulty.coinReward; } // these 2 allow quest_service.dart to call quest.xpReward and quest.coinReward directly without having to go through quest.difficulty.xpReward every time

  DateTime? get deadline {
    if (deadlineTimestamp == null) {
      return null;
    } // if there's no deadline, return null

    DateTime convertedDate = DateTime.fromMillisecondsSinceEpoch(
      deadlineTimestamp!,
    );
    return convertedDate; // convert timestamp to DateTime object
  }

  bool get isOverdue {
    if (deadline == null) return false; // if there's no deadline, it can't be overdue
    if (isCompleted == true) return false; // if a quest is completed, it can't be overdue
    return deadline!.isBefore(DateTime.now()); 
  }
}

// difficulty extensions

extension DifficultyExtension on Difficulty {
  int get xpReward {
    switch (this) {
      case Difficulty.low:
        return 10;
      case Difficulty.medium:
        return 25;
      case Difficulty.high:
        return 50;
    }
  } // xp reward for a completed quest depending on the quest difficulty

  int get coinReward {
    switch (this) {
      case Difficulty.low:
        return 5;
      case Difficulty.medium:
        return 15;
      case Difficulty.high:
        return 30;
    }
  } // coin reward for a completed quest depending on the quest difficulty

  String get label {
    switch (this) {
      case Difficulty.low:
        return 'Low';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.high:
        return 'High';
    }
  } // difficulty label
}

// category extensions

extension QuestCategoryExtension on QuestCategory {
  String get label {
    switch (this) {
      case QuestCategory.daily:
        return 'Daily';
      case QuestCategory.side:
        return 'Side';
      case QuestCategory.main:
        return 'Main';
    }
  }

  String get description {
    switch (this) {
      case QuestCategory.daily:
        return 'Repeats every day';
      case QuestCategory.side:
        return 'Optional quest';
      case QuestCategory.main:
        return 'Main quest';
    }
  }
}
