import 'package:flutter/material.dart';
import 'package:SneakerSpace/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  final SettingsController _controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Audio Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD3A335),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNowPlayingSection(),
            _buildTrackListSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingSection() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: Color(0xFFD3A335),
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Now Playing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(() {
              final track = _controller.currentTrack.value;
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFD3A335).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.headphones,
                        color: Color(0xFFD3A335),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.isEmpty ? 'No track selected' : track,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (!track.isEmpty) ...[
                            SizedBox(height: 4),
                            Text(
                              'Playing now',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!track.isEmpty)
                      Obx(() => IconButton(
                            onPressed: _controller.isPlaying.value
                                ? _controller.stopAudio
                                : _controller.playAudio,
                            icon: Icon(
                              _controller.isPlaying.value
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Color(0xFFD3A335),
                              size: 40,
                            ),
                          )),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackListSection() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.queue_music,
                  color: Color(0xFFD3A335),
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Available Tracks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTrackItem(
              'La Stravaganza',
              'Classical',
              'la-stravaganza.mp3',
              Duration(minutes: 3, seconds: 45),
            ),
            SizedBox(height: 16),
            _buildTrackItem(
              'Where We Started',
              'Pop',
              'background.mp3',
              Duration(minutes: 4, seconds: 20),
            ),
            SizedBox(height: 16),
            _buildTrackItem(
              'APT',
              'Bruno Mars',
              'ROSÉ_BrunoMars-APT.mp3',
              Duration(minutes: 3, seconds: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackItem(String title, String artist, String filename, Duration duration) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Obx(() {
        final isCurrentTrack = _controller.currentTrack.value == filename;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => _controller.switchTrack(filename),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCurrentTrack
                          ? Color(0xFFD3A335)
                          : Color(0xFFD3A335).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isCurrentTrack ? Icons.music_note : Icons.play_arrow,
                      color: isCurrentTrack ? Colors.white : Color(0xFFD3A335),
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
                          artist,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (isCurrentTrack) ...[
                    SizedBox(width: 12),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFFD3A335),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}