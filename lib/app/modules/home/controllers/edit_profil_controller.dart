import 'package:flutter_application_1/app/modules/home/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  var isLoading = false.obs;

  EditProfileController() {
    // Initialize with current profile data
    nameController.text = _authController.userProfile['name'] ?? '';
    usernameController.text = _authController.userProfile['username'] ?? '';
    emailController.text = _authController.userProfile['email'] ?? '';
    ageController.text = _authController.userProfile['age']?.toString() ?? '';
  }

  Future<void> updateUserProfile() async {
    isLoading.value = true;

    final name = nameController.text;
    final username = usernameController.text;
    final email = emailController.text;
    final age = int.tryParse(ageController.text) ?? 0;

    // Validate input
    if (name.isEmpty || username.isEmpty || email.isEmpty || age <= 0) {
      Get.snackbar('Error', 'Name, Username, and Email are required. Age must be valid.',
          backgroundColor: Colors.red);
      isLoading.value = false;
      return;
    }

    await _authController.updateUserProfile(name, username, email, age);
    Get.snackbar('Success', 'Profile updated successfully',
        backgroundColor: Colors.green);
    isLoading.value = false;
  }
}
