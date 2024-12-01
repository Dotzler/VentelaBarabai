import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var purchasedItems = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Set to track fetched orderIds
  final _fetchedOrderIds = <String>{};

  Future<void> fetchOrdersByUser(String userId) async {
    try {
      // Fetch user data
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        List<dynamic> orderIds = userSnapshot['orderIds'];

        // Fetch detailed orders only if not already fetched
        for (var orderId in orderIds) {
          if (!_fetchedOrderIds.contains(orderId)) {
            DocumentSnapshot orderSnapshot =
                await _firestore.collection('orders').doc(orderId).get();

            if (orderSnapshot.exists) {
              purchasedItems.add(orderSnapshot.data() as Map<String, dynamic>);
              _fetchedOrderIds.add(orderId); // Mark orderId as fetched
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }
}