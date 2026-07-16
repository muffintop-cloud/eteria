import 'package:eteria/screens/title_screen.dart';
import 'package:eteria/services/character_service.dart';
import 'package:eteria/styles/app_colors.dart' show AppColors;
import 'package:eteria/widgets/stats_bar.dart';
import 'package:flutter/material.dart';
import 'package:eteria/screens/home_screen.dart';
import 'package:eteria/screens/quests_screen.dart';
import 'package:eteria/screens/shop_screen.dart';
import 'package:eteria/screens/character_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainShellState();
  }
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuestsScreen(),
    ShopScreen(),
    CharacterScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!CharacterService.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const TitleScreen();
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(bottom: false, child: StatsBar()),
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _screens),
          ),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,

        backgroundColor: AppColors.mainBrown,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.panel,

        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
