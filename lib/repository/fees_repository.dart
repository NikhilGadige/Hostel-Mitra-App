import 'package:cloud_firestore/cloud_firestore.dart';

class FeesRepository {
  final CollectionReference _feesCollection =
  FirebaseFirestore.instance.collection('Fees');

  Future<void> saveChargeToFirebase({
    required String roomCharge,
    required String messCharge,
    required String electricityBill,
    required String miscellaneousCharges,
  }) async {
    try {
      await _feesCollection.add({
        'roomCharge': roomCharge,
        'messCharge': messCharge,
        'electricityBill': electricityBill,
        'miscellaneousCharges': miscellaneousCharges,
        'timestamp': FieldValue.serverTimestamp(), // for tracking when the record was added
      });
      print("Charges saved successfully");
    } catch (e) {
      print("Error saving charges: $e");
      throw e; // rethrow to handle it in the UI
    }
  }
}
