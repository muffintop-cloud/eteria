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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(context),
            buildNameField(context),
            const SizedBox(height: 8),

            Expanded(child: characterDisplay(context)),
            const SizedBox(height: 8),

            buildTabRow(context), // tabs above options panel
            buildOptionsPanel(context), // grid of selectable tiles
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
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppStyles.smallRadius),
              child: LinearProgressIndicator(
                value: widget.editMode ? 1.0 : 0.5,
                minHeight: 4,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade700),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            widget.editMode ? 'Edit appearance' : 'Appearance',
            style: AppStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
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
        style: AppStyles.bodyText.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Character name',
          hintStyle: AppStyles.labelSmall.copyWith(fontSize: 15),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
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
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          // clips the Stack to the rounded corners so png images dont bleed outside the container
          borderRadius: BorderRadius.circular(20),
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
                    child: Icon(Icons.person, size: 110, color: Colors.black12),
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
    const Color accent = Colors.black;
    List<Widget> tabWidgets = []; // list of tab widgets built using a for loop

    for (int i = 0; i < AppearanceStyles.tabs.length; i++) {
      AppearanceTab tab = AppearanceStyles.tabs[i];
      bool active = (_activeTab == i);

      double rightMargin; // all tabs except the last one have a small right margin to create a visible gap between them
      if (i < AppearanceStyles.tabs.length - 1) {
        rightMargin = 3.0;
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
              accent: accent,
              context: context,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tab.icon,
                  size: 13,
                  color: active ? accent : Colors.grey,
                ),
                const SizedBox(height: 2),
                Text(
                  tab.label,
                  style: AppearanceStyles.tabLabelStyle(
                    active: active,
                    accent: accent,
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      tabWidgets.add(tabWidget);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: tabWidgets),
    );
  }

  // scrollable options panel
  Widget buildOptionsPanel(BuildContext context) {
    const Color accent = Colors.black;
    String activeCategory = getActiveCategory();
    List<String> options = getActiveOptions();
    String selected = _selections[activeCategory] ?? '';

    return Container(
      height: AppearanceStyles.panelHeight,
      width: double.infinity,
      decoration: AppearanceStyles.panelDecoration(context),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppearanceStyles.tileSpacing,
          crossAxisSpacing: AppearanceStyles.tileSpacing,
          childAspectRatio: 1.0,
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
              decoration: AppearanceStyles.tabDecoration(
                active: isSelected,
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
    );
  }

  // button
  Widget buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onActionButton,
          child: Text(widget.editMode ? 'Save changes' : 'Next'),
        ),
      ),
    );
  }
}