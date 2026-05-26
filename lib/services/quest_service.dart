import 'package:hive/hive.dart';
import '../models/quest.dart';


class QuestService {
  static Box<Quest> get _box => Hive.box<Quest>('questBox');
}