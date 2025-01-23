// lib/features/student/screens/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_management/models/issue_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch issues from Firestore
  Future<List<IssueModel>> fetchIssues() async {
    List<IssueModel> issues = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Issues').get();
      for (var doc in querySnapshot.docs) {
        issues.add(IssueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching issues: $e");
    }

    return issues;
  }

  // Method to create a new issue in Firestore
  Future<void> createIssue({
    required String roomNumber,
    required String blockNumber,
    required String issue,
    required String comment,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('Issues').add({
        'roomNumber': roomNumber,
        'blockNumber': blockNumber,
        'issue': issue,
        'studentComment': comment,
        'studentDetails': {
          'emailId': email,
          'phoneNumber': phoneNumber,
        },
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error creating issue: $e");
    }
  }

  // Method to delete an issue from Firestore
  Future<void> deleteIssue(String issueId) async {
    try {
      await _firestore.collection('Issues').doc(issueId).delete();
    } catch (e) {
      print("Error deleting issue: $e");
    }
  }
}
