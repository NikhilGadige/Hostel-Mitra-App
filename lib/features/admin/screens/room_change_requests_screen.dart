import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/room_change_model.dart';

class RoomChangeRequestsPage extends StatelessWidget {
  Stream<List<RoomChangeRequest>> getRoomChangeRequests() {
    return FirebaseFirestore.instance
        .collection('RoomChangeRequests')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return RoomChangeRequest.fromMap(data, doc.id);
    }).toList());
  }

  // Update the request document after accepting
  Future<void> acceptRequest(String docId, String appliedRoomNumber, String appliedBlockNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('RoomChangeRequests')
          .doc(docId)
          .update({
        'status': 'accepted',
        'acceptedMessage': 'Your request to room $appliedRoomNumber in block $appliedBlockNumber has been accepted.',
      });
      print("Request accepted: $docId");
    } catch (e) {
      print("Error accepting request: $e");
    }
  }

  // Delete the request document after rejecting
  Future<void> rejectRequest(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('RoomChangeRequests')
          .doc(docId)
          .delete(); // Delete the document
      print("Request rejected: $docId");
    } catch (e) {
      print("Error rejecting request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room Change Requests',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2E8A56),
      ),
      body: StreamBuilder<List<RoomChangeRequest>>(
        stream: getRoomChangeRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No room change requests found.'));
          }

          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                color: Color(0xFFFBF7C6),
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
                      Text('Requested on: ${request.getFormattedTimestamp()}'), // Ensure you have this method to format timestamp
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
                      if (request.acceptedMessage != null) ...[
                        SizedBox(height: 16),
                        Text(
                          request.acceptedMessage!,
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              acceptRequest(request.docId, request.appliedRoomNumber, request.appliedBlockNumber).then((_) {
                                // Optionally show a confirmation message
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Accepted')));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Accept', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              rejectRequest(request.docId).then((_) {
                                // Optionally show a confirmation message
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Rejected')));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Reject', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
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
