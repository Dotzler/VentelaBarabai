import 'package:SneakerSpace/app/modules/review/views/review_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class OrderPage extends StatelessWidget {
  final OrderController bagController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3A335),
        centerTitle: true,
        title: const Text(
          "Order",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() => bagController.purchasedItems.isEmpty
          ? const Center(
              child: Text(
                "Belum ada barang yang dibeli!",
                style: TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: bagController.purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = bagController.purchasedItems[index];
                  return _buildBagItem(item, context);
                },
              ),
            )),
    );
  }

  Widget _buildBagItem(Map<String, dynamic> item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Gambar produk
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Detail produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Rp ${item['price']}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Size: ${item['size']}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // Jumlah item
              Text(
                'x${item['quantity']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.to(() => ReviewView(item: item));
            },
            child: const Text("Tulis Ulasan"),
          ),
        ],
      ),
    );
  }
}
