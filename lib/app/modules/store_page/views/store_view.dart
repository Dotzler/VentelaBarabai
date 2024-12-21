import 'package:SneakerSpace/app/modules/brands/views/brands_view.dart';
import 'package:SneakerSpace/app/modules/cart_page/views/cart_view.dart';
import 'package:SneakerSpace/app/modules/chat_page/views/chat_view.dart';
import 'package:SneakerSpace/app/modules/order/views/order_view.dart';
import 'package:SneakerSpace/app/modules/product/views/product_view.dart';
import 'package:SneakerSpace/app/modules/profile_page/views/profile_view.dart';
import 'package:SneakerSpace/app/modules/store_page/controllers/store_controller.dart';
import 'package:SneakerSpace/app/modules/wishlist_page/controllers/wishlist_controller.dart';
import 'package:SneakerSpace/app/modules/wishlist_page/views/wishlist_view.dart';
import 'package:SneakerSpace/app/modules/brand/views/brand_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../http_screen/views/http_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
            return HttpView();
          case 3:
            return CartPage();
          case 4:
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
                icon: Icon(Icons.article),
                label: 'Article',
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
          "Sneaker Space",
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
            _buildBrandSection(),
            SizedBox(height: 24),
            _buildNewArrivalSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    final List<Map<String, dynamic>> bannerItems = [
      {
        'title': 'Air Jordan 1 X Travis Scott',
        'originalPrice': 20000000,
        'discount': 0.20,
        'imagePath': 'assets/Jordan-1-High-OG-Travis-Scott-x-Fragment-1.png'
      },
      {
        'title': 'Nike Air Max 97',
        'originalPrice': 15000000,
        'discount': 0.15,
        'imagePath': 'assets/Nike-Air-Max-97.png'
      },
      {
        'title': 'Adidas Yeezy Boost 350',
        'originalPrice': 1800000,
        'discount': 0.25,
        'imagePath': 'assets/Yeezy-Slides.png'
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 280.0, // Sedikit ditinggikan untuk konten yang lebih nyaman
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.92, // Diperbesar sedikit untuk tampilan yang lebih baik
        aspectRatio: 16 / 9,
        autoPlayInterval: Duration(seconds: 5),
      ),
      items: bannerItems.map((item) {
        final double discountedPrice = item['originalPrice'] * (1 - item['discount']);
        final int discountPercentage = (item['discount'] * 100).round();

        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Badge diskon
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$discountPercentage% OFF',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              // Judul dengan ellipsis
                              Text(
                                item['title'],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              // Harga
                              Text(
                                "Rp ${NumberFormat('#,###').format(item['originalPrice'])}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "Rp ${NumberFormat('#,###').format(discountedPrice)}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              // Tombol dengan efek hover
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => ProductPage(
                                      title: item['title'],
                                      price: discountedPrice.toInt(),
                                      imagePath: item['imagePath'],
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD3A335),
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    "Shop Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0),
                            ),
                            child: Image.asset(
                              item['imagePath'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Brand",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => AllBrandsPage()); // Navigasi ke halaman AllBrandsPage
              },
              child: Text(
                "See all",
                style: TextStyle(fontSize: 16, color: Color(0xFFD3A335)),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBrandCard('Puma', 'assets/puma.png'),
            _buildBrandCard('Nike', 'assets/nike.png'),
            _buildBrandCard('Adidas', 'assets/adidas.png'),
            _buildBrandCard('Reebok', 'assets/reebok.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandCard(String brandName, String assetPath) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BrandProductsPage(brandName: brandName));
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            brandName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandIcon(String assetPath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
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
        height: 380,
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add to cart functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD3A335),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
