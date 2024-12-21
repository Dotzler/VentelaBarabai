import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add item to Firestore and local state
  Future<void> addToCart(Map<String, dynamic> item) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      // Add item to Firestore
      final docRef = await _firestore
          .collection('carts')
          .doc(uid)
          .collection('items')
          .add(item);

      // Add item to local state (optional, for instant UI update)
      cartItems.add({
        ...item,
        'id': docRef.id, // Add document ID for local tracking
      });

      Get.snackbar(
        "Success",
        "Item added to cart",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add item to cart: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Fetch items from Firestore for the current user
  Future<void> fetchCartItems() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      final querySnapshot = await _firestore
          .collection('carts')
          .doc(uid)
          .collection('items')
          .get();

      // Update local state
      cartItems.value = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch cart items: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Remove item from Firestore and local state
  Future<void> removeItem(String docId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      // Remove item from Firestore
      await _firestore
          .collection('carts')
          .doc(uid)
          .collection('items')
          .doc(docId)
          .delete();

      // Remove item from local state
      cartItems.removeWhere((item) => item['id'] == docId);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to remove item: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }
}