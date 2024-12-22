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
  final RxList<WishlistItem> wishlist = <WishlistItem>[].obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get userId => auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  /// Checks if an item is in the wishlist
  bool isFavorite(String name) {
    return wishlist.any((item) => item.name == name);
  }

  /// Add item to wishlist
  Future<void> addToWishlist(String name, String imagePath, int price) async {
    if (userId.isEmpty) return;

    try {
      final collectionRef = firestore
          .collection('wishlists')
          .doc(userId)
          .collection('items');
      
      // Check if item already exists
      final querySnapshot = await collectionRef
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Add new item
        final docRef = await collectionRef.add({
          'name': name,
          'price': price,
          'imagePath': imagePath,
        });

        // Update local wishlist
        wishlist.add(WishlistItem(
          id: docRef.id,
          name: name,
          price: price,
          imagePath: imagePath,
        ));

        Get.snackbar(
          "Wishlist",
          "$name telah ditambahkan ke wishlist!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
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

  /// Remove item from wishlist
  Future<void> removeFromWishlist(String id) async {
    if (userId.isEmpty) return;

    try {
      // Find the item by name in Firestore
      final querySnapshot = await firestore
          .collection('wishlists')
          .doc(userId)
          .collection('items')
          .where('name', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document from Firestore
        await firestore
            .collection('wishlists')
            .doc(userId)
            .collection('items')
            .doc(querySnapshot.docs.first.id)
            .delete();

        // Remove from local wishlist
        wishlist.removeWhere((item) => item.name == id);

        Get.snackbar(
          "Berhasil",
          "Item telah dihapus dari wishlist!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      }
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

  /// Fetch wishlist from Firestore
  Future<void> fetchWishlist() async {
    if (userId.isEmpty) return;

    try {
      final collectionRef = firestore
          .collection('wishlists')
          .doc(userId)
          .collection('items');
      
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