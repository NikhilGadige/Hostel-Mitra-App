// lib/models/issue_model.dart

class IssueModel {
  final String id;
  final String roomNumber;
  final String blockNumber;
  final String issue;
  final String studentComment;
  final StudentDetails studentDetails;

  IssueModel({
    required this.id,
    required this.roomNumber,
    required this.blockNumber,
    required this.issue,
    required this.studentComment,
    required this.studentDetails,
  });

  factory IssueModel.fromMap(Map<String, dynamic> data, String documentId) {
    return IssueModel(
      id: documentId,
      roomNumber: data['roomNumber'] ?? '',
      blockNumber: data['blockNumber'] ?? '',
      issue: data['issue'] ?? '',
      studentComment: data['studentComment'] ?? '',
      studentDetails: StudentDetails.fromMap(data['studentDetails']),
    );
  }
}

class StudentDetails {
  final String emailId;

  StudentDetails({required this.emailId});

  factory StudentDetails.fromMap(Map<String, dynamic> data) {
    return StudentDetails(
      emailId: data['emailId'] ?? '',
    );
  }
}
