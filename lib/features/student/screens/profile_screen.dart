import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String roomNumber;
  final String blockNumber;
  final String username;
  final String emailId;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  const ProfileScreen({
    super.key,
    required this.roomNumber,
    required this.blockNumber,
    required this.username,
    required this.emailId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController roomNumber = TextEditingController();
  TextEditingController block = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  @override
  void dispose() {
    roomNumber.dispose();
    phoneNumber.dispose();
    block.dispose();
    emailId.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kGreenColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Profile",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heightSpacer(20),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
              heightSpacer(10),
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              heightSpacer(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Room No - ${widget.roomNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: const Color(0xFF333333), fontSize: 17.sp),
                      ),
                    ),
                  ),
                  widthSpacer(30),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Block No - ${widget.blockNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: const Color(0xFF333333), fontSize: 17.sp),
                      ),
                    ),
                  ),
                ],
              ),
              heightSpacer(20),
              CustomTextField(
                controller: username,
                inputHint: widget.username,
                prefixIcon: const Icon(Icons.person_2_outlined),
              ),
              heightSpacer(20),
              CustomTextField(
                controller: phoneNumber,
                inputHint: widget.phoneNumber,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              heightSpacer(20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: firstName,
                      inputHint: widget.firstName,
                    ),
                  ),
                  widthSpacer(20),
                  Expanded(
                    child: CustomTextField(
                      controller: lastName,
                      inputHint: widget.lastName,
                    ),
                  ),
                ],
              ),
              heightSpacer(40),

            ],
          ),
        ),
      ),
    );
  }
}
