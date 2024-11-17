import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3A335),
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() => cartController.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Keranjang Kamu Kosong!",
                style: TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return _buildCartItem(item, index);
                },
              ),
            )),
      bottomNavigationBar: Obx(() {
        return cartController.cartItems.isEmpty
            ? const SizedBox.shrink() // Ini untuk mengembalikan widget kosong jika keranjang kosong
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTotalSection(),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle checkout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD3A335),
                      ),
                      child: const Text(
                        'CHECK OUT',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
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
      child: Row(
        children: [
          // Gambar produk
          Image.asset(
            item['image'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
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
                Text(
                  'Rp ${item['price']}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Size: ${item['size']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // Tombol - (kurang)
          IconButton(
            onPressed: () {
              cartController.decreaseQuantity(index);
            },
            icon: const Icon(Icons.remove),
          ),
          // Jumlah item
          Text('${item['quantity']}'),
          // Tombol + (tambah)
          IconButton(
            onPressed: () {
              cartController.increaseQuantity(index);
            },
            icon: const Icon(Icons.add),
          ),
          // Tombol delete (hapus)
          IconButton(
            onPressed: () {
              cartController.removeItem(index);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    final cartController = Get.find<CartController>();
    double totalPrice = cartController.cartItems.fold(0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Rp ${totalPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
