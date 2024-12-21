import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:SneakerSpace/app/database_controller.dart';
import 'package:SneakerSpace/app/auth_controller.dart';

class BuyPageController extends GetxController {
  final AuthController _authController = Get.put(AuthController());

  RxString shippingType = "Normal".obs;
  RxString phoneNumber = "".obs;
  RxString postalCode = "".obs;
  RxString message = "".obs;
  RxString paymentMethod = "Cash".obs;
  RxString paymentNumber = "".obs;

  Rx<Position?> userPosition = Rx<Position?>(null);
  RxString address = "Address not available".obs;

  Future <void> confirmPurchase({
    required String title,
    required int price,
    required int size,
    required String shippingType,
    required String phoneNumber,
    required String postalCode,
    required String message,
  }) async {
    if (phoneNumber.isEmpty || postalCode.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all required fields.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return;
    }

    if (userPosition.value == null ||
        address.value == "Address not available") {
      Get.snackbar(
        "Error",
        "Location and address not available. Please allow location access.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return;
    }

    try {
      String uid = _authController.currentUser?.uid ?? "";

      DatabaseService dbService = DatabaseService(uid: uid);

      String orderId = await dbService.addOrder(
        productName: title,
        productPrice: price,
        productSize: size,
        shippingType: shippingType,
        paymentMethod: paymentMethod.value,
        paymentNumber:
            paymentNumber.value.isNotEmpty ? paymentNumber.value : null,
        phoneNumber: phoneNumber,
        postalCode: postalCode,
        message: message.isNotEmpty ? message : null,
        address: address.value, // Pass the resolved address
      );

      Get.snackbar(
        "Success",
        "Order placed successfully! Order ID: $orderId",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to place the order. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Error",
          "Location services are disabled.",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Error",
            "Location permission denied.",
            snackPosition: SnackPosition.TOP,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Error",
          "Location permissions are permanently denied.",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      userPosition.value = position;

      await getAddressFromLongLat(position);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> getAddressFromLongLat(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      address.value =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      address.value = "Failed to fetch address: $e";
    }
  }

  Future<void> openGoogleMaps() async {
    if (userPosition.value != null) {
      final latitude = userPosition.value!.latitude;
      final longitude = userPosition.value!.longitude;
      final googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        Get.snackbar(
          "Error",
          "Could not open Google Maps.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Location not available. Please try again.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}