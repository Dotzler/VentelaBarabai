import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:SneakerSpace/app/auth_controller.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final AuthController auth = Get.find();
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults.first);
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
        messageText: const Text(
          'PLEASE CONNECT TO THE INTERNET',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        isDismissible: false,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red[400]!,
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 35),
        margin: EdgeInsets.zero,
      );
      
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      Get.rawSnackbar(
        messageText: const Text(
          'INTERNET CONNECTED',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        isDismissible: true,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[400]!,
        icon: const Icon(Icons.wifi, color: Colors.white, size: 35),
        margin: EdgeInsets.zero,
      );

      try {
        await auth.relogin();
        await auth.reregisterUser();
      } catch (e) {
        print("Relogin atau Sinkronisasi Pendaftaran Gagal: $e");
        Get.snackbar(
          "Error", 
          "Gagal melakukan relogin atau sinkronisasi: ${e.toString()}",
          backgroundColor: Colors.red[400]!,
          colorText: Colors.white,
        );
      }
    }
  }
}