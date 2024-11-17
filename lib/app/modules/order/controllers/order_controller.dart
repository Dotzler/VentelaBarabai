import 'package:get/get.dart';

class OrderController extends GetxController {
  var purchasedItems = <Map<String, dynamic>>[].obs;

  // Fungsi untuk menambahkan barang yang telah dibeli
  void addPurchasedItem(Map<String, dynamic> item) {
    purchasedItems.add(item);
  }

  // Fungsi untuk menambahkan beberapa item sekaligus
  void addPurchasedItems(List<Map<String, dynamic>> items) {
    purchasedItems.addAll(items);
  }

  // Fungsi untuk menghapus item dari bag (opsional)
  void clearBag() {
    purchasedItems.clear();
  }
}
