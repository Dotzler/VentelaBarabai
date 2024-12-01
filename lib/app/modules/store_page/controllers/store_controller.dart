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
      filteredProducts.assignAll(
        allProducts.where((product) =>
            product.name.toLowerCase().contains(keyword.toLowerCase())),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    allProducts.assignAll([
      Product(
        brand: 'Nike',
        name: 'Air Force 1 X Peaceminusone',
        imagePath: 'assets/af1peaceminusone.png',
        price: 6700000,
      ),
      Product(
        brand: 'Adidas',
        name: 'NMD R1 Cream',
        imagePath: 'assets/nmdr1.png',
        price: 2800000,
      ),
      Product(
        brand: 'Nike',
        name: 'Air Jordan 1 Zoom CMFT 2',
        imagePath: 'assets/ajhigh.png',
        price: 3200000,
      ),
      Product(
        brand: 'Nike',
        name: 'Air Jordan 1 Low Travis Scoot',
        imagePath: 'assets/ajlow.png',
        price: 10300000,
      ),
      Product(
        brand: 'New Balance',
        name: '530',
        imagePath: 'assets/nb530.png',
        price: 1800000,
      ),
      Product(
        brand: 'Reebok',
        name: 'Classic',
        imagePath: 'assets/rbcls.png',
        price: 1200000,
      ),
      Product(
        brand: 'Adidas',
        name: 'Samba OG Cloud White Black',
        imagePath: 'assets/SambaOG.png',
        price: 2500000,
      ),
      Product(
        brand: 'Adidas',
        name: 'Superstar Core Black White',
        imagePath: 'assets/superstar.png',
        price: 2100000,
      ),
    ]);
    filteredProducts.assignAll(allProducts); // Default semua produk ditampilkan
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


