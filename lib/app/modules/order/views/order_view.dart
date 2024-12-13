import 'package:SneakerSpace/app/modules/review/views/review_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'package:SneakerSpace/app/auth_controller.dart';

class OrderPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final String? userId = authController.currentUser?.uid;

    if (userId != null) {
      orderController.fetchOrdersByUser(userId);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'User is not logged in.',
            backgroundColor: Colors.red, colorText: Colors.white);
        Get.offAllNamed('/login');
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3A335),
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Obx(() => orderController.purchasedItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No orders yet!",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: orderController.purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = orderController.purchasedItems[index];
                  return _buildOrderItemCard(item, context);
                },
              ),
            )),
    );
  }

  Widget _buildOrderItemCard(Map<String, dynamic> item, BuildContext context) {
  return Card(
    elevation: 4,
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['productName'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Rp ${item['productPrice']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD3A335),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Colors.grey),

          // Order Details
          _buildDetailRow(Icons.rule, "Size", item['productSize'].toString()),
          _buildDetailRow(Icons.payment, "Payment Method", item['paymentMethod']),
          _buildDetailRow(Icons.location_on, "Delivered to", item['address'] ?? "Address not available"),
          _buildDetailRow(Icons.phone, "Phone Number", item['phoneNumber']),

          // Optional Message
          if (item['message'] != null && item['message'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Icon(Icons.message, color: Colors.grey[600], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['message'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Tambahkan tombol di bawah komentar atau pesan
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => ReviewView(item: item));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3A335), // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tambah Ulasan',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD3A335), size: 20),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}