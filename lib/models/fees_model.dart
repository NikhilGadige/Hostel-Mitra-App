class FeesModel {
  String roomCharge;
  String messCharge;
  String electricityBill;
  String miscellaneousCharges;

  FeesModel({
    required this.roomCharge,
    required this.messCharge,
    required this.electricityBill,
    required this.miscellaneousCharges,
  });

  // Convert FeesModel to a map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'roomCharge': roomCharge,
      'messCharge': messCharge,
      'electricityBill': electricityBill,
      'miscellaneousCharges': miscellaneousCharges,
    };
  }

  // Create a FeesModel from a Firestore map
  factory FeesModel.fromMap(Map<String, dynamic> map) {
    return FeesModel(
      roomCharge: map['roomCharge'] ?? '',
      messCharge: map['messCharge'] ?? '',
      electricityBill: map['electricityBill'] ?? '',
      miscellaneousCharges: map['miscellaneousCharges'] ?? '',
    );
  }
}
