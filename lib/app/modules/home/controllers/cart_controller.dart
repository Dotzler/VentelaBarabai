import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  // Menambah item ke keranjang
  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
  }

  // Mengurangi kuantitas
  void decreaseQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity']--;
      cartItems.refresh();
    }
  }

  // Menambah kuantitas
  void increaseQuantity(int index) {
    cartItems[index]['quantity']++;
    cartItems.refresh();
  }

  // Menghapus item dari keranjang
  void removeItem(int index) {
    cartItems.removeAt(index);
  }
}
