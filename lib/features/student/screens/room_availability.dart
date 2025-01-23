import 'package:flutter/material.dart';
import 'package:hostel_management/features/admin/screens/admin_room_av.dart';
import 'package:hostel_management/features/admin/screens/firebase_service_2.dart';
import 'package:hostel_management/features/home/screens/home_screen.dart';
import 'package:hostel_management/models/room_availability_model.dart';
import 'package:hostel_management/features/admin/screens/admin_room_av.dart'; // Import your create room vacancy screen

class RoomAvailabilityPage extends StatefulWidget {
  const RoomAvailabilityPage({Key? key}) : super(key: key);

  @override
  _RoomAvailabilityPageState createState() => _RoomAvailabilityPageState();
}

class _RoomAvailabilityPageState extends State<RoomAvailabilityPage> {
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
      appBar: AppBar(
        title: Text(
          "Room Availability",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFF32855C),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
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
                  side: BorderSide(color: Colors.green, width: 3),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 25),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/bed.png'),
                            ),
                          ),
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
                          Text(
                            "Gender: ${room.genderType}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigoAccent),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () async {
                                  // Call the delete method using the room's document ID
                                  await firebaseService.deleteRoomAvailabilityData(room.id!);
                                  // Refresh the room availability data
                                  setState(() {
                                    roomAvailabilityFuture = firebaseService.fetchRoomAvailabilityData();
                                  });
                                },
                                child: Text(
                                  "Remove",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoomAvailability()), // Navigate to your create room vacancy screen
          );
        },
        child: Icon(Icons.add,color: Colors.white,), // Plus icon
        backgroundColor: Color(0xFF32855C),
      ),
    );
  }
}
