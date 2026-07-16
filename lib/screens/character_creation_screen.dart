import 'package:eteria/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:eteria/styles/appearance_styles.dart';
import 'package:eteria/screens/class_selection_screen.dart';
import 'package:eteria/models/shop_item.dart';

class CharacterCreationScreen extends StatefulWidget {
  final bool
  editMode; // true -> editing an existing character's appearance

  const CharacterCreationScreen({super.key, this.editMode = false});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _activeTab = 0;

  Map<String, String> _selections = {
    'body': 'body_1',
    'hair': 'hair_1',
    'eyes': 'eye_1',
    'outfits': 'outfit_1',
  };

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      var character = CharacterService.current;
      if (character != null) {
        _nameController.text = character.name;
        _selections = {
          'body': character.body,
          'hair': character.hair,
          'eyes': character.eyes,
          'outfits': character.outfit,
        };
      }
    } // if editMode == true, return character with the current appearance
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String getActiveCategory() {
    return AppearanceStyles.tabs[_activeTab].id;
  }

  List<String> getActiveOptions() {
    // returns list of options for the current tab
    String category = getActiveCategory();

    List<String> allOptions = [];
    List<String>? defaultOptions = AppearanceStyles.options[category];
    if (defaultOptions != null) {
      allOptions = List.from(defaultOptions);
    } // return default built-in options for the current category

    if (widget.editMode) {
      var character = CharacterService.current;
      if (character != null) {
        for (String unlockedId in character.unlockedItems!) {
          for (ShopItem item in ShopCatalogue.allItems) {
            // find item id in shop catalogue to check which category it belongs to
            bool itemCheck = item.id == unlockedId;
            bool categoryCheck = item.cosmeticCategory == category;
            bool addedCheck = !allOptions.contains(unlockedId);
            if (itemCheck && categoryCheck && addedCheck) {
              allOptions.add(unlockedId);
            }
          }
        }
      }
    } // edit mode: check if character has unlocked any additional cosmetics from the shop
    return allOptions;
  }

  // next/save button
  Future<void> onActionButton() async {
    if (widget.editMode) { // character already exists
      String name = _nameController.text.trim();
      if(name.isNotEmpty) {
        await CharacterService.updateName(name);
      } 

      await CharacterService.updateAppearance(
        body: _selections['body'] ?? 'body_1',
        hair: _selections['hair'] ?? 'hair_1',
        eyes: _selections['eyes'] ?? 'eye_1',
        outfit: _selections['outfits'] ?? 'outfit_1',
      );
      if (!mounted) return; // if widget is not on screen, do not pop
      Navigator.of(context).pop(); // go back to character screen
    } else {
      // new character creation, save goes to class selection screen
      String name = _nameController.text.trim();
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a character name.')),
        );
        return;
      }
      Map<String, String> selectionsCopy =
          {}; // make a copy of the selections to pass to the next screen
      _selections.forEach((String key, String value) {
        selectionsCopy[key] = value;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ClassSelectionScreen(name: name, selections: selectionsCopy),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(context),
            buildNameField(context),
            const SizedBox(height: 16),

            Expanded(child: characterDisplay(context)),
            const SizedBox(height: 16),

            buildTabRow(context), // tabs above options panel
            buildOptionsPanel(context), // grid of selectable tiles
            const SizedBox(height: 16),
            buildActionButton(context), // next/save button
          ],
        ),
      ),
    );
  }

  // build methods

  Widget buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // back arrow in edit mode
          if (widget.editMode) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // progress bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mainBrown, width: 1),
                borderRadius: BorderRadius.circular(AppStyles.smallRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppStyles.smallRadius),
                child: LinearProgressIndicator(
                  value: widget.editMode ? 1.0 : 0.5,
                  minHeight: 4,
                  backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            widget.editMode ? 'Edit appearance' : 'Appearance',
            style: AppStyles.label,
          ),
        ],
      ),
    );
  }

  // character name text field
  Widget buildNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 12, 40, 0),
      child: TextField(
        controller: _nameController,
        textAlign: TextAlign.center,
        style: AppStyles.label,
        decoration: InputDecoration(
          hintText: 'Character name',
          hintStyle: AppStyles.bodyText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightBrown),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainBrown, width: 2),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
        ),
      ),
    );
  }

  // character display
  Widget characterDisplay(BuildContext context) {
    String bodyOption = _selections['body'] ?? 'body_1';
    String eyesOption = _selections['eyes'] ?? 'eye_1';
    String hairOption = _selections['hair'] ?? 'hair_1';
    String outfitOption = _selections['outfits'] ?? 'outfit_1';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
          border: Border.all(color: AppColors.mainBrown, width: 1.5),
          boxShadow: AppStyles.panelShadow,
        ),
        child: ClipRRect(
          // clips the Stack to the rounded corners so png images dont bleed outside the container
          borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit
                .expand, // makes every layer fill the full stack size so they all scale the same way
            children: [
              Image.asset(
                AppearanceStyles.assetPath('body', bodyOption),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.person, size: 110, color: AppColors.mainBrown),
                  );
                },
              ),

              Image.asset(
                AppearanceStyles.assetPath('eyes', eyesOption),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink(); // missing files show nothing
                },
              ),

              Image.asset(
                AppearanceStyles.assetPath('hair', hairOption),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink(); 
                },
              ),

              Image.asset(
                AppearanceStyles.assetPath('outfits', outfitOption),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink(); 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabRow(BuildContext context) {
    // tab row: body | hair | eyes | outfits
    List<Widget> tabWidgets = []; // list of tab widgets built using a for loop

    for (int i = 0; i < AppearanceStyles.tabs.length; i++) {
      AppearanceTab tab = AppearanceStyles.tabs[i];
      bool active = (_activeTab == i);

      double rightMargin; // all tabs except the last one have a small right margin to create a visible gap between them
      if (i < AppearanceStyles.tabs.length - 1) {
        rightMargin = 4.0;
      } else {
        rightMargin = 0.0;
      }

      Widget tabWidget = Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _activeTab = i;
            });
          }, // when tapped, update _activeTab and rebuild so the options panel shows the right category

          child: AnimatedContainer(
            // smooth transitions between active and inactive tabs
            duration: const Duration(milliseconds: 180),
            height: AppearanceStyles.tabHeight,
            margin: EdgeInsets.only(right: rightMargin),
            decoration: AppearanceStyles.tabDecoration(
              active: active,
              accent: AppColors.mainBrown,
              context: context,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tab.icon,
                  size: 24,
                  color: active ? AppColors.darkBrown : AppColors.darkBrown,
                ),
              ],
            ),
          ),
        ),
      );
      tabWidgets.add(tabWidget);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(children: tabWidgets),
    );
  }

  // scrollable options panel
  Widget buildOptionsPanel(BuildContext context) {
    const Color accent = AppColors.darkBrown;
    String activeCategory = getActiveCategory();
    List<String> options = getActiveOptions();
    String selected = _selections[activeCategory] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: AppearanceStyles.optionsPanel(context),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: AppearanceStyles.tileSpacing,
            crossAxisSpacing: AppearanceStyles.tileSpacing,
            childAspectRatio: 1.5,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = (selected == option);
      
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selections[activeCategory] = option;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: AppearanceStyles.tileDecoration(
                  selected: isSelected,
                  accent: accent,
                  context: context,
                ),
      
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppearanceStyles.tileRadius,
                  ),
                  child: Image.asset(
                    AppearanceStyles.assetPath(activeCategory, option),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          AppearanceStyles.placeholderIcon(activeCategory),
                          size: 28,
                          color: isSelected ? accent : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // button
  Widget buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onActionButton,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
              side: BorderSide(color: AppColors.mainBrown, width: 1.5),
            ),
          ),
          child: Text(
            widget.editMode ? 'Save changes' : 'Next',
            style: AppStyles.titleSmall,
          ),
        ),
      ),
    );
  }
}