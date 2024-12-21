import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReviewController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();
  final reviewController = TextEditingController();
  
  // Observables
  var selectedImagePath = ''.obs;
  var isImageLoading = false.obs;
  var selectedVideoPath = ''.obs;
  var isVideoPlaying = false.obs;
  var mediaList = <Map<String, dynamic>>[].obs;
  
  // Simpan VideoPlayerController untuk setiap video
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void onInit() {
    super.onInit();
    mediaList.clear(); // Pastikan mediaList kosong saat inisialisasi
    // Hapus data yang tersimpan sebelumnya
    _clearStoredData();
  }

  @override
  void onClose() {
    // Dispose semua video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    super.onClose();
  }

  void _clearStoredData() {
    box.remove('imagePath');
    box.remove('videoPath');
    selectedImagePath.value = '';
    selectedVideoPath.value = '';
  }

  Future<void> pickImage(ImageSource source) async {
    // Check image limit
    int imageCount = mediaList.where((media) => media['type'] == 'image').length;
    if (imageCount >= 5) {
      Get.snackbar(
        "Peringatan",
        "Maksimal 5 gambar yang dapat dipilih",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && File(pickedFile.path).existsSync()) {
        selectedImagePath.value = pickedFile.path;
        mediaList.add({
          'type': 'image',
          'path': pickedFile.path,
          'controller': null
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<void> pickVideo(ImageSource source) async {
    // Check video limit
    int videoCount = mediaList.where((media) => media['type'] == 'video').length;
    if (videoCount >= 1) {
      Get.snackbar(
        "Peringatan",
        "Maksimal 1 video yang dapat dipilih",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      
      if (pickedFile != null) {
        // Initialize video controller
        final videoController = VideoPlayerController.file(File(pickedFile.path));
        
        try {
          await videoController.initialize();
          _videoControllers[pickedFile.path] = videoController;
          
          mediaList.add({
            'type': 'video',
            'path': pickedFile.path,
            'controller': videoController,
            'thumbnail': null
          });
          
          selectedVideoPath.value = pickedFile.path;
        } catch (e) {
          videoController.dispose();
          Get.snackbar(
            "Error",
            "Gagal menginisialisasi video: $e",
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil video: $e",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isImageLoading.value = false;
    }
  }

  VideoPlayerController? getControllerForPath(String path) {
    return _videoControllers[path];
  }

  void removeMedia(int index) {
    if (index >= 0 && index < mediaList.length) {
      final media = mediaList[index];
      if (media['type'] == 'video') {
        // Dispose video controller
        final controller = _videoControllers[media['path']];
        controller?.dispose();
        _videoControllers.remove(media['path']);
        
        if (media['path'] == selectedVideoPath.value) {
          selectedVideoPath.value = '';
        }
      } else if (media['type'] == 'image' && media['path'] == selectedImagePath.value) {
        selectedImagePath.value = '';
      }
      mediaList.removeAt(index);
    }
    update();
  }

  void togglePlayPause(String videoPath) {
    final controller = _videoControllers[videoPath];
    if (controller != null) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        // Pause other videos first
        for (var otherController in _videoControllers.values) {
          if (otherController != controller && otherController.value.isPlaying) {
            otherController.pause();
          }
        }
        controller.play();
      }
      update();
    }
  }

  void submitReview(BuildContext context) {
    final reviewText = reviewController.text.trim();
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi ulasan Anda')),
      );
      return;
    }

    // Clear everything
    reviewController.clear();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    mediaList.clear();
    selectedImagePath.value = '';
    selectedVideoPath.value = '';
    _clearStoredData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ulasan berhasil dikirim!')),
    );
    
    Navigator.pop(context);
  }
}