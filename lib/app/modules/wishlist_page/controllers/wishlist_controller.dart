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

  /// Menambahkan item ke wishlist
  void addToWishlist(String name, String imagePath, int price) {
    if (!isFavorite(name)) {
      wishlist.add(WishlistItem(name: name, imagePath: imagePath, price: price));
      Get.snackbar(
        "Wishlist",
        "$name telah ditambahkan ke wishlist!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  /// Menghapus item dari wishlist
  void removeFromWishlist(String name) {
    wishlist.removeWhere((item) => item.name == name);
    Get.snackbar(
      "Wishlist",
      "$name telah dihapus dari wishlist!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }

  /// Mengecek apakah item sudah ada di wishlist
  bool isFavorite(String name) {
    return wishlist.any((item) => item.name == name);
  }
}
