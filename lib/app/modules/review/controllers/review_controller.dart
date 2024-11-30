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
  final Map<String, VideoPlayerController> videoPlayers = {};

  // Observables
  var selectedImagePath = ''.obs;
  var isImageLoading = false.obs;
  var selectedVideoPath = ''.obs;
  var isVideoPlaying = false.obs;
  var mediaList = <Map<String, String>>[].obs;

  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  @override
  void onClose() {
    for (var controller in videoPlayers.values) {
      controller.dispose();
    }
    videoPlayers.clear();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        box.write('imagePath', pickedFile.path);
        mediaList.add({'type': 'image', 'path': pickedFile.path});
      } else {
        print('No image selected.');
        Get.snackbar("Peringatan", "Tidak ada gambar yang dipilih",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar("Error", "Gagal mengambil gambar: $e",
          snackPosition: SnackPosition.TOP);
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<void> pickVideo(ImageSource source) async {
    if (mediaList.where((media) => media['type'] == 'video').length >= 2) {
    Get.snackbar("Peringatan", "Maksimal 2 video yang dapat dipilih",
        snackPosition: SnackPosition.TOP);
    return;
  }
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        selectedVideoPath.value = pickedFile.path;
        box.write('videoPath', pickedFile.path);
        mediaList.add({'type': 'video', 'path': pickedFile.path});
        _initializeVideoPlayer(pickedFile.path);
      } else {
        print('No video selected.');
        Get.snackbar("Peringatan", "Tidak ada video yang dipilih",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print('Error picking video: $e');
      Get.snackbar("Error", "Gagal mengambil video: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isImageLoading.value = false;
    }
  }

  void _loadStoredData() {
    selectedImagePath.value = box.read('imagePath') ?? '';
    selectedVideoPath.value = box.read('videoPath') ?? '';
    if (selectedVideoPath.value.isNotEmpty) {
      _initializeVideoPlayer(selectedVideoPath.value);
    }
  }

  void _initializeVideoPlayer(String filePath) {
    if (videoPlayers.containsKey(filePath)) {
      videoPlayerController = videoPlayers[filePath];
      return;
    }

  void _initializeVideoPlayerOnDemand(String filePath) {
    if (videoPlayerController != null) {
      videoPlayerController?.dispose();
      videoPlayerController = null;
    }
    videoPlayerController = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        update();
      });
  }
    
    final controller = VideoPlayerController.file(File(filePath));
    videoPlayers[filePath] = controller;

    controller.initialize().then((_) {
      update();
    }).catchError((e) {
      print('Error initializing video player: $e');
      Get.snackbar("Error", "Gagal memutar video: $e",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  void play() {
    videoPlayerController?.play();
    isVideoPlaying.value = true;
    update();
  }

  void pause() {
    videoPlayerController?.pause();
    isVideoPlaying.value = false;
    update();
  }

  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        pause();
      } else {
        play();
      }
    }
  }

  void removeMedia(int index) {
    if (index >= 0 && index < mediaList.length) {
      final media = mediaList[index];
      if (media['type'] == 'video' && videoPlayerController != null && media['path'] == selectedVideoPath.value) {
        videoPlayerController?.dispose();
        videoPlayerController = null;
        selectedVideoPath.value = '';
      }
      mediaList.removeAt(index);
    }
    update();
  }

  void submitReview(BuildContext context, TextEditingController reviewController, List<File> list) {
    final reviewText = reviewController.text.trim();
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi ulasan Anda')),
      );
      return;
    }
    print('Ulasan: $reviewText');
    print('Media yang dipilih: ${mediaList.length}');

    reviewController.clear();
    mediaList.clear();
    selectedImagePath.value = '';
    selectedVideoPath.value = '';
    update();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ulasan berhasil dikirim!')),
    );

    Navigator.pop(context);
  }
}