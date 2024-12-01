import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SettingsController extends GetxController with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentTrack = ''.obs; // Initially no track is selected
  var isInitialized = false; // Track if audio has been played at least once

  final List<String> audioTracks = ['la-stravaganza.mp3', 'background.mp3', 'ROSÉ_BrunoMars-APT.mp3'];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isPlaying.value = state == PlayerState.playing;
      if (kDebugMode) print('Player state changed: $state');
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playAudio() async {
    if (currentTrack.value.isEmpty) return; // No track selected
    try {
      if (kDebugMode) print('Playing audio: ${currentTrack.value}');

      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Load and start playback
      await _audioPlayer.setSource(AssetSource(currentTrack.value));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();

      // Mark as initialized once playback starts
      isInitialized = true;
      isPlaying.value = true;
    } catch (e) {
      if (kDebugMode) print('Error playing audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      if (isPlaying.value) {
        await _audioPlayer.stop();
        currentTrack.value = ''; // Reset current track to None
        isPlaying.value = false;
        if (kDebugMode) print('Audio stopped');
      }
    } catch (e) {
      if (kDebugMode) print('Error stopping audio: $e');
    }
  }

  Future<void> switchTrack(String newTrack) async {
    if (audioTracks.contains(newTrack)) {
      currentTrack.value = newTrack;
      await playAudio(); // Automatically play the new track
      if (kDebugMode) print('Switched to track: $newTrack');
    }
  }
}