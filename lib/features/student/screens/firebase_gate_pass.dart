import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_management/models/gate_pass_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all pending gate passes for a specific email
  Stream<List<GatePass>> getPendingGatePasses(String email) {
    return _firestore
        .collection('gate_passes')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => GatePass.fromSnapshot(doc)).toList();
    });
  }

  // Method to update the status of a gate pass
  Future<void> updateGatePassStatus(String documentId, String newStatus) async {
    await _firestore.collection('gate_passes').doc(documentId).update({
      'status': newStatus,
    });
  }
}
