// lib/features/issue/screens/issues_display_screen.dart

import 'package:flutter/material.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/features/student/screens/firebase_service.dart';
import 'package:hostel_management/models/issue_model.dart';
import 'package:hostel_management/theme/text_theme_2.dart';
import '../../../theme/colors.dart';

class IssuesDisplayScreen extends StatefulWidget {
  @override
  _IssuesDisplayScreenState createState() => _IssuesDisplayScreenState();
}

class _IssuesDisplayScreenState extends State<IssuesDisplayScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<IssueModel> _issues = [];

  @override
  void initState() {
    super.initState();
    _fetchIssues();
  }

  Future<void> _fetchIssues() async {
    List<IssueModel> issues = await _firebaseService.fetchIssues();
    setState(() {
      _issues = issues;
    });
  }

  Future<void> _resolveIssue(String issueId) async {
    await _firebaseService.deleteIssue(issueId);
    _fetchIssues(); // Refresh the list after resolving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon:Icon( Icons.arrow_back_ios_new,color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          },
        ),
        title: Text(
          "Pending Issues",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,fontSize: 28),

        ),
        backgroundColor: Color(0xFF4893B5),
      ),
      body: _issues.isEmpty
          ? Center(
        child: Text(
          "No Issues to be resolved",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: _issues.length,
          itemBuilder: (context, index) {
            return IssueCard(
              issue: _issues[index],
              onResolve: () => _resolveIssue(_issues[index].id),
            );
          },
        ),
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final IssueModel issue;
  final VoidCallback onResolve;

  const IssueCard({Key? key, required this.issue, required this.onResolve}) : super(key: key);

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
          color: Colors.blueGrey, // Border color
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
                      'Block Number: ${issue.roomNumber}',
                      style: AppTextTheme.kIssueTitleStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      'Room Number: ${issue.blockNumber}',
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
          Center(
            child: ElevatedButton(
              onPressed: onResolve,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'RESOLVE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
