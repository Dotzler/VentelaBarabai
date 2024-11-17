import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicrophoneController extends GetxController {
  var speech = stt.SpeechToText();
  var isListening = false.obs;
  var text = ''.obs; // Menyimpan hasil suara menjadi teks

  @override
  void onInit() {
    super.onInit();
    initializeSpeech();
  }

  void initializeSpeech() async {
    bool available = await speech.initialize();
    if (!available) {
      // Informasikan jika perangkat tidak mendukung Speech-to-Text
      text.value = 'Speech recognition is not available.';
    }
  }

  void startListening() async {
    if (speech.isAvailable && !isListening.value) {
      isListening.value = true;
      speech.listen(onResult: (result) {
        text.value = result.recognizedWords;
      });
    } else {
      text.value = 'Speech recognition is not initialized or available.';
    }
  }

  void stopListening() {
    if (isListening.value) {
      speech.stop();
      isListening.value = false;
    }
  }

  @override
  void onClose() {
    speech.stop();
    super.onClose();
  }
}