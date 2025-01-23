class StaffInfoModel {
  final String userName;
  final String firstName;
  final String lastName;
  final String password;
  final String emailId;
  final String phoneNumber;
  final String jobRole;

  StaffInfoModel({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.emailId,
    required this.phoneNumber,
    required this.jobRole,
  });

  // Factory method to create a `StaffInfoModel` from a Map (e.g., from Firebase data)
  factory StaffInfoModel.fromJson(Map<String, dynamic> json) {
    return StaffInfoModel(
      userName: json['userName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      password: json['password'] ?? '',
      emailId: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      jobRole: json['jobRole'] ?? '',
    );
  }
}
