import 'package:eteria/models/shop_item.dart';
import 'package:eteria/services/character_service.dart';

class ShopService {
  static Future<String> purchase(ShopItem item) async {
    var character = CharacterService.current;
    if (character == null) return 'No character found.';

    if (character.hasUnlocked(item.id)) {
      return 'You already own ${item.name}.';
    } // check if the item is already owned

    if (character.coins < item.price) {
      return 'Not enough coins. You need ${item.price} coins.';
    } // check if character can afford the item

    character.coins = character.coins - item.price;
    character.unlockedItems ??= [];
    character.unlockedItems!.add(item.id);

    await character.save();
    CharacterService.notify();
    return 'Purchased ${item.name}';
  }
}