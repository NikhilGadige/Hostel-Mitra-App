import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/repository/fees_repository.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';

class AdminHostelScreen extends StatefulWidget {
  const AdminHostelScreen({super.key});

  @override
  _AdminHostelScreenState createState() => _AdminHostelScreenState();
}

class _AdminHostelScreenState extends State<AdminHostelScreen> {
  final TextEditingController roomChargeController = TextEditingController();
  final TextEditingController messChargeController = TextEditingController();
  final TextEditingController electricityBillController = TextEditingController();
  final TextEditingController miscellaneousChargesController = TextEditingController();

  // Initialize FeesRepository
  final FeesRepository feesRepository = FeesRepository();

  Future<void> saveChargesToFirebase() async {
    try {
      // Call the method from FeesRepository to save the charges
      await feesRepository.saveChargeToFirebase(
        roomCharge: roomChargeController.text.trim(),
        messCharge: messChargeController.text.trim(),
        electricityBill: electricityBillController.text.trim(),
        miscellaneousCharges: miscellaneousChargesController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Charges saved successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(10),
        ),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $error"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 138, 86, 1.0),
        title: const Padding(
          padding: EdgeInsets.all(25.0),
          child: Text("Hostel Fee Details",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 28),),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        automaticallyImplyLeading: true,
      ),
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
                  'assets/hostel_fees.png', // replace with appropriate asset
                  width: 350.w,
                  height: 160.h,
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter Charges Details',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              heightSpacer(25),

              Text('Room Charge', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: roomChargeController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Mess Charge', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: messChargeController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Maintainance Charge', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: electricityBillController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(15),
              Text('Miscellaneous Charges', style: AppTextTheme.kLabelStyle),
              CustomTextField(
                controller: miscellaneousChargesController,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              heightSpacer(40),

              CustomButton(
                buttonText: "Save",
                press: () {
                  saveChargesToFirebase();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
