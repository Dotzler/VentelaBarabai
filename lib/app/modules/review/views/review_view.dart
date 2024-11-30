import 'package:SneakerSpace/app/modules/review/controllers/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReviewView extends StatelessWidget {
  final Map<String, dynamic> item;

  const ReviewView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController()); // Initialize controller

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tulis Ulasan"),
        backgroundColor: const Color(0xFFD3A335),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review header
            Text(
              "Ulasan untuk: ${item['title']}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // TextField for review input
            TextField(
              controller: controller.reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Tulis ulasan Anda di sini...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Add image/video buttons
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Tambah Gambar", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3A335), // Warna latar belakang sesuai preferensi
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                onPressed: () => controller.pickVideo(ImageSource.gallery),
                icon: const Icon(Icons.videocam),
                label: const Text("Tambah Video", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335), // Warna latar belakang sesuai preferensi
                ),
              ),
              ],
            ),
            const SizedBox(height: 10),
            // Media preview (grid view)
            Expanded(
              child: Obx(() {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: controller.mediaList.length,
                  itemBuilder: (context, index) {
                    final media = controller.mediaList[index];
                    if (media['type'] == 'image') {
                      // Image preview
                      return GestureDetector(
                        onTap: () {
                          _showFullScreenImage(context, media['path']!);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(media['path']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (media['type'] == 'video') {
                      // Video preview
                      return GestureDetector(
                        onTap: () {
                          _showFullScreenVideo(context, media['path']!);
                        },
                        child: FutureBuilder(
                          future: controller.videoPlayers[media['path']]?.initialize(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AspectRatio(
                                  aspectRatio: controller.videoPlayers[media['path']]!.value.aspectRatio,
                                  child: VideoPlayer(controller.videoPlayers[media['path']]!),
                                ),
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                );
              }),
            ),
            // Submit review button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.submitReview(
                    context,
                    controller.reviewController,
                    controller.mediaList.map((e) => File(e['path']!)).toList(),
                  );
                },
                icon: const Icon(Icons.send), // Menambahkan ikon untuk tombol Kirim Ulasan
                label: const Text("Kirim Ulasan", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335), // Warna latar belakang sesuai preferensi
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show full-screen image
  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenVideo(BuildContext context, String videoPath) {
    final videoController = VideoPlayerController.file(File(videoPath));
    videoController.initialize();
    videoController.setLooping(false);
    videoController.setVolume(1.0);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black,
              child: FutureBuilder(
                future: videoController.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(videoController.value.position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                _formatDuration(videoController.value.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        VideoProgressIndicator(
                          videoController,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.white,
                            backgroundColor: Colors.black,
                            bufferedColor: Colors.grey,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            setState(() {
                              if (videoController.value.isPlaying) {
                                videoController.pause();
                              } else {
                                videoController.play();
                              }
                            });
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    ).then((_) {
      videoController.dispose();
    });
  }

  /// Format duration into HH:MM:SS or MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
    } else {
      return "${twoDigits(minutes)}:${twoDigits(seconds)}";
    }
  }
}