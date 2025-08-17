import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ====================================================================
// File: lib/features/authentication/services/auth_service.dart
// Service to handle Firebase authentication logic.
// ====================================================================
// import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  // final _auth = FirebaseAuth.instance;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    // This is a mock check, in a real app, you would listen to `_auth.authStateChanges()`
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    // try {
    //   await _auth.signInWithEmailAndPassword(email: email, password: password);
    //   _isAuthenticated = true;
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setString('user_token', 'mock_token');
    //   notifyListeners();
    //   return true;
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', 'mock_token');
    notifyListeners();
    return true; // Mock success
  }

  Future<bool> register(String email, String password) async {
    // try {
    //   await _auth.createUserWithEmailAndPassword(email: email, password: password);
    //   _isAuthenticated = true;
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setString('user_token', 'mock_token');
    //   notifyListeners();
    //   return true;
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', 'mock_token');
    notifyListeners();
    return true; // Mock success
  }

  Future<void> signOut() async {
    // await _auth.signOut();
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_token');
    notifyListeners();
  }
}
