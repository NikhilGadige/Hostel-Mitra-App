class RoomAvailability {
  String? _id; // Private variable to store document ID
  final String genderType;
  final String roomNumber;
  final String blockNumber;

  RoomAvailability({
    required this.genderType,
    required this.roomNumber,
    required this.blockNumber,
  });

  // Getter for ID
  String? get id => _id;

  // Setter for ID
  set id(String? id) => _id = id;

  // Factory method to create an instance from Firebase document data
  factory RoomAvailability.fromMap(Map<String, dynamic> map, [String? id]) {
    // Use optional 'id' parameter to set document ID when creating the instance
    return RoomAvailability(
      genderType: map['genderType'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      blockNumber: map['blockNumber'] ?? '',
    ).._id = id;
  }

  // Method to convert to a map for storing in Firebase (if needed)
  Map<String, dynamic> toMap() {
    return {
      'genderType': genderType,
      'roomNumber': roomNumber,
      'blockNumber': blockNumber,
    };
  }
}
