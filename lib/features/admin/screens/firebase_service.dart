import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add staff data to Firestore
  Future<void> addStaffData({
    required String userName,
    required String firstName,
    required String lastName,
    required String password,
    required String email,
    required String phoneNumber,
    required String jobRole,
  }) async {
    try {
      // Add a new document with generated ID
      await _firestore.collection('Staff').add({
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'email': email,
        'phoneNumber': phoneNumber,
        'jobRole': jobRole,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("Staff added successfully");
    } catch (e) {
      print('Failed to add staff: $e');
    }
  }

  // Function to delete staff data from Firestore by email
  Future<void> deleteStaffData(String email) async {
    try {
      // Query to find the document with the specified email
      QuerySnapshot snapshot = await _firestore
          .collection('Staff')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Loop through and delete each document that matches the query
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        print("Staff deleted successfully");
      } else {
        print("No staff found with this email.");
      }
    } catch (e) {
      print('Failed to delete staff: $e');
    }
  }
}
