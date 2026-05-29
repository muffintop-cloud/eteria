import 'package:flutter/material.dart';

enum ShopItemType { cosmetic, consumable }
enum ShopCurrency { coins }

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final ShopItemType type;
  final IconData icon;
  final String? cosmeticCategory; // for cosmetics, which category does it belong to (hair/outfit/eyes), null for consumables
  
  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.icon,
    this.cosmeticCategory,
  });
}