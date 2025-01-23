import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FetchFromFirebase extends StatefulWidget {
  const FetchFromFirebase({super.key});

  @override
  State<FetchFromFirebase> createState() => _FetchFromFirebaseState();
}

class _FetchFromFirebaseState extends State<FetchFromFirebase> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  DocumentSnapshot? userDocument;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Fetch the user profile based on UID
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.uid)
            .get();

        if (documentSnapshot.exists) {
          setState(() {
            userDocument = documentSnapshot;
          });
        } else {
          print("No user data found for UID: ${currentUser!.uid}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User profile data not found.")),
          );
        }
      } else {
        print("No authenticated user found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in.")),
        );
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text(
            "Your Profile",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      body: userDocument != null
          ? Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetail("First Name", userDocument!['FirstName']),
                _buildProfileDetail("Last Name", userDocument!['LastName']),
                _buildProfileDetail("Email", userDocument!['Email']),
                _buildProfileDetail("Username", userDocument!['Username']),
                _buildProfileDetail("Phone Number", userDocument!['PhoneNumber']),
                _buildProfileDetail("Block Number", userDocument!['BlockNumber']),
                _buildProfileDetail("Room Number", userDocument!['RoomNumber']),
              ],
            ),
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
