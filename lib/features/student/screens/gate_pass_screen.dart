import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';

class GatePassFormUI extends StatefulWidget {
  const GatePassFormUI({Key? key}) : super(key: key);

  @override
  _GatePassFormUIState createState() => _GatePassFormUIState();
}

class _GatePassFormUIState extends State<GatePassFormUI> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // New controller for email
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _blockNumberController = TextEditingController();
  final TextEditingController _dateLeavingController = TextEditingController();
  final TextEditingController _dateReturningController = TextEditingController();
  final TextEditingController _outTimeController = TextEditingController();
  final TextEditingController _inTimeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController(); // New controller for reason

  Future<void> _submitData() async {
    try {
      await FirebaseFirestore.instance.collection('gate_passes').add({
        'name': _nameController.text,
        'email': _emailController.text, // Include email in the data
        'room_number': _roomNumberController.text,
        'block_number': _blockNumberController.text,
        'date_leaving': _dateLeavingController.text,
        'date_returning': _dateReturningController.text,
        'out_time': _outTimeController.text,
        'in_time': _inTimeController.text,
        'reason': _reasonController.text, // Include reason in the data
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data submitted successfully!')),
      );

      // Clear the fields after submission
      _nameController.clear();
      _emailController.clear(); // Clear email field
      _roomNumberController.clear();
      _blockNumberController.clear();
      _dateLeavingController.clear();
      _dateReturningController.clear();
      _outTimeController.clear();
      _inTimeController.clear();
      _reasonController.clear(); // Clear reason field
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 138, 86, 1.0),
        title: const Text("Gate Pass Form", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _nameController,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Email', style: AppTextTheme.kLabelStyle), // New label for email
            CustomTextField(
              controller: _emailController,
              inputHint: "Enter email",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Room Number', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _roomNumberController,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Block Number', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _blockNumberController,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Date of Leaving', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _dateLeavingController,
              inputHint: "DD/MM/YYYY",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Date of Return', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _dateReturningController,
              inputHint: "DD/MM/YYYY",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Out Time', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _outTimeController,
              inputHint: "HH:MM",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('In Time', style: AppTextTheme.kLabelStyle),
            CustomTextField(
              controller: _inTimeController,
              inputHint: "HH:MM",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(15),
            Text('Reason for Gate Pass', style: AppTextTheme.kLabelStyle), // New label
            CustomTextField(
              controller: _reasonController,
              inputHint: "Enter reason",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            heightSpacer(40),
            CustomButton(
              buttonText: "Submit",
              press: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
