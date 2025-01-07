import 'package:get/get.dart';

class StoreController extends GetxController {
  var currentIndex = 0.obs; // State untuk indeks halaman saat ini
  var allProducts = <Product>[].obs; // Semua produk
  var filteredProducts = <Product>[].obs; // Produk hasil pencarian

  void changePage(int index) {
    currentIndex.value = index; // Mengupdate halaman berdasarkan index
  }

  void searchProduct(String keyword) {
    if (keyword.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      List<String> keywords = keyword.toLowerCase().split(' ');
      filteredProducts.assignAll(
        allProducts.where((product) {
          // Cek apakah semua kata kunci ada di brand atau name
          return keywords.every((kw) =>
              product.name.toLowerCase().contains(kw) ||
              product.brand.toLowerCase().contains(kw));
        }),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    allProducts.assignAll([
      Product(
        brand: 'Ventela',
        name: 'Public High Black',
        imagePath: 'assets/highnatural.png',
        price: 200000,
      ),
      Product(
        brand: 'Ventela',
        name: 'Public Low Black',
        imagePath: 'assets/lownatural.png',
        price: 250000,
      ),
      Product(
        brand: 'Ventela',
        name: 'High Ethnic High Black',
        imagePath: 'assets/ventela-ethnic-highblack-natural-1.png',
        price: 250000,
      ),
      Product(
        brand: 'Ventela',
        name: 'High Reborn Black',
        imagePath: 'assets/ventela-reborn-black.png',
        price: 250000,
      ),
      Product(
        brand: 'Ventela',
        name: 'Public Low Grey',
        imagePath: 'assets/publiclowgrey.png',
        price: 150000,
      ),
      Product(
        brand: 'Ventela',
        name: 'Public Low Cream',
        imagePath: 'assets/publiclowcream.png',
        price: 240000,
      ),
      Product(
        brand: 'Ventela',
        name: 'Evergreen High Black',
        imagePath: 'assets/evergreen.png',
        price: 445000,
      ),
      Product(
        brand: 'Ventela',
        name: 'Back To 70s Black',
        imagePath: 'assets/backTo70s.png',
        price: 310000,
      ),
      Product(
        brand: 'Ventela',
        name: 'Back To 70s White',
        imagePath: 'assets/backTo70swhite.png',
        price: 310000,
      ),
      Product(
        brand: 'Ventela',
        name: 'High Junior Black',
        imagePath: 'assets/juniorblack.png',
        price: 160000,
      ),
    ]);
    filteredProducts.assignAll(allProducts);
  }
}

class Product {
  final String brand;
  final String name;
  final String imagePath;
  final int price;

  Product({
    required this.brand,
    required this.name,
    required this.imagePath,
    required this.price,
  });
}


