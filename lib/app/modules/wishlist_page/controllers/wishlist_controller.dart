import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistItem {
  final String name;
  final int price;
  final String imagePath;

  WishlistItem({required this.name, required this.price, required this.imagePath});
}

class WishlistController extends GetxController {
  var wishlist = <WishlistItem>[].obs;

  void addToWishlist(String name, String imagePath, int price) {
    wishlist.add(WishlistItem(name: name, imagePath: imagePath, price: price));
    Get.snackbar(
      "Wishlist",
      "$name telah ditambahkan ke wishlist!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }

  void removeFromWishlist(int index) {
    wishlist.removeAt(index);
  }
}
