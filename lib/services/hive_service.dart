import 'package:eteria/models/character.dart';
import 'package:eteria/models/inventory_item.dart';
import 'package:eteria/models/quest.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(QuestAdapter());
    Hive.registerAdapter(InventoryItemAdapter());

    await Hive.openBox<Character>('characterBox');
    await Hive.openBox<Quest>('questBox');

    final characterBox = Hive.box<Character>('characterBox');
    if (characterBox.isEmpty) {
      await characterBox.put(0, Character(
        name: 'tester',
        classIndex: 0,
        body: 'body_1',
        hair: 'hair_1',
        eyes: 'eye_1',
        outfit: 'outfit_1'
      ));
    }
  }
}