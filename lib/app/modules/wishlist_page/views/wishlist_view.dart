import 'package:SneakerSpace/app/modules/product/views/product_view.dart';
import 'package:SneakerSpace/app/modules/wishlist_page/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistPage extends StatelessWidget {
  final WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD3A335),
        centerTitle: true,
        title: Text(
          "Wishlist",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: Obx(() {
        if (wishlistController.wishlist.isEmpty) {
          return Center(
            child: Text(
              'Wishlist kamu kosong!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: wishlistController.wishlist.length,
          itemBuilder: (context, index) {
            final item = wishlistController.wishlist[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductPage(
                      title: item.name,
                      price: item.price,
                      imagePath: item.imagePath,
                    ));
              },
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.imagePath,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          wishlistController.removeFromWishlist(index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
