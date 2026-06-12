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

    //await Hive.deleteBoxFromDisk('questBox');
    //await Hive.deleteBoxFromDisk('characterBox');

    await Hive.openBox<Character>('characterBox');
    await Hive.openBox<Quest>('questBox');
  }
}