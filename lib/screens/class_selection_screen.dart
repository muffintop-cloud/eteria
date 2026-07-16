import 'package:eteria/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:eteria/models/character.dart';
import 'package:eteria/models/character_class.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/styles/app_styles.dart';
import 'main_shell.dart';

class ClassSelectionScreen extends StatefulWidget {
  final String name;
  final Map<String, String> selections;

  final bool
  editMode; // true -> user is changing their class from the character screen

  const ClassSelectionScreen({
    super.key,
    required this.name,
    required this.selections,
    this.editMode = false,
  });

  @override
  State<ClassSelectionScreen> createState() {
    return _ClassSelectionScreenState();
  }
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  CharacterClass? _selectedClass;

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _selectedClass = CharacterService.current?.characterClass;
    }
  } // if editing, pre-select the current class so the user sees which one they already have

  Future<void> finish() async {
    if (_selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PLease choose a class.'),
        ),
      );
      return;
    }

    if (widget.editMode) {
      await CharacterService.updateClass(
        _selectedClass!,
      ); // update the class on the existing character
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      await CharacterService.create(
        Character(
          name: widget.name,
          classIndex: _selectedClass!.index,
          body: widget.selections['body'] ?? 'body_1',
          eyes: widget.selections['eyes'] ?? 'eye_1',
          hair: widget.selections['hair'] ?? 'hair_1',
          outfit: widget.selections['outfits'] ?? 'outfit_1',
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            return const MainShell();
          },
        ),
        (route) {
          return false;
        },
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
            buildClassList(context),
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  // build methods

  // top bar
  Widget buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
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

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mainBrown, width: 1),
                borderRadius: BorderRadius.circular(AppStyles.smallRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppStyles.smallRadius),
                child: LinearProgressIndicator(
                  value: widget.editMode ? 1.0 : 1.0,
                  minHeight: 4,
                  backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.editMode ? 'Change class' : 'Choose class',
            style: AppStyles.label,
          ),
        ],
      ),
    );
  }

  // class list
  Widget buildClassList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              widget.editMode ? 'Change your class' : 'Hello, ${widget.name}!',
              style: AppStyles.titleMedium,
            ),
            Text(
              'Choose a class that matches your lifestyle.',
              style: AppStyles.bodyText,
            ),
            const SizedBox(height: 8),

            for (CharacterClass c in CharacterClass.values) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedClass = c;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: AppStyles.smallPadding),
                  padding: const EdgeInsets.all(AppStyles.mediumPadding),
                  decoration: BoxDecoration(
                    color: _selectedClass == c
                        ? AppColors.panel.withValues(alpha: 0.8)
                        : AppColors.panel,
                    border: Border.all(
                      color: _selectedClass == c
                          ? AppStyles.classColor(c)
                          : AppColors.mainBrown,
                      width: 1.5,
                    ),
                    boxShadow: _selectedClass == c 
                          ? AppStyles.panelShadow 
                          : null,
                    borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppStyles.classColor(
                            c,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppStyles.smallRadius,
                          ),
                          border: Border.all(
                            color: AppColors.mainBrown,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          AppStyles.classIcon(c),
                          color: AppStyles.classColor(c),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: AppStyles.mediumPadding),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(c.name, style: AppStyles.titleSmall),
                                const Spacer(),
                                Text(
                                  c.theme,
                                  style: AppStyles.description,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Daily: ${c.dailyRequirement}',
                              style: AppStyles.bodyText,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Bonus: ${c.bonusDescription}',
                              style: AppStyles.bodyText,
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: _selectedClass == c ? 1.0 : 0.0,
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.mainBrown,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
 
  // confirm button
  Widget buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: finish,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
              side: BorderSide(color: AppColors.mainBrown, width: 1.5),
            ),
          ),
          child: Text(
            widget.editMode ? 'Save' : 'Begin',
            style: AppStyles.titleSmall,
          ),
        ),
      ),
    );
  }
}
