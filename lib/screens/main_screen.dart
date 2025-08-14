import 'package:flutter/material.dart';
import 'package:procdev/screens/account_screent.dart';
import 'package:procdev/screens/cart_screen.dart';
import 'package:procdev/screens/favorite_screen.dart';
import 'package:procdev/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          FavoriteScreen(),
          CartScreen(),
          AccountScreent()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Color(0xFFFFE5EC),
        selectedItemColor: Color(0xFFF275A7),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            activeIcon: Icon(Icons.home, color: Color(0xFFF275A7)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Colors.grey),
            activeIcon: Icon(Icons.category, color: Color(0xFFF275A7)),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article, color: Colors.grey),
            activeIcon: Icon(Icons.article, color: Color(0xFFF275A7)),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.grey),
            activeIcon: Icon(Icons.shopping_cart, color: Color(0xFFF275A7)),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.grey),
            activeIcon: Icon(Icons.account_circle, color: Color(0xFFF275A7)),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
