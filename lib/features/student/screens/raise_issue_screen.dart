import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/common/app_bar.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:hostel_management/features/student/screens/firebase_service.dart';

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({Key? key}) : super(key: key);

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController roomNumber = TextEditingController();
  final TextEditingController block = TextEditingController();
  final TextEditingController studentComment = TextEditingController();
  final TextEditingController studentEmailId = TextEditingController();
  final TextEditingController studentContactNumber = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  String? selectedIssue;
  final List<String> issues = [
    'Bathroom',
    'Bedroom',
    'Water',
    'Furniture',
    'Kitchen',
    'Other',
  ];

  @override
  void dispose() {
    roomNumber.dispose();
    block.dispose();
    studentComment.dispose();
    studentEmailId.dispose();
    studentContactNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Create Issue"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpacer(15),
                Text('Room Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Room Number is required';
                    }
                    return null;
                  },
                  controller: roomNumber,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Block Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Block is required';
                    }
                    return null;
                  },
                  controller: block,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Your Email ID', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: studentEmailId,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email ID is required';
                    }
                    return null;
                  },
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Phone Number', style: AppTextTheme.kLabelStyle),
                CustomTextField(
                  controller: studentContactNumber,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone Number is required';
                    }
                    return null;
                  },
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(15),
                Text('Issue you are facing?', style: AppTextTheme.kLabelStyle),
                heightSpacer(15),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedIssue,
                  hint: Text('Select an issue'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIssue = newValue;
                    });
                  },
                  items: issues.map((String issue) {
                    return DropdownMenuItem<String>(
                      value: issue,
                      child: Text(issue),
                    );
                  }).toList(),
                ),
                heightSpacer(15),
                Text('Comment', style: AppTextTheme.kLabelStyle),
                heightSpacer(15),
                CustomTextField(
                  controller: studentComment,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Comment is required';
                    }
                    return null;
                  },
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(40),
                CustomButton(
                  buttonText: "Submit",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      await _firebaseService.createIssue(
                        roomNumber: roomNumber.text,
                        blockNumber: block.text,
                        issue: selectedIssue ?? "",
                        comment: studentComment.text,
                        email: studentEmailId.text,
                        phoneNumber: studentContactNumber.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Issue raised successfully!')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                ),
                heightSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
