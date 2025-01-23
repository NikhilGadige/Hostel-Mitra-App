import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hostel_management/models/gate_pass_model.dart';
import 'package:hostel_management/features/student/screens/firebase_gate_pass.dart';

class StudentGatePass extends StatefulWidget {
  final String studentEmail;

  const StudentGatePass({Key? key, required this.studentEmail}) : super(key: key);

  @override
  _StudentGatePassState createState() => _StudentGatePassState();
}

class _StudentGatePassState extends State<StudentGatePass> {
  final FirebaseService _firebaseService = FirebaseService();
  final DateTime _currentDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gate Pass'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<List<GatePass>>(
        stream: _firebaseService.getPendingGatePasses(widget.studentEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading gate passes.'));
          }

          final gatePasses = snapshot.data ?? [];

          if (gatePasses.isEmpty) {
            return const Center(child: Text('No active gate pass found.'));
          }

          return ListView.builder(
            itemCount: gatePasses.length,
            itemBuilder: (context, index) {
              final gatePass = gatePasses[index];
              final returnDateTime = _parseDateTime(gatePass.dateReturning, gatePass.inTime);

              // Check if the gate pass is expired
              if (_currentDateTime.isAfter(returnDateTime)) {
                _firebaseService.updateGatePassStatus(gatePass.id, 'expired');
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'GATE PASS',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildInfoRow('Name:', gatePass.name),
                      _buildInfoRow('E-Mail:', gatePass.email),
                      _buildInfoRow('Room Number:', gatePass.roomNumber),
                      _buildInfoRow('Block Number:', gatePass.blockNumber),
                      _buildInfoRow('Date of Leaving:', gatePass.dateLeaving),
                      _buildInfoRow('Date of Return:', gatePass.dateReturning),
                      _buildInfoRow('Out Time:', gatePass.outTime),
                      _buildInfoRow('In Time:', gatePass.inTime),
                      const SizedBox(height: 10),
                      const Text(
                        'Reason:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(gatePass.reason),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  DateTime _parseDateTime(String date, String time) {
    try {
      final dateFormat = DateFormat("dd/MM/yyyy HH:mm");
      return dateFormat.parse("$date $time");
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return DateTime.now();
    }
  }
}
