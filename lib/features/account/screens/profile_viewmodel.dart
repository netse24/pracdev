import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:procdev/models/user_profile.dart';
// Make sure this import points to your UserProfile model

class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile? _userProfile;
  bool _isLoading = true; // Start in a loading state

  // Controllers for the text fields
  late TextEditingController nameController;
  late TextEditingController genderController;
  late TextEditingController dobController;
  late TextEditingController emailController;

  ProfileViewModel() {
    // Initialize empty controllers immediately
    nameController = TextEditingController();
    genderController = TextEditingController();
    dobController = TextEditingController();
    emailController = TextEditingController();
    // Start fetching the data from Firebase
    _loadUserProfile();
  }

  // Getters for the UI to access the data and loading state
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> _loadUserProfile() async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      _isLoading = false;
      notifyListeners();
      return; // Exit if no user is logged in
    }

    // Fetch the user's data document from the 'users' collection
    final docSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (docSnapshot.exists) {
      _userProfile = UserProfile.fromFirestore(
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    } else {
      // Create a default profile if one doesn't exist yet
      _userProfile = UserProfile(
        fullName: currentUser.email?.split('@')[0] ?? 'New User',
        email: currentUser.email ?? '',
        gender: '',
        dateOfBirth: DateTime.now(),
      );
    }

    // Now, update the controllers with the data we just fetched
    nameController.text = _userProfile!.fullName;
    genderController.text = _userProfile!.gender;
    emailController.text = _userProfile!.email;
    // Set the date of birth text field
    dobController.text =
        DateFormat('dd/MM/yyyy').format(_userProfile!.dateOfBirth);

    _isLoading = false; // We're done loading
    notifyListeners(); // Tell the UI to rebuild with the new data
  }

  // --- COMPLETED SAVE LOGIC ---
  Future<void> saveProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null || _userProfile == null) {
      Get.snackbar('Error', 'You must be logged in to save your profile.');
      return;
    }

    // Update the local user profile object with the latest data from the text fields
    _userProfile!.fullName = nameController.text;
    _userProfile!.gender = genderController.text;
    _userProfile!.email = emailController.text;
    // The dateOfBirth is already updated in _userProfile by the pickDate method

    try {
      // Get a reference to the user's document in Firestore
      final docRef = _firestore.collection('users').doc(currentUser.uid);

      // Save the updated profile data.
      // We use .set() with merge:true to create the document if it doesn't exist,
      // or update it without overwriting other fields.
      await docRef.set(_userProfile!.toFirestore(), SetOptions(merge: true));

      Get.snackbar('Success', 'Profile saved successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile: $e');
    }
  }

  // --- COMPLETED DATE PICKING LOGIC ---
  Future<void> pickDate(BuildContext context) async {
    if (_userProfile == null) return;

    // Show the built-in Flutter date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _userProfile!.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date
    );

    // If the user picked a date (didn't press cancel)
    if (pickedDate != null && pickedDate != _userProfile!.dateOfBirth) {
      // 1. Update our data model
      _userProfile!.dateOfBirth = pickedDate;

      // 2. Update the text controller so the UI shows the new date
      dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);

      // 3. Notify listeners in case any other part of the UI depends on this
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    dobController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
