import 'package:flutter/material.dart';
// ====================================================================
// File: lib/features/home/screens/news_screen.dart
// The news/promotions screen.
// ====================================================================

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: const Center(
        child: Text('News Screen Content'),
      ),
    );
  }
}
