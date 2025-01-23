// import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_management/UserProfileFetcher.dart';
import 'package:hostel_management/features/admin/screens/admin_room_av.dart';
import 'package:hostel_management/features/admin/screens/create_staff.dart';
import 'package:hostel_management/features/admin/screens/issue_details_screen.dart';
import 'package:hostel_management/features/admin/screens/room_change_requests_screen.dart';
import 'package:hostel_management/features/admin/screens/staff_display_screen.dart';
import 'package:hostel_management/features/admin/screens/student_staff_display_screen.dart';
import 'package:hostel_management/features/student/screens/admin_host_fee.dart';
import 'package:hostel_management/features/student/screens/admin_hostel_fees.dart';
import 'package:hostel_management/features/student/screens/gate_pass_display.dart';
import 'package:hostel_management/features/student/screens/gate_pass_screen.dart';
import 'package:hostel_management/features/student/screens/hostel_fees.dart';
import 'package:hostel_management/features/student/screens/raise_issue_screen.dart';
import 'package:hostel_management/features/student/screens/room_availability.dart';
import 'package:hostel_management/features/student/screens/student_issue_display.dart';
import 'package:hostel_management/features/student/screens/student_room_change_req.dart';
import 'package:hostel_management/features/student/screens/student_room_mid.dart';
import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:hostel_management/common/constants.dart';
import 'package:hostel_management/common/spacing.dart';
import 'package:hostel_management/widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  DocumentSnapshot? userDocument;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Fetch user data based on the email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .where("Email", isEqualTo: currentUser!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            userDocument = querySnapshot.docs.first;
          });
        } else {
          print("No user data found for Email: ${currentUser!.email}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User profile data not found.")),
          );
        }
      } else {
        print("No authenticated user found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in.")),
        );
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: AppTextTheme.kLabelStyle.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: AppColors.kGreenColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const UserProfileFetcher(),
                  ),
                );
              },
              child: SvgPicture.asset(
                AppConstants.profile,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          child: Column(
            children: [
              heightSpacer(20),
              userDocument == null
                  ? const SizedBox()
                  : Container(
                height: 140.h,
                width: double.maxFinite,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFDFDFD),
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
                      color: Color(0xFFFFFFFF),
                      blurRadius: 8,
                      offset: Offset(2, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: Text(
                              '${userDocument!['FirstName']} ${userDocument!['LastName']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF333333),
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          heightSpacer(15),
                          Text(
                            "Room No. : ${userDocument!['RoomNumber']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            'Block No. :  ${userDocument!['BlockNumber']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 15.sp,
                            ),
                          )
                        ],
                      ),
                      if (userDocument != null && userDocument!['Id'] == "1")
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color(0xFF2E8A56),
                                  child: Icon(
                                    Icons.credit_card,
                                    color: const Color(0xFFFFFFFF),
                                    size: 50.sp,
                                  ),
                                ),
                                onPressed: () {

                                },
                              ),
                              Text("Gate Pass Requests"),

                            ],
                          ),
                        )else
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                              const RaiseIssueScreen(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(AppConstants.createIssue),
                            Text(
                              'Create issues',
                              style: TextStyle(
                                color: const Color(0xFF153434),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              heightSpacer(30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFABD2BE),
                ),
                width: double.maxFinite,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Center(
                        child: Text(
                          'Categories',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    heightSpacer(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if(userDocument!=null && userDocument!['Id']=='1')
                        CategoryCard(
                          category: 'Room\nAvailability',
                          image: AppConstants.roomAvailability,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                const RoomAvailabilityPage(),
                              ),
                            );
                          },
                        )else
                          CategoryCard(
                            category: 'Room\nAvailability',
                            image: AppConstants.roomAvailability,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                  StudentRoomAvailabilityPage(),
                                ),
                              );
                            },
                          ),
                        if(userDocument!=null && userDocument!['Id']=='1')
                        CategoryCard(
                          category: 'All\nIssues',
                          image: AppConstants.allIssues,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => IssuesDisplayScreen(),
                              ),
                            );
                          },
                        )else
                          CategoryCard(
                            category: 'All\nIssues',
                            image: AppConstants.allIssues,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => StudentIssuesDisplayScreen(),
                                ),
                              );
                            },
                          ),
                        if(userDocument!=null && userDocument!['Id']=='1')
                        CategoryCard(
                          category: 'Staff\nMembers',
                          image: AppConstants.staffMember,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const StaffInfoScreen(),
                              ),
                            );
                          },
                        )else
                          CategoryCard(
                            category: 'Staff\nMembers',
                            image: AppConstants.staffMember,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const StudentStaffDisplayScreenStaffInfoScreen(),
                                ),
                              );
                            },
                          )
                      ],
                    ),
                    heightSpacer(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(userDocument!=null && userDocument!['Id']=='1')
                        CategoryCard(
                          category: 'Create\nStaff',
                          image: AppConstants.createStaff,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const CreateStaff(),
                              ),
                            );
                          },
                        )else
                        CategoryCard(
                          category: 'Gate\nPass',
                          image: AppConstants.gatePass,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Select an option to access'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GatePassFormUI()));
                                        print("Request Gate Pass selected");
                                      },
                                      child: Center(child: const Text('Request Gate Pass',style: TextStyle(color: Color.fromRGBO(46, 138, 86, 1.0)),)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentGatePass(studentEmail: currentUser!.email.toString())));
                                      },
                                      child: Center(child: const Text('View Gate Pass/Status of Gate Pass',style: TextStyle(color: Color.fromRGBO(46, 138, 86, 1.0)),)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        if(userDocument!=null && userDocument!['Id']=='1')
                        CategoryCard(
                          category: 'Hostel\nFee',
                          image: AppConstants.hostelFee,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AdHostelFee(),
                              ),
                            );
                          },
                        )else
                          CategoryCard(
                            category: 'Hostel\nFee',
                            image: AppConstants.hostelFee,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HostelFee(),
                                ),
                              );
                            },
                          ),
                        if(userDocument!=null && userDocument!['Id']=='1')
                        CategoryCard(
                          category: 'Change\nRequests',
                          image: AppConstants.roomChange,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                RoomChangeRequestsPage(),
                              ),
                            );
                          },
                        )else
                          CategoryCard(
                            category: 'Change\nRequests',
                            image: AppConstants.roomChange,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      StudentRoomChangeRequestsPage(userEmail: currentUser!.email.toString(),),
                                ),
                              );
                            },
                          ),
                      ],
                    ),

                    heightSpacer(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}