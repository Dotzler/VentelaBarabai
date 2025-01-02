import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/modules/order/views/order_view.dart';
import 'package:flutter_application_1/app/modules/store_page/controllers/store_controller.dart';
import 'package:flutter_application_1/app/modules/wishlist_page/controllers/wishlist_page_controller.dart';
import 'package:get/get.dart';
import '../../cart_page/views/cart_view.dart';
import '../../chat_page/views/chat_view.dart';
import '../../profile_page/views/profile_view.dart';
import '../../wishlist_page/views/wishlist_view.dart';
import '../../product/views/product_view.dart';
import 'package:intl/intl.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final StoreController homeController = Get.put(StoreController());
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        switch (homeController.currentIndex.value) {
          case 1:
            return WishlistPage();
          case 2:
            return CartPage();
          case 3:
            return OrderPage();
          default:
            return _buildHomePage(context);
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: homeController.currentIndex.value,
            onTap: (index) => homeController.changePage(index),
            selectedItemColor: Color(0xFFD3A335),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Wishlist',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Order',
                backgroundColor: Colors.white,
              ),
            ],
          )),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFD3A335),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Ventela Barabai",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 23, 23, 23),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(ChatPage());
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(ProfilePage(), arguments: {});
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4), // Bayangan ke bawah
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  homeController
                      .searchProduct(value); // Panggil fungsi pencarian
                },
                decoration: InputDecoration(
                  hintText: 'Search Your Favorite Sneakers',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[700],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            SizedBox(height: 16),
            _buildBanner(),
            SizedBox(height: 24),
            _buildNewArrivalSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
  final List<String> bannerImages = [
    "assets/backToSchool.png",
    "assets/christmasNewYear.png",
  ];

  return CarouselSlider(
    options: CarouselOptions(
      height: 250.0,
      autoPlay: true,
      enlargeCenterPage: true,
      viewportFraction: 1.0, // Gambar full lebar
      aspectRatio: 16 / 9,
      autoPlayInterval: Duration(seconds: 5),
    ),
    items: bannerImages.map((imagePath) {
      return Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Gambar penuh
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover, // Gambar penuh
                  ),
                ),
              ),
              // Tombol "Shop Now" mengarah ke Store Page
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Store Page
                    Get.offAll(() => StorePage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3A335),
                  ),
                  child: Text(
                    "Shop Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }).toList(),
  );
}



  Widget _buildNewArrivalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Obx(() {
          if (homeController.filteredProducts.isEmpty) {
            return Center(child: Text('No products found.'));
          }
          return Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 16,
              runSpacing: 16,
              children: homeController.filteredProducts.map((product) {
                return _buildProductCard(
                  product.brand,
                  product.name,
                  product.imagePath,
                  product.price,
                );
              }).toList(),
            ),
          );
        }),
      ],
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
        width: 180,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with Gradient Overlay
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.shade50,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Hero(
                      tag: "$brand $name",
                      child: Image.asset(
                        assetPath,
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final isFavorite = wishlistController.isFavorite(name);
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (isFavorite) {
                            wishlistController.removeFromWishlist(name);
                          } else {
                            wishlistController.addToWishlist(name, assetPath, price);
                          }
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Color(0xFFD3A335) : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    Text(
                      brand,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    // Product Name
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // Price with currency formatting
                    Text(
                      NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(price),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD3A335),
                      ),
                    ),
                    Spacer(),
                    // Add to Cart Button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}