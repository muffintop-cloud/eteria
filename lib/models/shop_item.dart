import 'package:flutter/material.dart';

enum ShopItemType { cosmetic }
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

class ShopCatalogue {
  static final List<ShopItem> allItems = [
    ShopItem(
      id: 'eye_6',
      name: 'Sparkly Eyes',
      description: 'A rare eye style from the deep forest.',
      price: 80,
      type: ShopItemType.cosmetic,
      icon: Icons.remove_red_eye,
      cosmeticCategory: 'eyes',
    ),

    ShopItem(
      id: 'hair_6',
      name: 'Golden Hair',
      description: 'Hair worthy of a princess.',
      price: 120,
      type: ShopItemType.cosmetic,
      icon: Icons.face_retouching_natural,
      cosmeticCategory: 'hair',
    ),

    ShopItem(
      id: 'hair_7',
      name: 'Ancient Curls',
      description: 'Messy curls for a seasoned adventurer.',
      price: 100,
      type: ShopItemType.cosmetic,
      icon: Icons.face_retouching_natural,
      cosmeticCategory: 'hair',
    ),

    ShopItem(
      id: 'outfit_3',
      name: 'Lotus Robe',
      description: 'A robe of wisdom and serenity.',
      price: 250,
      type: ShopItemType.cosmetic,
      icon: Icons.face_retouching_natural,
      cosmeticCategory: 'outfits',
    ),

    ShopItem(
      id: 'outfit_4',
      name: 'Midnight Hood',
      description: 'Comfortable and mysterious, perfect for night adventures.',
      price: 200,
      type: ShopItemType.cosmetic,
      icon: Icons.face_retouching_natural,
      cosmeticCategory: 'outfits',
    ),
  ];

  static List<ShopItem> get cosmeticItems {
    return allItems;
  }
}