import 'package:cloud_firestore/cloud_firestore.dart';

class GatePass {
  final String id;
  final String blockNumber;
  final String dateLeaving;
  final String dateReturning;
  final String email;
  final String inTime;
  final String name;
  final String outTime;
  final String reason;
  final String roomNumber;

  GatePass({
    required this.id,
    required this.blockNumber,
    required this.dateLeaving,
    required this.dateReturning,
    required this.email,
    required this.inTime,
    required this.name,
    required this.outTime,
    required this.reason,
    required this.roomNumber,
  });

  // Factory to create a GatePass from a Firebase document snapshot
  factory GatePass.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return GatePass(
      id: snapshot.id,
      blockNumber: data['block_number'] ?? '',
      dateLeaving: data['date_leaving'] ?? '',
      dateReturning: data['date_returning'] ?? '',
      email: data['email'] ?? '',
      inTime: data['in_time'] ?? '',
      name: data['name'] ?? '',
      outTime: data['out_time'] ?? '',
      reason: data['reason'] ?? '',
      roomNumber: data['room_number'] ?? '',
    );
  }
}
