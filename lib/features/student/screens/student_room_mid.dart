import 'package:flutter/material.dart';
import 'package:hostel_management/features/admin/screens/firebase_service_2.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/features/student/screens/change_room_screen.dart';
import 'package:hostel_management/models/room_availability_model.dart';

class StudentRoomAvailabilityPage extends StatefulWidget {
  const StudentRoomAvailabilityPage({Key? key}) : super(key: key);

  @override
  _RoomAvailabilityPageState createState() => _RoomAvailabilityPageState();
}

class _RoomAvailabilityPageState extends State<StudentRoomAvailabilityPage> {
  late Future<List<RoomAvailability>> roomAvailabilityFuture;
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    roomAvailabilityFuture = firebaseService.fetchRoomAvailabilityData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Room Availability",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),backgroundColor: Color(0xFF32855C),centerTitle: true,leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        },
      ),
      ),
      body: FutureBuilder<List<RoomAvailability>>(
        future: roomAvailabilityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No room availability data found.'));
          }

          final roomAvailabilityList = snapshot.data!;
          return ListView.builder(
            itemCount: roomAvailabilityList.length,
            itemBuilder: (context, index) {
              final room = roomAvailabilityList[index];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.green,width: 3),

                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,width:100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/bed.png'),
                            )
                        ),
                      ),
                      SizedBox(width: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Room No: ${room.roomNumber}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Block: ${room.blockNumber}"),
                          Text("Gender: ${room.genderType}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigoAccent),),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text("Status:"),
                              SizedBox(width: 6,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomChangeRequestPage(appliedRoomNumber: room.roomNumber, appliedBlockNumber: room.blockNumber)));
                                },

                                child:Text("Available",style: TextStyle(color: Colors.white),),),

                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
