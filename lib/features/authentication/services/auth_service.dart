import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:procdev/features/home/screens/main_screen.dart'; // Using Get for snackbars is a good practice

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
  User? get currentUser => _user;
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

  Future<bool> signInWithFacebook() async {
    try {
      // 1. Trigger the Facebook login popup and ask for permissions
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      // 2. Check if the login was successful
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // 3. Get the OAuth credential for Firebase
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // 4. Sign in to Firebase Authentication with the Facebook credential
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // 5. Fetch the user's profile data from Facebook
          final userData = await FacebookAuth.instance.getUserData();
          final String name = userData['name'] ?? '';
          final String email = userData['email'] ?? '';
          // Safely get the profile picture URL
          final String? photoUrl = userData['picture']?['data']?['url'];

          // 6. Save/Update the user's data in Firestore
          // We use .set with merge:true. This will create the user document if it's their
          // first time logging in, or update their details if they've logged in before.
          await _firestore.collection('users').doc(user.uid).set({
            'fullName': name,
            'email': email,
            'photoUrl': photoUrl, // <-- SAVE THE PROFILE PICTURE URL HERE
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          return true; // Indicate success
        }
      } else {
        // Handle login cancellation or failure
        Get.snackbar('Facebook Login Failed',
            result.message ?? 'The login was cancelled.');
        return false;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.message ?? 'An error occurred.');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return false;
    }
  }

  // --- REAL SIGN-OUT METHOD ---
  Future<void> signOut() async {
    await _auth.signOut();
    // The authStateChanges listener will handle setting the user to null.
  }
}
