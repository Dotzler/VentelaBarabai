import 'dart:io';
import 'package:flutter/material.dart';
import 'package:VentelaBarabai/app/auth_controller.dart';
import 'package:VentelaBarabai/app/modules/edit_profile_page/views/edit_profil_view.dart';
import 'package:VentelaBarabai/app/modules/profile_page/controllers/profil_controller.dart';
import 'package:VentelaBarabai/app/storage_controller.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController _authController = Get.put(AuthController());
  final StorageController storageController = Get.put(StorageController());
  
  ProfilePage() {
    _authController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD3A335),
            ),
          );
        }
        
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true,
              backgroundColor: Color(0xFFD3A335),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFD3A335),
                        Color(0xFFD3A335).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      GestureDetector(
                        onTap: () => _showFullImage(context),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildProfileImage(),
                              if (profileController.isLoading.value)
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _authController.userProfile['username'] ?? '',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _authController.userProfile['name'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildMenuSection(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileImage() {
    if (_authController.userProfile['profileImageUrl'] != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
          _authController.userProfile['profileImageUrl'],
        ),
      );
    } else if (profileController.selectedImagePath.value.isEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.black,
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(
          File(profileController.selectedImagePath.value),
        ),
      );
    }
  }

  Widget _buildMenuSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person,
            title: 'My Account',
            subtitle: 'Edit your information',
            iconColor: Color(0xFFD3A335),
            onTap: () => Get.to(() => EditProfileView()),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.music_note,
            title: 'Music Settings',
            subtitle: 'Change Your Music',
            iconColor: Colors.blue,
            onTap: () => profileController.navigateToSettings(),
          ),
          _buildDivider(),
          SizedBox(height: 270,),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            iconColor: Colors.red,
            onTap: () async => await _authController.logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Colors.grey[200],
    );
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: _authController.userProfile['profileImageUrl'] != null
                      ? Image.network(_authController.userProfile['profileImageUrl'])
                      : profileController.selectedImagePath.value.isEmpty
                          ? Container(
                              height: 300,
                              color: Colors.grey[200],
                              child: Icon(Icons.person, size: 100, color: Colors.grey[400]),
                            )
                          : Image.file(File(profileController.selectedImagePath.value)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Color(0xFFD3A335),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}