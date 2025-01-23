import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_management/common/app_bar.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/features/student/screens/payment.dart';

class HostelFee extends StatefulWidget {
  HostelFee({Key? key}) : super(key: key);

  @override
  _HostelFeeState createState() => _HostelFeeState();
}

class _HostelFeeState extends State<HostelFee> {
  String maintenanceCharge = '';
  String messCharge = '';
  String elecCharge = '';
  String roomCharge = '';
  String totalCharge = '';

  @override
  void initState() {
    super.initState();
    fetchHostelFeeDetails();
  }

  Future<void> fetchHostelFeeDetails() async {
    try {
      // Fetch the latest fee details based on timestamp from Firebase Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Fees')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          maintenanceCharge = data['miscellaneousCharges'] ?? 'N/A';
          messCharge = data['messCharge'] ?? 'N/A';
          elecCharge = data['electricityBill'] ?? 'N/A';
          roomCharge = data['roomCharge'] ?? 'N/A';
          totalCharge = (double.parse(maintenanceCharge) + double.parse(messCharge) + double.parse(elecCharge) + double.parse(roomCharge)).toString();
        });
      }
    } catch (e) {
      print("Error fetching fee details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        'Hostel Fees',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heightSpacer(20),
              Center(
                child: Image.asset(
                  'assets/register_mitra.jpg',
                  height: 250.h,
                ),
              ),
              heightSpacer(0),
              Container(
                width: double.maxFinite,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color(0xFF000000),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0xFFFFFFFF),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpacer(20),
                      Center(
                        child: const Text(
                          'Payment details',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      heightSpacer(20),
                      buildFeeRow('Room charge - ', roomCharge),
                      heightSpacer(20),
                      buildFeeRow('Mess charge - ', messCharge),
                      heightSpacer(20),
                      buildFeeRow('Electricity charge - ', elecCharge),
                      heightSpacer(20),
                      buildFeeRow('Miscellaneous charge - ', maintenanceCharge),
                      heightSpacer(20),
                      const Divider(
                        color: Colors.black,
                      ),
                      heightSpacer(20),
                      buildFeeRow('Total Amount - ', totalCharge),
                      heightSpacer(30),
                    ],
                  ),
                ),
              ),
              heightSpacer(55),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeeRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF464646),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '$value/-',
          style: TextStyle(
            color: const Color(0xFF464646),
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
