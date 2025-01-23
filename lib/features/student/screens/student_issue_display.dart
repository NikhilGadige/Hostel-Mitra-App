import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_management/features/student/screens/firebase_service.dart';
import 'package:hostel_management/models/issue_model.dart';
import 'package:hostel_management/theme/text_theme_2.dart';
import '../../../theme/colors.dart';

class StudentIssuesDisplayScreen extends StatefulWidget {
  const StudentIssuesDisplayScreen({Key? key}) : super(key: key);

  @override
  _StudentIssuesDisplayScreenState createState() => _StudentIssuesDisplayScreenState();
}

class _StudentIssuesDisplayScreenState extends State<StudentIssuesDisplayScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<IssueModel> _issues = [];
  String? _studentEmail;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserEmail();
  }

  Future<void> _fetchCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _studentEmail = user.email;
      });
      _fetchStudentIssues();
    }
  }

  Future<void> _fetchStudentIssues() async {
    if (_studentEmail != null) {
      List<IssueModel> issues = await _firebaseService.fetchIssues();
      setState(() {
        // Filter issues by the student's email ID
        _issues = issues.where((issue) => issue.studentDetails.emailId == _studentEmail).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Issues",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor:  Color(0xFF4893B5),
      ),
      body: _issues.isEmpty
          ? const Center(
        child: Text("No Issues have been Raised so far",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: _issues.length,
          itemBuilder: (context, index) {
            return StudentIssueCard(
              issue: _issues[index],
            );
          },
        ),
      ),
    );
  }
}

class StudentIssueCard extends StatelessWidget {
  final IssueModel issue;

  const StudentIssueCard({Key? key, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(
          color: Colors.blueGrey,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 30,
                child: Icon(
                  Icons.person,
                  color: Colors.black54,
                  size: 40,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Block Number: ${issue.blockNumber}',
                      style: AppTextTheme.kIssueTitleStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      'Room Number: ${issue.roomNumber}',
                      style: AppTextTheme.kIssueTitleStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      'Email-ID: ${issue.studentDetails.emailId}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: Colors.grey.shade700),
          SizedBox(height: 8),
          Text(
            'Issue: ${issue.issue}',
            textAlign: TextAlign.center,
            style: AppTextTheme.kIssueDescriptionStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Comment: ${issue.studentComment}',
            textAlign: TextAlign.center,
            style: AppTextTheme.kIssueDescriptionStyle.copyWith(fontSize: 15, color: Colors.black87),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
