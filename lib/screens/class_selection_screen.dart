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
      body: SafeArea(
        child: Column(
          children: [
            // top bar
            Padding(
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppStyles.smallRadius,
                      ),
                      child: LinearProgressIndicator(
                        value: widget.editMode ? 1.0 : 1.0,
                        minHeight: 4,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.editMode ? 'Change class' : 'Choose class',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // class list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.editMode
                          ? 'Change your class'
                          : 'Hello, ${widget.name}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a class that matches your lifestyle.',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    const SizedBox(height: AppStyles.largePadding),

                    for (CharacterClass c in CharacterClass.values) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedClass = c;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(
                            bottom: AppStyles.smallPadding,
                          ),
                          padding: const EdgeInsets.all(
                            AppStyles.mediumPadding,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedClass == c
                                ? AppStyles.classColor(c).withValues(alpha: 0.1)
                                : const Color.fromARGB(255, 213, 213, 213),
                            border: Border.all(
                              color: _selectedClass == c
                                  ? AppStyles.classColor(c)
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppStyles.mediumRadius,
                            ),
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
                                        Text(
                                          c.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: _selectedClass == c
                                                ? AppStyles.classColor(c)
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          c.theme,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Daily: ${c.dailyRequirement}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      'Bonus: ${c.bonusDescription}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppStyles.classColor(c),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedClass == c)
                                Icon(
                                  Icons.check_circle,
                                  color: AppStyles.classColor(c),
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: finish,
                  child: Text(widget.editMode ? 'Save' : 'Begin'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
