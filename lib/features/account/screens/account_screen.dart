import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:procdev/config/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:procdev/features/account/screens/account_screen_detail.dart';
import 'package:procdev/features/authentication/screens/login_screen.dart';
import 'package:procdev/features/home/language/language_screen.dart';
import 'package:procdev/features/authentication/services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _fullName = "Guest";
  bool _isLogin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final User? user = await _auth.currentUser;
    String username = user?.displayName ?? user!.email!.split("@")[0];
    setState(() {
      _fullName = username;
      _isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("more".tr, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('language'.tr),
                  subtitle: Text(
                    Get.deviceLocale?.languageCode == "en"
                        ? "englishLanguage".tr
                        : "khmerLanguage".tr,
                  ),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Get.to(LanguageScreen());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text("profile".tr),
                  subtitle: Text("$_fullName"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    _validateLogin();
                  },
                ),
                Divider(),
              ],
            ),
          ),
          _isLogin ? _logoutButton : Container(),
        ],
      ),
    );
  }

  Widget get _logoutButton {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          onPressed: () {
            _logout();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("logout".tr, style: TextStyle(color: Colors.white)),
              SizedBox(width: 4),
              Icon(Icons.logout, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();
    Get.off(LoginScreen());
  }

  Future<void> _validateLogin() async {
    if (!_isLogin) {
      Get.off(LoginScreen());
    } else {
      // To Account Screen
      print("Navigating to Account Detail Screen");
      // Get.to(() => AccountScreenDetail());
      Get.to(AccountScreenDetail());
    }
  }
}
