import 'package:eteria/screens/main_shell.dart';
import 'package:eteria/services/hive_service.dart';
import 'package:eteria/services/needs_service.dart';
import 'package:flutter/material.dart';
import 'package:eteria/styles/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await NeedsService.checkForDailyReset();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Afacad',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainBrown,
          primary: AppColors.mainBrown,
          surface: AppColors.background,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.darkBrown,
            textStyle: const TextStyle(
              fontFamily: 'Afacad',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
