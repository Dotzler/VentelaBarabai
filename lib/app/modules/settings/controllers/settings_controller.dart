import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SettingsController extends GetxController with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentTrack = ''.obs;

  // List of available audio files
  final List<String> audioTracks = ['la-stravaganza.mp3', 'background.mp3', 'ROSÉ_BrunoMars-APT.mp3'];

  @override
  void onInit() {
    super.onInit();
    // Set the initial track
    currentTrack.value = audioTracks[2];
    _playAudio();

    // Register the observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Pause audio when the app goes to background or becomes inactive
      pauseAudio();
    } else if (state == AppLifecycleState.resumed) {
      // Resume audio when the app returns to the foreground
      resumeAudio();
    }
  }

  Future<void> _playAudio() async {
    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Make sure the audio path matches your asset location
      String audioPath = currentTrack.value;

      // Set volume and loop mode
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      // Set source and play
      await _audioPlayer.setSource(AssetSource(audioPath));
      await _audioPlayer.resume();

      isPlaying.value = true;

      if (kDebugMode) {
        print('Audio started playing: $audioPath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing audio: $e');
      }
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      isPlaying.value = false;
      if (kDebugMode) {
        print('Audio paused');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error pausing audio: $e');
      }
    }
  }

  Future<void> resumeAudio() async {
    try {
      await _audioPlayer.resume();
      isPlaying.value = true;
      if (kDebugMode) {
        print('Audio resumed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resuming audio: $e');
      }
    }
  }

  Future<void> switchTrack(String newTrack) async {
    if (audioTracks.contains(newTrack) && currentTrack.value != newTrack) {
      currentTrack.value = newTrack;
      await _playAudio();
      if (kDebugMode) {
        print('Switched to track: $newTrack');
      }
    }
  }
}