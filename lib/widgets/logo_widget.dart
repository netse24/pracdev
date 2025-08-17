import 'package:flutter/material.dart';

// ====================================================================
// File: lib/widgets/logo_widget.dart
// A reusable widget for the app's logo.
// ====================================================================

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.pink[100],
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.person, color: Colors.pink, size: 30),
      ),
    );
  }
}
