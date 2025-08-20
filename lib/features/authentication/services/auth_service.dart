import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Using Get for snackbars is a good practice

// ====================================================================
// File: lib/features/authentication/services/auth_service.dart
// Service to handle Firebase authentication logic.
// ====================================================================

class AuthService extends ChangeNotifier {
  // --- REAL FIREBASE INSTANCES ---
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool get isAuthenticated => _user != null;

  AuthService() {
    // This is the real-time listener for auth state.
    // It will automatically update the app when a user logs in or out.
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // --- REAL-TIME AUTH LISTENER ---
  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    print(
        "Auth state changed: User is ${user == null ? 'logged out' : 'logged in'}");
    notifyListeners(); // This will notify your app to rebuild where necessary
  }

  // --- REAL SIGN-IN METHOD ---
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // The authStateChanges listener will handle the rest.
      return true;
    } on FirebaseAuthException catch (e) {
      print("Sign-in error: ${e.code}");
      Get.snackbar('Sign-In Error', e.message ?? 'An unknown error occurred.');
      return false;
    } catch (e) {
      print("Unexpected sign-in error: $e");
      Get.snackbar('Error', 'An unexpected error occurred.');
      return false;
    }
  }

  // --- REAL REGISTER METHOD (WITH FIRESTORE INTEGRATION) ---
  // Now it accepts the 'name' parameter
  Future<bool> register(String name, String email, String password) async {
    try {
      // Step 1: Create the user in Firebase Authentication
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? newUser = userCredential.user;

      if (newUser != null) {
        // Step 2: Create a document for the user in Firestore to store their full name
        await _firestore.collection('users').doc(newUser.uid).set({
          'fullName': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          // Add other default fields if you want
          'gender': '',
          'dateOfBirth': null,
        });

        // The authStateChanges listener will handle the login state.
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print("Registration error: ${e.code}");
      if (e.code == 'weak-password') {
        Get.snackbar(
            'Registration Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
            'Registration Error', 'An account already exists for that email.');
      } else {
        Get.snackbar(
            'Registration Error', e.message ?? 'An unknown error occurred.');
      }
      return false;
    } catch (e) {
      print("Unexpected registration error: $e");
      Get.snackbar('Error', 'An unexpected error occurred.');
      return false;
    }
  }

  // --- REAL SIGN-OUT METHOD ---
  Future<void> signOut() async {
    await _auth.signOut();
    // The authStateChanges listener will handle setting the user to null.
  }
}
