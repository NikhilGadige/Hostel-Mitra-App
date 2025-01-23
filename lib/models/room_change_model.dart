import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChangeRequest {
  final String docId;
  final String username;
  final String userEmail;
  final String currentBlockNumber;
  final String appliedBlockNumber;
  final String currentRoomNumber;
  final String appliedRoomNumber;
  final String reason;
  final String? status;
  final String? acceptedMessage;
  final Timestamp timestamp; // Keep as Timestamp

  RoomChangeRequest({
    required this.docId,
    required this.username,
    required this.userEmail,
    required this.currentBlockNumber,
    required this.appliedBlockNumber,
    required this.currentRoomNumber,
    required this.appliedRoomNumber,
    required this.reason,
    this.status,
    this.acceptedMessage,
    required this.timestamp,
  });

  // Convert Firestore data to RoomChangeRequest instance
  factory RoomChangeRequest.fromMap(Map<String, dynamic> data, String docId) {
    return RoomChangeRequest(
      docId: docId,
      username: data['username'],
      userEmail: data['userEmail'],
      currentBlockNumber: data['currentBlockNumber'],
      appliedBlockNumber: data['appliedBlockNumber'],
      currentRoomNumber: data['currentRoomNumber'],
      appliedRoomNumber: data['appliedRoomNumber'],
      reason: data['reason'],
      status: data['status'],
      acceptedMessage: data['acceptedMessage'],
      timestamp: data['timestamp'], // Keep this as Timestamp
    );
  }

  // Method to get formatted timestamp as String
  String getFormattedTimestamp() {
    return "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} ${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}";
  }
}
