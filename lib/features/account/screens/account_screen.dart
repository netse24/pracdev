import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../config/app_routes.dart';
import '../../authentication/services/auth_service.dart';

// ====================================================================
// File: lib/features/account/screens/account_screen.dart
// The user's account page.
// ====================================================================

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.pink),
            const SizedBox(height: 20),
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Welcome, User!'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                authService.signOut();
                Get.offAllNamed(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
