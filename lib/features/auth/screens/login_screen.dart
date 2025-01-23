import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/screens/register_screen.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(child: LoginBody()),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({
    super.key,
  });

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Center(
                  child: Image.asset(
                    'assets/Login_mitra.jpg',
                    height: 250.h,
                  ),
                ),
              ),
              heightSpacer(30.h),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Login to your account',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              heightSpacer(25.h),
              Text('Email', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: email,
                inputHint: "Enter your email",
              ),
              heightSpacer(30),
              Text('Password', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: password,
                inputHint: "Password",
                obscureText: true,
              ),
              heightSpacer(30),
              CustomButton(
                buttonText: "Login",
                press: () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(email:email.text, password: password.text).then((value){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful"),backgroundColor: Colors.green,behavior: SnackBarBehavior.floating,duration:Duration(seconds: 1),margin: EdgeInsets.all(10),));
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen()));
                  }).onError((error,stackTrace){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid UserName or PassWord"),backgroundColor: Colors.red,behavior: SnackBarBehavior.floating,duration:Duration(seconds: 3),margin: EdgeInsets.all(10),));
                  }
                  );
                },
              ),
              heightSpacer(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t have an account?",
                    style: AppTextTheme.kLabelStyle.copyWith(
                      color: AppColors.kGreyDk,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreenUI(),
                        ),
                      );
                    },
                    child: Text(
                      " Register",
                      style: AppTextTheme.kLabelStyle.copyWith(
                        color: AppColors.kGreenColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
