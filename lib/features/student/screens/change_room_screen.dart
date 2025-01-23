import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.enabledBorder,
    required this.focusedBorder,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        border: OutlineInputBorder(),
      ),
    );
  }
}

// Room Change Request Page
class RoomChangeRequestPage extends StatefulWidget {
  final String appliedRoomNumber;
  final String appliedBlockNumber;

  const RoomChangeRequestPage({
    Key? key,
    required this.appliedRoomNumber,
    required this.appliedBlockNumber,
  }) : super(key: key);

  @override
  _RoomChangeRequestPageState createState() => _RoomChangeRequestPageState();
}

class _RoomChangeRequestPageState extends State<RoomChangeRequestPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentRoomController = TextEditingController();
  final TextEditingController currentBlockController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitRoomChangeRequest() async {
    try {
      await _firestore.collection('RoomChangeRequests').add({
        'username': usernameController.text, // Add username field
        'userEmail': emailController.text, // Add email field
        'currentRoomNumber': currentRoomController.text,
        'currentBlockNumber': currentBlockController.text,
        'reason': reasonController.text,
        'appliedRoomNumber': widget.appliedRoomNumber,
        'appliedBlockNumber': widget.appliedBlockNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room change request submitted successfully.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Change Request', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(46, 138, 86, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          },
        ),
      ),
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('Username', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: usernameController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(46, 138, 86, 1.0)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Email', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: emailController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(46, 138, 86, 1.0)),
                  borderRadius: BorderRadius.circular(14),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              heightSpacer(15),
              Text('Current Room Number', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: currentRoomController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(46, 138, 86, 1.0)),
                  borderRadius: BorderRadius.circular(14),
                ),
                keyboardType: TextInputType.number,
              ),
              heightSpacer(15),
              Text('Current Block Number', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: currentBlockController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(46, 138, 86, 1.0)),
                  borderRadius: BorderRadius.circular(14),
                ),
                keyboardType: TextInputType.text,
              ),
              heightSpacer(15),
              Text('Reason for Room Change', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: reasonController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(46, 138, 86, 1.0)),
                  borderRadius: BorderRadius.circular(14),
                ),
                maxLines: 3,
              ),
              heightSpacer(40),
              CustomButton(
                buttonText: "Submit Request",
                press: submitRoomChangeRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
