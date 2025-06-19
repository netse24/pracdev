import 'package:flutter/material.dart';
import 'package:procdev/data/shared_pref_data.dart';
import 'package:procdev/routes/app_routes.dart';

class AccountScreent extends StatefulWidget {
  const AccountScreent({super.key});

  @override
  State<AccountScreent> createState() => _AccountScreentState();
}

class _AccountScreentState extends State<AccountScreent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                SharedPrefData.logout();
                AppRoute.key.currentState!
                    .pushReplacementNamed(AppRoute.splash);
              },
              child: Text("Logout"))),
    );
  }
}
