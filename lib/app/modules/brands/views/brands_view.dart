import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SneakerSpace/app/modules/brand/views/brand_view.dart';

class AllBrandsPage extends StatelessWidget {
  final List<Map<String, String>> brands = [
    {'name': 'Adidas', 'image': 'assets/adidas.png'},
    {'name': 'Nike', 'image': 'assets/nike.png'},
    {'name': 'Puma', 'image': 'assets/puma.png'},
    {'name': 'Reebok', 'image': 'assets/reebok.png'},
    {'name': 'Converse', 'image': 'assets/converse.png'},
    {'name': 'New Balance', 'image': 'assets/new_balance.png'},
    {'name': 'Asics', 'image': 'assets/asics.png'},
    {'name': 'Fila', 'image': 'assets/fila.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('All Brands'),
        backgroundColor: Color(0xFFD3A335),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dua kolom
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 1,
          ),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => BrandProductsPage(brandName: brand['name']!));
              },
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
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
                        brand['image']!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    brand['name']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
