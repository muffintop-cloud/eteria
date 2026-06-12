import 'package:eteria/screens/title_screen.dart';
import 'package:eteria/services/character_service.dart';
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Quests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Character'),
        ],
      ),
    );
  }
}
