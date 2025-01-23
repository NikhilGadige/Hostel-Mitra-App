import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import '../../../models/room_change_model.dart';

class StudentRoomChangeRequestsPage extends StatelessWidget {
  final String userEmail; // Add this to filter requests by user email

  StudentRoomChangeRequestsPage({required this.userEmail});

  Stream<List<RoomChangeRequest>> getRoomChangeRequests() {
    return FirebaseFirestore.instance
        .collection('RoomChangeRequests')
        .where('userEmail', isEqualTo: userEmail) // Filter by user's email
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return RoomChangeRequest.fromMap(data, doc.id);
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Room Change Requests',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF2E8A56),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: StreamBuilder<List<RoomChangeRequest>>(
        stream: getRoomChangeRequests(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data!;
          if (requests.isEmpty) {
            return Center(child: Text('No Room Change Requests Found'));
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username: ${request.username}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Email: ${request.userEmail}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Block: ${request.currentBlockNumber} → ${request.appliedBlockNumber}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Room: ${request.currentRoomNumber} → ${request.appliedRoomNumber}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text('Reason: ${request.reason}', style: TextStyle(color: Colors.grey[700])),
                      Text('Requested on: ${request.timestamp}'),
                      SizedBox(height: 8),
                      Text(
                        'Status: ${request.status ?? 'Pending'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: request.status == 'accepted'
                              ? Colors.green
                              : request.status == 'rejected'
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ),
                      // Display acceptance message if the request is accepted
                      if (request.status == 'accepted' && request.acceptedMessage != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Message: ${request.acceptedMessage}',
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.green[800]),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
