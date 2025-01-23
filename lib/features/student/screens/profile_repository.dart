import 'package:get/get.dart';
import 'package:hostel_management/repository/user_repository.dart';
import 'package:hostel_management/Authentication/Models/user_model.dart';

class ProfileRepository extends GetxController {
  static ProfileRepository get instance => Get.find();
  final _userRepo = Get.put(UserRepository());

  // Method to fetch user data by email
  Future<UserModel?> getUserData(String email) async {
    try {
      UserModel? user = await _userRepo.getUserDetails(email);
      return user; // Return user data, could be null if not found
    } catch (e) {
      // Handle any errors that may occur
      print("Error fetching user data: $e");
      return null; // Return null in case of an error
    }
  }

  // Method to update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _userRepo.updateUserDetails(user);
    } catch (e) {
      // Handle any errors that may occur during update
      print("Error updating user profile: $e");
    }
  }
}
