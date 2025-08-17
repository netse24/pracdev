import 'package:flutter/material.dart';
// ====================================================================
// File: lib/features/home/screens/notification_screen.dart
// The notification screen.
// ====================================================================

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Text('Notifications Screen Content'),
      ),
    );
  }
}