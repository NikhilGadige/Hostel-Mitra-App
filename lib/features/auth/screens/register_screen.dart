import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hostel_management/Authentication/Models/user_model.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/screens/login_screen.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/repository/user_repository.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

import '../../home/screens/home_screen.dart';

class RegisterScreenUI extends StatefulWidget {
  const RegisterScreenUI({super.key});

  @override
  _RegisterScreenUIState createState() => _RegisterScreenUIState();
}

class _RegisterScreenUIState extends State<RegisterScreenUI> {
  final String studentId="2";
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final userRepo = Get.put(UserRepository());

  // State variables for selected block and room number
  String? selectedBlock;
  String? selectedRoom;

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

  final emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-zA-Z]{2,})$',
  );

  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 138, 86, 1.0),
        title: const Padding(
          padding: EdgeInsets.all(25.0),
          child: Text("REGISTER YOURSELF",style: TextStyle(color: Colors.white),),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        automaticallyImplyLeading: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSpacer(40),
              Center(
                child: Image.asset(
                  'assets/register_mitra.jpg',
                  width: 350.w,
                  height: 160.h,
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Register your account',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              heightSpacer(25),

              Text('Username', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: userName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('First Name', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: firstName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Last Name', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: lastName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Email', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: _emailTextController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Password', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: _passwordTextController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Phone Number', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: phoneNumber,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widthSpacer(20),
                          Text(
                            'Block No.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          DropdownButton<String>(
                            hint: Text(''),
                            value: selectedBlock,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBlock = newValue;
                              });
                            },
                            items: ['A', 'B', 'C', 'D'].map((String block) {
                              return DropdownMenuItem<String>(
                                value: block,
                                child: Text(block),
                              );
                            }).toList(),
                          ),
                          widthSpacer(20),
                        ],
                      ),
                    ),
                  ),
                  widthSpacer(20),
                  Expanded(
                    child: Container(
                      height: 50.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF2E8B57)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '    Room No.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 17.sp,
                              ),
                            ),
                            DropdownButton<String>(
                              hint: Text(''),
                              value: selectedRoom,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRoom = newValue;
                                });
                              },
                              items: ['101', '102', '103', '104', '201', '202', '203', '204', '301', '302', '303', '304', '401', '402', '403', '404']
                                  .map((String room) {
                                return DropdownMenuItem<String>(
                                  value: room,
                                  child: Text(room),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              heightSpacer(40),

              CustomButton(
                buttonText: "Register",
                press: () {
                  if (!isValidEmail(_emailTextController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid email format"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        margin: EdgeInsets.all(10),
                      ),
                    );
                    return;
                  }

                  if (selectedBlock == null || selectedRoom == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select Block and Room"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        margin: EdgeInsets.all(10),
                      ),
                    );
                    return;
                  }

                  final user = UserModel(
                    email: _emailTextController.text.trim(),
                    Id: studentId.trim(),
                    phoneNumber: phoneNumber.text.trim(),
                    FirstName: firstName.text.trim(),
                    LastName: lastName.text.trim(),
                    UserName: userName.text.trim(),
                    password: _passwordTextController.text.trim(),
                    blockNumber: selectedBlock!,
                    RoomNumber: selectedRoom!,
                  );

                  createUser(user);
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    print("User Created Successfully");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${error.toString()}"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.all(10),
                    ));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
