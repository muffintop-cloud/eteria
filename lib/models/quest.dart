import 'package:hive/hive.dart';
part 'quest.g.dart';

enum Difficulty { low, medium, high }
enum QuestCategory { daily, side, main }
enum QuestReward { coins, spirit }

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
  int rewardTypeIndex; // 0 = coins, 1 = spirit

  Quest({
    required this.title,
    this.isCompleted = false,
    this.difficultyIndex = 0,
    this.deadlineTimestamp,
    this.categoryIndex = 1,
    List<String>? objectives,
    List<bool>? objectivesDone,
    List<int>? skillIndices,
    this.rewardTypeIndex = 0,
  }) {
    this.objectives = objectives ?? [];
    this.objectivesDone = objectivesDone ?? [];
    this.skillIndices = skillIndices ?? [];
  }

  
}
