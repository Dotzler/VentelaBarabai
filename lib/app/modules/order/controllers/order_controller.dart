import 'package:get/get.dart';

class OrderController extends GetxController {
  var purchasedItems = <Map<String, dynamic>>[].obs;

  void addPurchasedItem(Map<String, dynamic> item) {
    purchasedItems.add(item);
  }

  void addPurchasedItems(List<Map<String, dynamic>> items) {
    purchasedItems.addAll(items);
  }

  void clearBag() {
    purchasedItems.clear();
  }
}
