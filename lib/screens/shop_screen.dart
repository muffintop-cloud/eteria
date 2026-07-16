import 'package:eteria/styles/app_colors.dart';
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
    setState(() {});
    showPurchaseConfirmation(result);
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
            buildHeader(context),
            buildItemGrid(context, character, items),
          ],
        );
      },
    );
  }

  // BUILD METHODS
  Widget buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('THE MARKET', style: AppStyles.titleLarge)],
      ),
    );
  }

  Widget buildItemGrid(BuildContext context, Character character, List<ShopItem> items) {
    // item grid
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(AppStyles.mediumPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 280, // sets a fixed pixel height for every tile
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
    );
  }
}

class _ShopTile extends StatelessWidget {
  final ShopItem item;
  final bool isOwned;
  final bool canAfford;
  final VoidCallback onBuy;

  const _ShopTile({
    required this.item,
    required this.isOwned,
    required this.canAfford,
    required this.onBuy,
  });

  Widget _itemPreview() {
    if (item.cosmeticCategory == null) {
      return Icon(
        item.icon,
        color: isOwned ? AppColors.green : AppColors.gold,
        size: 26,
      );
    } // if no cosmetic category is set, asset cant be loaded --> show icon

    String assetPath = AppearanceStyles.assetPath(
      item.cosmeticCategory!,
      item.id.trim(),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => Icon(
          item.icon,
          color: isOwned ? AppColors.green : AppColors.gold,
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
            ? AppColors.green
            : AppColors.panel,
        border: Border.all(color: AppColors.mainBrown),
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppStyles.panelShadow,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // item image preview
          Container(
            width: double.infinity,
            height: 130,
            margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            decoration: BoxDecoration(
              color: isOwned
                  ? AppColors.panel
                  : AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.mainBrown, width: 1),
            ),
            child: _itemPreview(),
          ),
          const SizedBox(height: 2),

          // item name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              item.name,
              style: AppStyles.titleSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),

          // owned/buy
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: isOwned ? _owned() : _buy(),
          ),
        ],
      ),
    );
  }

  Widget _owned() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainBrown,
          borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
          border: Border.all(color: AppColors.mainBrown),
        ),
        alignment: Alignment.center,
        child: const Text(
          'OWNED',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.panel,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buy() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // price
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.monetization_on_outlined,
              size: 20,
              color: AppColors.gold,
            ),
            const SizedBox(width: 3),
            Text('${item.price}', style: AppStyles.titleSmall),
          ],
        ),

        const SizedBox(height: 4),

        // buy button
        Container(
          decoration: BoxDecoration(
            boxShadow: canAfford ? AppStyles.panelShadow : null,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: canAfford ? onBuy : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford
                    ? AppColors.orange
                    : Colors.grey.shade300,
                foregroundColor: canAfford ? Colors.white : Colors.grey,
                side: const BorderSide(color: AppColors.mainBrown),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
                ),
              ),
              child: const Text(
                'BUY',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
