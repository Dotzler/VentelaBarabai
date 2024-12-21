import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistItem {
  final String id;
  final String name;
  final int price;
  final String imagePath;

  WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  factory WishlistItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WishlistItem(
      id: doc.id,
      name: data['name'],
      price: data['price'],
      imagePath: data['imagePath'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }
}

class WishlistController extends GetxController {
  final wishlist = <WishlistItem>[].obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get userId => auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  /// Checks if an item is already in the wishlist
  bool isFavorite(String name) {
    return wishlist.any((item) => item.name == name);
  }

  /// Menambahkan item ke wishlist
  Future<void> addToWishlist(String name, String imagePath, int price) async {
    if (userId.isEmpty) return;

    try {
      final collectionRef =
          firestore.collection('wishlists').doc(userId).collection('items');
      final querySnapshot =
          await collectionRef.where('name', isEqualTo: name).get();

      if (querySnapshot.docs.isEmpty) {
        await collectionRef.add({
          'name': name,
          'price': price,
          'imagePath': imagePath,
        });

        Get.snackbar(
          "Wishlist",
          "$name telah ditambahkan ke wishlist!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );

        fetchWishlist();
      } else {
        Get.snackbar(
          "Wishlist",
          "$name sudah ada di wishlist!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menambahkan ke wishlist: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Menghapus item dari wishlist
  Future<void> removeFromWishlist(String id) async {
    if (userId.isEmpty) return;

    try {
      await firestore
          .collection('wishlists')
          .doc(userId)
          .collection('items')
          .doc(id)
          .delete();
      Get.snackbar(
        "Berhasil",
        "Item telah dihapus dari wishlist!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      fetchWishlist();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghapus dari wishlist: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Mengambil data wishlist dari Firestore
  Future<void> fetchWishlist() async {
    if (userId.isEmpty) return;

    try {
      final collectionRef =
          firestore.collection('wishlists').doc(userId).collection('items');
      final querySnapshot = await collectionRef.get();
      wishlist.value = querySnapshot.docs
          .map((doc) => WishlistItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat wishlist: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}