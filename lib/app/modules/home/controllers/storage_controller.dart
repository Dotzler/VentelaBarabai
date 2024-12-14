import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to upload image to Firebase Storage and update Firestore
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        throw 'User not authenticated';
      }

      // Quietly delete existing profile image if it exists
      await _deleteExistingProfileImage(silent: true);

      File file = File(imagePath);
      String fileName = 'profile_$uid.jpg';
      Reference ref = _storage.ref().child('profile_images').child(fileName);

      // Upload new image
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with new profile image URL
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Profile image uploaded successfully',
        snackPosition: SnackPosition.TOP,
      );

      return imageUrl;
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to upload image: $error',
        snackPosition: SnackPosition.TOP,
      );
      throw error;
    }
  }

  // Function to delete profile image from Firebase Storage and Firestore
  Future<void> deleteProfileImage() async {
    try {
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        throw 'User not authenticated';
      }

      // Get the current user document to check if there's an existing profile image
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? existingImageUrl = userData['profileImageUrl'] as String?;

        if (existingImageUrl != null) {
          // Delete the image from Storage
          try {
            Reference ref = _storage.refFromURL(existingImageUrl);
            await ref.delete();
          } catch (storageError) {
            print('Storage deletion error: $storageError');
            // Continue even if storage deletion fails
          }
        }

        // Update Firestore to remove the profile image URL
        await _firestore.collection('users').doc(uid).update({
          'profileImageUrl': FieldValue.delete(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        Get.snackbar(
          'Success',
          'Profile image deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to delete image: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw error;
    }
  }

  // Private method to delete existing profile image without showing notification
  Future<void> _deleteExistingProfileImage({bool silent = false}) async {
    try {
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) return;

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? existingImageUrl = userData['profileImageUrl'] as String?;

        if (existingImageUrl != null) {
          try {
            Reference ref = _storage.refFromURL(existingImageUrl);
            await ref.delete();
          } catch (storageError) {
            print('Storage deletion error: $storageError');
          }
        }
      }
    } catch (error) {
      print('Error in _deleteExistingProfileImage: $error');
    }
  }
  
  // Function to check if profile image exists
  Future<bool> hasProfileImage() async {
    try {
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) return false;

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) return false;

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return userData['profileImageUrl'] != null;
    } catch (error) {
      print('Error checking profile image: $error');
      return false;
    }
  }
}