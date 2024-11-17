import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReviewController extends GetxController {
  // Dependencies
  final ImagePicker _picker = ImagePicker(); // Object untuk ImagePicker
  final box = GetStorage(); // GetStorage untuk menyimpan data
  final reviewController = TextEditingController();

  // Observables
  var selectedImagePath = ''.obs; // Menyimpan path gambar yang dipilih
  var isImageLoading = false.obs; // Status loading untuk gambar
  var selectedVideoPath = ''.obs; // Menyimpan path video yang dipilih
  var isVideoPlaying = false.obs; // Status untuk video play/pause
  var mediaList = <Map<String, String>>[].obs; // Daftar media yang dipilih

  // Video player controller
  VideoPlayerController? videoPlayerController;

  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    _loadStoredData(); // Memuat data yang disimpan
  }

  @override
  void onClose() {
    videoPlayerController?.dispose(); // Membersihkan resource video player
    super.onClose();
  }

  // Methods

  /// Mengambil gambar dari kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        box.write('imagePath', pickedFile.path); // Menyimpan path gambar
        mediaList.add({'type': 'image', 'path': pickedFile.path}); // Tambahkan ke mediaList
      } else {
        print('No image selected.');
        Get.snackbar("Peringatan", "Tidak ada gambar yang dipilih",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar("Error", "Gagal mengambil gambar: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isImageLoading.value = false;
    }
  }

  /// Mengambil video dari kamera atau galeri
  Future<void> pickVideo(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        selectedVideoPath.value = pickedFile.path;
        box.write('videoPath', pickedFile.path); // Menyimpan path video
        mediaList.add({'type': 'video', 'path': pickedFile.path}); // Tambahkan ke mediaList
        // Inisialisasi video player
        _initializeVideoPlayer(pickedFile.path);
      } else {
        print('No video selected.');
        Get.snackbar("Peringatan", "Tidak ada video yang dipilih",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error picking video: $e');
      Get.snackbar("Error", "Gagal mengambil video: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isImageLoading.value = false;
    }
  }

  /// Memuat data gambar dan video yang tersimpan
  void _loadStoredData() {
    selectedImagePath.value = box.read('imagePath') ?? '';
    selectedVideoPath.value = box.read('videoPath') ?? '';
    if (selectedVideoPath.value.isNotEmpty) {
      _initializeVideoPlayer(selectedVideoPath.value);
    }
  }

  /// Inisialisasi video player dengan file path
  void _initializeVideoPlayer(String filePath) {
    videoPlayerController = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        videoPlayerController!.play();
        isVideoPlaying.value = true;
        update(); // Notify UI
      }).catchError((e) {
        print('Error initializing video player: $e');
        Get.snackbar("Error", "Gagal memutar video: $e",
            snackPosition: SnackPosition.BOTTOM);
      });
  }

  /// Memainkan video
  void play() {
    videoPlayerController?.play();
    isVideoPlaying.value = true;
    update(); // Notify UI
  }

  /// Menjeda video
  void pause() {
    videoPlayerController?.pause();
    isVideoPlaying.value = false;
    update(); // Notify UI
  }

  /// Mengubah status play/pause
  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        pause();
      } else {
        play();
      }
    }
  }

  /// Menghapus media dari daftar
  void removeMedia(int index) {
    if (index >= 0 && index < mediaList.length) {
      mediaList.removeAt(index);
    }
    update();
  }

  /// Fungsi untuk memproses ulasan
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

    // Bersihkan form
    reviewController.clear();
    mediaList.clear();
    selectedImagePath.value = '';
    selectedVideoPath.value = '';
    update();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ulasan berhasil dikirim!')),
    );

    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }
}