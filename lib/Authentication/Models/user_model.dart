import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String Id;
  final String UserName;
  final String FirstName;
  final String LastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String blockNumber;
  final String RoomNumber;

  const UserModel({
    required this.Id,
    required this.email,
    required this.phoneNumber,
    required this.FirstName,
    required this.LastName,
    required this.UserName,
    required this.password,
    required this.blockNumber,
    required this.RoomNumber,
});

  toJson(){
    return{
      "Id":Id,
      "Username":UserName,
      "FirstName":FirstName,
      "LastName":LastName,
      "Email":email,
      "Password":password,
      "PhoneNumber":phoneNumber,
      "BlockNumber":blockNumber,
      "RoomNumber":RoomNumber
    };
  }
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data=document.data()!;
    return UserModel(

        email: data["Email"],
        Id: data["Id"],
        phoneNumber: data["PhoneNumber"],
        FirstName: data["FirstName"],
        LastName: data["LastName"],
        UserName: data["Username"],
        password: data["Password"],
        blockNumber: data["BlockNumber"],
        RoomNumber: data["RoomNumber"]
    );
  }
}

