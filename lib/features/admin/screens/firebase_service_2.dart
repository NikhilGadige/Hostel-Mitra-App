import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_management/models/room_availability_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add room availability data to Firebase
  Future<void> addRoomAvailabilityData({
    required String genderType,
    required String roomNumber,
    required String blockNumber,
  }) async {
    try {
      await _firestore.collection('RoomAvailability').add({
        'genderType': genderType,
        'roomNumber': roomNumber,
        'blockNumber': blockNumber,
        'timestamp': FieldValue.serverTimestamp(), // Optional: For sorting
      });
    } catch (e) {
      throw Exception('Error adding room availability data: ${e.toString()}');
    }
  }

  // Method to fetch room availability data from Firebase
  Future<List<RoomAvailability>> fetchRoomAvailabilityData() async {
    try {
      final snapshot = await _firestore.collection('RoomAvailability').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Include the document ID in the RoomAvailability model
        return RoomAvailability.fromMap(data)..id = doc.id;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching room availability data: ${e.toString()}');
    }
  }

  // Method to delete room availability data from Firebase using document ID
  Future<void> deleteRoomAvailabilityData(String documentId) async {
    try {
      await _firestore.collection('RoomAvailability').doc(documentId).delete();
    } catch (e) {
      throw Exception('Error deleting room availability data: ${e.toString()}');
    }
  }

  // Method to add a room change request to Firebase
  Future<void> addRoomChangeRequest({
    required String appliedRoomNumber,
    required String appliedBlockNumber,
    required String currentRoomNumber,
    required String currentBlockNumber,
    required String reasonForChange,
  }) async {
    try {
      await _firestore.collection('RoomChangeRequests').add({
        'appliedRoomNumber': appliedRoomNumber,
        'appliedBlockNumber': appliedBlockNumber,
        'currentRoomNumber': currentRoomNumber,
        'currentBlockNumber': currentBlockNumber,
        'reasonForChange': reasonForChange,
        'timestamp': FieldValue.serverTimestamp(), // Optional: For sorting
      });
    } catch (e) {
      throw Exception('Error adding room change request: ${e.toString()}');
    }
  }

  // Optional: Method to listen for real-time updates on room availability data
  Stream<List<RoomAvailability>> streamRoomAvailabilityData() {
    return _firestore.collection('RoomAvailability').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return RoomAvailability.fromMap(data)..id = doc.id;
      }).toList();
    });
  }
}
