import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/common/app_bar.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/auth/widgets/custom_button.dart';
import 'package:hostel_management/features/auth/widgets/custom_text_field.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'firebase_service_2.dart';

class CreateRoomAvailability extends StatefulWidget {
  const CreateRoomAvailability({super.key});

  @override
  State<CreateRoomAvailability> createState() => _CreateRoomAvailabilityState();
}

class _CreateRoomAvailabilityState extends State<CreateRoomAvailability> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedGender;
  TextEditingController roomNumber = TextEditingController();
  TextEditingController blockNumber = TextEditingController();

  FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    roomNumber.dispose();
    blockNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context, "Create Room Availability"),
      backgroundColor: AppColors.kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gender Type', style: AppTextTheme.kLabelStyle),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: ['Male', 'Female'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Gender Type is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
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
                      return 'Block Number is required';
                    }
                    return null;
                  },
                  controller: blockNumber,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD1D8FF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                heightSpacer(40),
                CustomButton(
                  buttonText: "Create Room Availability",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await firebaseService.addRoomAvailabilityData(
                          genderType: selectedGender!,
                          roomNumber: roomNumber.text.trim(),
                          blockNumber: blockNumber.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Room availability added successfully!')),
                        );
                        // Clear fields after submission
                        setState(() {
                          selectedGender = null;
                        });
                        roomNumber.clear();
                        blockNumber.clear();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add room availability: $e')),
                        );
                      }
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
