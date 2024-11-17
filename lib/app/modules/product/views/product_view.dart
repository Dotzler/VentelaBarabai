import 'package:SneakerSpace/app/modules/cart_page/controllers/cart_controller.dart';
import 'package:SneakerSpace/app/modules/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  final String title;
  final int price;
  final String imagePath;

  ProductPage({required this.title, required this.price, required this.imagePath});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int? selectedSize;
  final CartController cartController = Get.put(CartController());
  final OrderController bagController = Get.put(OrderController()); // Inisialisasi BagController
  List<Map<String, dynamic>> reviews = [];

  void _addReview(Map<String, dynamic> review) {
    setState(() {
      reviews.add(review);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD3A335),
        title: Text(
          "Product Detail",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                widget.imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                "Rp ${widget.price}",
                style: TextStyle(fontSize: 20, color: Colors.grey[800]),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Size :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: List.generate(8, (index) {
                int size = 37 + index;
                return ChoiceChip(
                  label: Text(size.toString()),
                  selected: selectedSize == size,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(
                    color: selectedSize == size ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedSize = selected ? size : null;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            Text(
              "Deskripsi Produk",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.black),
            SizedBox(height: 16),
            Text(
              "Ini adalah deskripsi dari produk ${widget.title}.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedSize != null) {
                      _showConfirmationDialog();
                    } else {
                      Get.snackbar(
                        "Pilih Ukuran",
                        "Silakan pilih ukuran terlebih dahulu",
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3A335),
                  ),
                  child: Text("Buy Now"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedSize != null) {
                      cartController.addToCart({
                        'title': widget.title,
                        'price': widget.price,
                        'size': selectedSize,
                        'image': widget.imagePath,
                        'quantity': 1,
                      });
                      Get.snackbar(
                        "Berhasil",
                        "Produk telah ditambahkan ke keranjang",
                        snackPosition: SnackPosition.TOP,
                      );
                    } else {
                      Get.snackbar(
                        "Pilih Ukuran",
                        "Silakan pilih ukuran terlebih dahulu",
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3A335),
                  ),
                  child: Text("Add to Cart"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

    void _showConfirmationDialog() {
    Get.defaultDialog(
      title: "",
      content: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Color(0xFFD3A335),
          ),
          const SizedBox(height: 16),
          Text(
            "Konfirmasi Pembelian",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Apakah Anda yakin ingin membeli barang ini?",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      radius: 12.0,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Tidak",
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD3A335),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                bagController.addPurchasedItem({
                  'title': widget.title,
                  'price': widget.price,
                  'size': selectedSize,
                  'image': widget.imagePath,
                  'quantity': 1,
                });
                Get.back();
                Get.snackbar(
                  "Berhasil",
                  "Produk telah ditambahkan ke daftar pembelian",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green.shade300,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  duration: const Duration(seconds: 3),
                );
              },
              child: const Text(
                "Ya",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
