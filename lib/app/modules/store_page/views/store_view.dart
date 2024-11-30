import 'package:SneakerSpace/app/modules/cart_page/views/cart_view.dart';
import 'package:SneakerSpace/app/modules/chat_page/views/chat_view.dart';
import 'package:SneakerSpace/app/modules/order/views/order_view.dart';
import 'package:SneakerSpace/app/modules/product/views/product_view.dart';
import 'package:SneakerSpace/app/modules/profile_page/views/profile_view.dart';
import 'package:SneakerSpace/app/modules/store_page/controllers/store_controller.dart';
import 'package:SneakerSpace/app/modules/wishlist_page/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../http_screen/views/http_view.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final StoreController homeController = Get.put(StoreController());
  List<WishlistItem> wishlist = [];

  void _addToWishlist(String name, String imagePath) {
    setState(() {
      wishlist.add(WishlistItem(name: name, imagePath: imagePath));
      Get.snackbar(
        "Wishlist", 
        "$name telah ditambahkan ke wishlist!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 2),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (homeController.currentIndex.value) {
            case 1:
              return WishlistPage(wishlist: wishlist);
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
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Order'),
              ],
            )),
      ),
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
              Get.to(ProfilePage(), arguments: {
                });
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
            TextField(
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            _buildBanner(),
            SizedBox(height: 24),
            _buildBrandSection(),
            SizedBox(height: 24),
            _buildNewArrivalSection(),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(HttpView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335),
                ),
                child: Text('Visit Article'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Air Jordan 1 X Travis Scott",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "DISCOUNT 20%",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3A335),
                  ),
                  child: Text(
                    "Shop Now",
                    style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Image.asset(
            'assets/Jordan-1-High-OG-Travis-Scott-x-Fragment-1.png',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Brand",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text("See all"),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBrandIcon('assets/puma.png'),
            _buildBrandIcon('assets/nike.png'),
            _buildBrandIcon('assets/adidas.png'),
            _buildBrandIcon('assets/reebok.png'),
          ],
        ),
      ],
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
          "New Arrival",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildProductCard('Nike Air Force 1', 'assets/air-force-1-low-x-peaceminusone.jpg', 6700000, 4.7),
            _buildProductCard('Adidas NMD', 'assets/adidas-nmd-r1.jpg', 2800000, 4.9),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(String title, String assetPath, int price, double rating) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductPage(title: title, price: price, imagePath: assetPath));
      },
      child: Container(
        width: 150,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              assetPath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "\IDR $price",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Text(
                  "$rating/5",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _addToWishlist(title, assetPath);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD3A335),
              ),
              child: Text(
                "Add to Wishlist",
                style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}