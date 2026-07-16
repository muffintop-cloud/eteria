import 'package:eteria/styles/app_colors.dart';
import 'package:eteria/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'character_creation_screen.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/title_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Text(
                'ETERIA',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                  letterSpacing: 8,
                  shadows: [
                    Shadow(
                      color: AppColors.mainBrown,
                      offset: Offset(0,4 ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'A digital adventure \nmirrored by your real life.',
                style: AppStyles.bodyText,
                textAlign: TextAlign.center
              ),
              const Spacer(flex: 3),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: AppColors.darkBrown,
                      padding: const EdgeInsets.symmetric(vertical: AppStyles.mediumPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppStyles.mediumRadius),
                        side: BorderSide(color: AppColors.mainBrown, width: 1.5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return const CharacterCreationScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Start your journey',
                      style: AppStyles.titleSmall,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}