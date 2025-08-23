import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String fullName;
  String gender;
  DateTime dateOfBirth;
  String email;
  String? photoUrl;

  UserProfile({
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    this.photoUrl,
  });

  // Factory constructor to create a UserProfile from a Firestore document
  factory UserProfile.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserProfile(
      fullName: data?['fullName'] ?? '',
      gender: data?['gender'] ?? '',
      // Firestore stores dates as Timestamps, so we need to convert them
      dateOfBirth:
          (data?['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime.now(),
      email: data?['email'] ?? '',
      photoUrl: data?['photoUrl'],
    );
  }

  // Method to convert UserProfile data to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "fullName": fullName,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "email": email,
      "photoUrl": photoUrl,
    };
  }
}
