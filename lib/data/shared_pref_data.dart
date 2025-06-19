import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefData {
  static const String emailKey = 'email';
  static const String passwordKey = 'password';
  static const String fullNameKey = 'fullName';

  static Future<void> login(String email, String password) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(emailKey, email);
    await sharedPref.setString(passwordKey, password);
  }

  static Future<void> register(
      String email, String password, String fullName) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(emailKey, email);
    await sharedPref.setString(passwordKey, password);
    await sharedPref.setString(fullNameKey, fullName);
  }

  static Future<void> logout() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(emailKey);
    await sharedPref.remove(passwordKey);
    await sharedPref.remove(fullNameKey);
  }
}
