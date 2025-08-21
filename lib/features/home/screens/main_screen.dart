import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:procdev/features/home/screens/home_screen.dart';
import 'package:procdev/features/home/screens/news_screen.dart';
import 'package:procdev/features/account/screens/account_screen.dart';
import 'package:procdev/features/shopping_cart/screens/cart_screen.dart';
import 'package:procdev/features/categories/screens/category_screen.dart';

// ====================================================================
// File: lib/features/home/screens/main_screen.dart
// The main navigation screen with the bottom bar.
// ====================================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryScreen(),
    NewsScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'category'.tr),
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: 'news'.tr),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'cart'.tr),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'account'.tr),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
