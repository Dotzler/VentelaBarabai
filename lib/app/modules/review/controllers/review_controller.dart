import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class ReviewController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();
  final reviewController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var selectedImagePath = ''.obs;
  var isImageLoading = false.obs;
  var selectedVideoPath = ''.obs;
  var isVideoPlaying = false.obs;
  var mediaList = <Map<String, dynamic>>[].obs;
  var isSubmitting = false.obs;
  var uploadProgress = 0.0.obs;

  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void onInit() {
    super.onInit();
    mediaList.clear();
    _clearStoredData();
  }

  @override
  void onClose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    int imageCount = mediaList.where((media) => media['type'] == 'image').length;
    if (imageCount >= 5) {
      Get.snackbar(
        "Warning",
        "Maximum 5 images allowed",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null && File(pickedFile.path).existsSync()) {
        selectedImagePath.value = pickedFile.path;
        mediaList.add({
          'type': 'image',
          'path': pickedFile.path,
          'controller': null,
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<void> pickVideo(ImageSource source) async {
    int videoCount = mediaList.where((media) => media['type'] == 'video').length;
    if (videoCount >= 1) {
      Get.snackbar(
        "Warning",
        "Maximum 1 video allowed",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 1),
      );

      if (pickedFile != null) {
        final videoController = VideoPlayerController.file(File(pickedFile.path));

        try {
          await videoController.initialize();
          _videoControllers[pickedFile.path] = videoController;

          mediaList.add({
            'type': 'video',
            'path': pickedFile.path,
            'controller': videoController,
          });

          selectedVideoPath.value = pickedFile.path;
        } catch (e) {
          videoController.dispose();
          Get.snackbar(
            "Error",
            "Failed to initialize video: $e",
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick video: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<String> _uploadMedia(String filePath, String uid) async {
    try {
      File file = File(filePath);
      String extension = path.extension(filePath).toLowerCase();
      String fileName = 'reviews/${uid}_${DateTime.now().millisecondsSinceEpoch}$extension';

      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: extension == '.mp4' ? 'video/mp4' : 'image/jpeg',
        ),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      await uploadTask;

      uploadProgress.value = 0.0;

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      debugPrint('Error uploading media: $error');
      throw error;
    }
  }

  Future<void> submitReview(BuildContext context, Map<String, dynamic> item) async {
    try {
      final reviewText = reviewController.text.trim();
      if (reviewText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your review')),
        );
        return;
      }

      isSubmitting.value = true;
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        throw 'User not authenticated';
      }

      List<String> mediaUrls = [];
      for (var media in mediaList) {
        String url = await _uploadMedia(media['path'], uid);
        mediaUrls.add(url);
      }

      await _firestore.collection('reviews').add({
        'uid': uid,
        'productName': item['productName'],
        'reviewText': reviewText,
        'mediaUrls': mediaUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _clearAll();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $error')),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void _clearAll() {
    reviewController.clear();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    mediaList.clear();
    selectedImagePath.value = '';
    selectedVideoPath.value = '';
    _clearStoredData();
  }

  void _clearStoredData() {
    box.remove('imagePath');
    box.remove('videoPath');
    selectedImagePath.value = '';
    selectedVideoPath.value = '';
  }

  void removeMedia(int index) {
    final media = mediaList[index];
    if (media['type'] == 'video' && media['controller'] != null) {
      (media['controller'] as VideoPlayerController).dispose();
      _videoControllers.remove(media['path']);
    }
    mediaList.removeAt(index);
  }
}