import 'package:hive/hive.dart';

part 'inventory_item.g.dart';

@HiveType(typeId: 3)
class InventoryItem {

  @HiveField(0)
  String itemId;

  @HiveField(1)
  int quantity;

  InventoryItem({
    required this.itemId,
    this.quantity = 1,
  });
}