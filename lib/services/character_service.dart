import 'package:hive/hive.dart';
import '../models/character.dart';

class CharacterService {
  static Box<Character> get _box {
    return Hive.box<Character>('characterBox');
  }
}