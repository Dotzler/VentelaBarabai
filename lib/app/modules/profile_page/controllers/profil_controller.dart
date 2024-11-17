import 'package:SneakerSpace/app/auth_controller.dart';
import 'package:SneakerSpace/app/modules/settings/views/settings_view.dart';
import 'package:SneakerSpace/app/storage_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var selectedImagePath = ''.obs;
  var isLoading = false.obs;

  final StorageController _storageController = Get.put(StorageController());
  final AuthController _authController = Get.put(AuthController());

  // Function to navigate to SettingsView
  void navigateToSettings() {
    Get.to(() => SettingsView());
  }

  // Function to select image from gallery
  Future<void> selectImageFromGallery() async {
    try {
      isLoading.value = true;
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );
      
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        await _storageController.uploadProfileImage(pickedFile.path);
        await _authController.fetchUserProfile(); // Refresh profile data
      }
    } catch (error) {
      print('Error selecting image: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to take picture with camera
  Future<void> takePicture() async {
    try {
      isLoading.value = true;
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        await _storageController.uploadProfileImage(pickedFile.path);
        await _authController.fetchUserProfile(); // Refresh profile data
      }
    } catch (error) {
      print('Error taking picture: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to delete profile photo
  Future<void> deletePhoto() async {
    try {
      isLoading.value = true;
      await _storageController.deleteProfileImage();
      selectedImagePath.value = '';
      await _authController.fetchUserProfile(); // Refresh profile data
    } catch (error) {
      print('Error deleting photo: $error');
    } finally {
      isLoading.value = false;
    }
  }
}