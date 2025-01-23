import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_management/features/student/screens/profile_screen.dart';

class UserProfileFetcher extends StatefulWidget {
  const UserProfileFetcher({super.key});

  @override
  State<UserProfileFetcher> createState() => _UserProfileFetcherState();
}

class _UserProfileFetcherState extends State<UserProfileFetcher> {
  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('User is not logged in'),
      );
    }

    String userEmail = currentUser.email ?? '';

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: userEmail) // Query by email
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print('Error fetching data: ${snapshot.error}');
          return const Center(child: Text('Error fetching data'));
        }
        if (snapshot.hasData) {
          print('Current User Email: $userEmail');
          print('Documents Found: ${snapshot.data!.docs.length}');

          // Assuming there should only be one document per email, access the first document
          if (snapshot.data!.docs.isNotEmpty) {
            var userData = snapshot.data!.docs.first.data() as Map<String, dynamic>?;

            if (userData != null) {
              return ProfileScreen(
                roomNumber: userData['RoomNumber'] ?? 'N/A',
                blockNumber: userData['BlockNumber'] ?? 'N/A',
                username: userData['Username'] ?? 'N/A',
                emailId: userData['Email'] ?? 'N/A',
                phoneNumber: userData['PhoneNumber'] ?? 'N/A',
                firstName: userData['FirstName'] ?? 'N/A',
                lastName: userData['LastName'] ?? 'N/A',
              );
            }
          }
        }

        // If no user data is found, display this message
        return const Center(child: Text('No user data found'));
      },
    );
  }
}
