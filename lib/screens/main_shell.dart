import 'package:flutter/material.dart';
import 'package:eteria/screens/home_screen.dart';
import 'package:eteria/screens/quests_screen.dart';
import 'package:eteria/screens/world_screen.dart';
import 'package:eteria/screens/shop_screen.dart';
import 'package:eteria/screens/character_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(), QuestsScreen(), WorldScreen(), ShopScreen(), CharacterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        //  SafeArea(bottom: false, child: StatsBar(key: ValueKey(CharacterService.current?.xp)),),
         Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Quests'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'World'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Character'),
        ],
      ),
    );
  }
}