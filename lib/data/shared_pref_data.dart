import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefData {
  static const String UNAME = "USERNAME";
  static const String EMAIL = "EMIAL";
  static const String PASSWORD = "PASSWORD";

  static Future<void> login(String email, String password) async {
    // Create SharedPreferences
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(EMAIL, email);
    await sharedPref.setString(PASSWORD, password);
  }

  static Future<void> register(
    String fullName,
    String email,
    String password,
  ) async {
    // Create SharedPreferences
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(UNAME, fullName);
    await sharedPref.setString(EMAIL, email);
    await sharedPref.setString(PASSWORD, password);
  }

  static Future<void> logout() async {
    // Create SharedPreferences
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(UNAME);
    await sharedPref.remove(EMAIL);
    await sharedPref.remove(PASSWORD);
  }
}
