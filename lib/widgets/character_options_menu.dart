import 'package:eteria/models/character.dart';
import 'package:eteria/screens/character_creation_screen.dart';
import 'package:eteria/screens/title_screen.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/services/quest_service.dart';
import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';

void showCharacterOptionsMenu(BuildContext context, Character character) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppStyles.largeRadius),
        topRight: Radius.circular(AppStyles.largeRadius),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppStyles.mediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('OPTIONS', style: AppStyles.titleSmall),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(
                  Icons.face_retouching_natural,
                  color: AppColors.mainBrown,
                ),
                title: const Text('Edit appearance', style: AppStyles.label),
                subtitle: const Text(
                  'Change body, hair, eyes, outfit',
                  style: AppStyles.bodyText,
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const CharacterCreationScreen(editMode: true);
                      },
                    ),
                  );
                },
              ),
              const Divider(), // adds a thin line to separate options

              ListTile(
                leading: const Icon(Icons.delete_forever, color: AppColors.red),
                title: Text(
                  'Delete progress',
                  style: AppStyles.label.copyWith(color: AppColors.red),
                ),
                subtitle: Text(
                  'This will permanently delete all your progress and cannot be undone.',
                  style: AppStyles.bodyText,
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showConfirmDeletionDialog(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showConfirmDeletionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        
        child: Container(
          decoration: AppStyles.panelDecoration(),
          padding: const EdgeInsets.all(AppStyles.mediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Delete Progress?', style: AppStyles.titleMedium),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to delete your character and all progress? '
                'This cannot be undone.',
                style: AppStyles.bodyText,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('Cancel', style: AppStyles.label),
                  ),
                  //const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.panel,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppStyles.smallRadius,
                        ),
                        side: const BorderSide(
                          color: AppColors.mainBrown,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      await QuestService.deleteAllQuests();
                      await CharacterService.deleteCharacter();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) {
                            return const TitleScreen();
                          },
                        ),
                        (route) {
                          return false;
                        },
                      );
                    },
                    child: Text(
                      'Delete',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.bodyText.copyWith(
                        color: AppColors.panel,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
