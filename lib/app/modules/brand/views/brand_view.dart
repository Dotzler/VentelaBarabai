import 'package:SneakerSpace/app/modules/product/views/product_view.dart';
import 'package:SneakerSpace/app/modules/store_page/controllers/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SneakerSpace/app/modules/wishlist_page/controllers/wishlist_controller.dart';

class BrandProductsPage extends StatelessWidget {
  final String brandName;
  final StoreController storeController = Get.find();
  final WishlistController wishlistController = Get.put(WishlistController());

  BrandProductsPage({required this.brandName});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = storeController.allProducts
        .where((product) => product.brand.toLowerCase() == brandName.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(brandName),
        backgroundColor: const Color(0xFFD3A335),
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Text(
                "No products available for $brandName",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:0.60,  
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(
                    product.brand,
                    product.name,
                    product.imagePath,
                    product.price,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildProductCard(String brand, String name, String assetPath, int price) {
    return GestureDetector(
      onTap: () {
        Get.to(
          ProductPage(
            title: "$brand $name",
            price: price,
            imagePath: assetPath,
          ),
          transition: Transition.zoom,
        );
      },
      child: Container(
        width: 160,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: "$brand $name",
                child: Image.asset(
                  assetPath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                brand, // Nama brand
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                name, // Nama produk
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Rp $price", // Harga
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  wishlistController.addToWishlist(name, assetPath, price);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Text(
                  "Add to Wishlist",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
