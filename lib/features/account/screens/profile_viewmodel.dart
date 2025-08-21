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
  bool _isLoading = true;

  // Controllers for text fields (Gender no longer needs one)
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController emailController;

  // A list of options for the gender dropdown menu.
  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  ProfileViewModel() {
    nameController = TextEditingController();
    dobController = TextEditingController();
    emailController = TextEditingController();
    _loadUserProfile();
  }

  // Getters for the UI
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> _loadUserProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final docSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (docSnapshot.exists) {
      _userProfile = UserProfile.fromFirestore(
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    } else {
      _userProfile = UserProfile(
        fullName: currentUser.displayName ??
            currentUser.email?.split('@')[0] ??
            'New User',
        email: currentUser.email ?? '',
        gender: '', // Default to empty
        dateOfBirth: DateTime.now(), // Default to now
      );
    }

    // Update controllers with the fetched data
    nameController.text = _userProfile!.fullName;
    emailController.text = _userProfile!.email;
    if (_userProfile!.dateOfBirth != null) {
      dobController.text =
          DateFormat('dd/MM/yyyy').format(_userProfile!.dateOfBirth!);
    } else {
      dobController.text = '';
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- Logic for UI Actions ---

  void onGenderChanged(String? newValue) {
    if (newValue != null && _userProfile != null) {
      _userProfile!.gender = newValue;
      notifyListeners();
    }
  }

  Future<void> pickDate(BuildContext context) async {
    if (_userProfile == null) return;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _userProfile!.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _userProfile!.dateOfBirth = pickedDate;
      dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      notifyListeners();
    }
  }

  Future<void> saveProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null || _userProfile == null) return;

    // Update the model with the latest data from the text fields
    _userProfile!.fullName = nameController.text;
    _userProfile!.email = emailController.text;
    // Gender and Date of Birth are already updated in the model via their own methods.

    try {
      final docRef = _firestore.collection('users').doc(currentUser.uid);
      await docRef.set(_userProfile!.toFirestore(), SetOptions(merge: true));
      Get.snackbar('Success', 'Profile saved successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
