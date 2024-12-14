import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/home/controllers/profil_controller.dart';
import 'package:flutter_application_1/app/modules/home/controllers/auth_controller.dart';
import 'package:flutter_application_1/app/modules/home/controllers/storage_controller.dart';
import 'package:flutter_application_1/app/modules/home/views/edit_profil_view.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController _authController = Get.put(AuthController());
  final StorageController storageController = Get.put(StorageController());
  
  ProfilePage() {
    // Fetch user profile data when ProfilePage loads
    _authController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD3A335),
        elevation: 0,
        title: Text('Profile'),
      ),
      body: Obx(() {
        // Show loading indicator for the whole page if profile is loading
        if (profileController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD3A335),
            ),
          );
        }
        
        return Column(
          children: [
            // Profile picture and info section
            Container(
              color: Color(0xFFD3A335),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => _showFullImage(context),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Profile Image
                            _authController.userProfile['profileImageUrl'] != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      _authController.userProfile['profileImageUrl'],
                                    ),
                                  )
                                : profileController.selectedImagePath.value.isEmpty
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.black,
                                        child: Icon(Icons.person, size: 50, color: Colors.white),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(File(profileController.selectedImagePath.value)),
                                      ),
                            
                            // Loading Overlay
                            if (profileController.isLoading.value)
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      _authController.userProfile['username'] ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      _authController.userProfile['name'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 24),

            // My Account section
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Account'),
              subtitle: Text('Edit your information'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Get.to(() => EditProfileView());  // Navigate to EditProfileView
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await _authController.logout();
              },
            ),
          ],
        );
      }),
    );
  }

  // Function to show the full profile image in a dialog
  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: _authController.userProfile['profileImageUrl'] != null
              ? Image.network(_authController.userProfile['profileImageUrl'])
              : profileController.selectedImagePath.value.isEmpty
                  ? Icon(Icons.person, size: 100)
                  : Image.file(File(profileController.selectedImagePath.value)),
        );
      },
    );
  }
}
