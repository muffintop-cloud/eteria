import 'package:eteria/styles/appearance_styles.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/character.dart';
import 'package:eteria/models/shop_item.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/services/shop_service.dart';
import 'package:eteria/styles/app_styles.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() {
    return _ShopScreenState();
  }
}

class _ShopScreenState extends State<ShopScreen> {
  void showPurchaseConfirmation(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> onPurchase(ShopItem item) async {
    String result = await ShopService.purchase(item);
    setState(() {
      showPurchaseConfirmation(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CharacterService.notifier,
      builder: (context, value, child) {
        Character? character = CharacterService.current;
        if (character == null) {
          return const Center(child: Text('No character found.'));
        }
        List<ShopItem> items = ShopCatalogue.cosmeticItems;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('The Market', style: AppStyles.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Trade coins for new styles.',
                    style: AppStyles.description,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // item grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppStyles.mediumPadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  ShopItem item = items[index];
                  bool isOwned = character.hasUnlocked(item.id);
                  bool canAfford = character.coins >= item.price;

                  return _ShopTile(
                    item: item,
                    isOwned: isOwned,
                    canAfford: canAfford,
                    onBuy: () {
                      onPurchase(item);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShopTile extends StatelessWidget {
  final ShopItem item;
  final bool isOwned;
  final bool canAfford;
  final VoidCallback onBuy;

  static const Color _coinColor = AppStyles.coinColor;

  const _ShopTile({
    required this.item,
    required this.isOwned,
    required this.canAfford,
    required this.onBuy,
  });

  Widget _itemPreview() {
    if (item.cosmeticCategory == null) {
      return Icon(item.icon,
        color: isOwned ? Colors.green : _coinColor, size: 26);
    } // if no cosmetic category is set, asset cant be loaded --> show icon

    String assetPath =
      AppearanceStyles.assetPath(item.cosmeticCategory!, item.id.trim());
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => Icon(
          item.icon,
          color: isOwned ? Colors.green : _coinColor,
          size: 26,
        ),
      ),
    );
  } 


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isOwned
            ? Colors.green.withValues(alpha: 0.08)
            : Colors.grey.shade100,
        border: Border.all(
          color: isOwned
              ? Colors.green.withValues(alpha: 0.5)
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // item image preview
          Container(
            width: double.infinity,
            height: 72,
            margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            decoration: BoxDecoration(
              color: isOwned
                  ? Colors.green.withValues(alpha: 0.1)
                  : _coinColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _itemPreview(),
          ),
          const SizedBox(height: 6),

          // item name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              item.name,
              style: AppStyles.badgeText,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),

          // isOwned
          if (isOwned) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Owned',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            // price
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  size: 12,
                  color: _coinColor,
                ),
                const SizedBox(width: 3),
                Text(
                  '${item.price}',
                  style: AppStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _coinColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // buy button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford
                        ? _coinColor
                        : Colors.grey.shade300,
                    foregroundColor: canAfford ? Colors.white : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Buy',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
