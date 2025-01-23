import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_management/common/app_bar.dart';
import 'package:hostel_management/common/constants.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/models/staff_info_model.dart';
import 'package:hostel_management/features/admin/screens/firebase_service.dart';

class StudentStaffDisplayScreenStaffInfoScreen extends StatefulWidget {
  const StudentStaffDisplayScreenStaffInfoScreen({super.key});

  @override
  State<StudentStaffDisplayScreenStaffInfoScreen> createState() => _StaffInfoScreenState();
}

class _StaffInfoScreenState extends State<StudentStaffDisplayScreenStaffInfoScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<StaffInfoModel> staffList = [];

  Future<void> fetchAllStaff() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Staff')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        staffList = snapshot.docs.map((doc) {
          return StaffInfoModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error fetching staff data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'All Staff'),
      body: staffList.isEmpty
          ? const Center(
        child: Text(
          "No Staff is Registered yet.",
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2 / 1.2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Color(0xFF007B3B)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x4C007B3B),
                    blurRadius: 8,
                    offset: Offset(1, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              AppConstants.person,
                              width: 90.w,
                              height: 90.h,
                            ),
                            heightSpacer(20),
                            Text(
                              '${staff.jobRole}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        widthSpacer(10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              heightSpacer(10.0),
                              Text(
                                'Name: ${staff.firstName}',
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 14.sp,
                                ),
                              ),
                              heightSpacer(8.0),
                              Text(
                                'Email: ${staff.emailId}',
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 14.sp,
                                ),
                              ),
                              heightSpacer(8.0),
                              Text('Contact: ${staff.phoneNumber}'),
                              heightSpacer(8.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
