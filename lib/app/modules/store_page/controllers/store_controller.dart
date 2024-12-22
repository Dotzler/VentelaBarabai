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
      Product(
        brand: 'Adidas',
        name: 'Superstar Core Brown',
        imagePath: 'assets/SUPER_STAR_SHOES.png',
        price: 2500000,
      ),
      Product(
        brand: 'Adidas',
        name: 'Forum Low Cs',
        imagePath: 'assets/FORUM_LOW_CS_SHOES.png',
        price: 1800000,
      ),
      Product(
        brand: 'Adidas',
        name: 'Campus Vulc',
        imagePath: 'assets/campus_vulc_shoes.png',
        price: 1300000,
      ),
      Product(
        brand: 'Nike',
        name: 'Air Jordan Legacy 312 Low',
        imagePath: 'assets/AIR+JORDAN+LEGACY+312+LOW.png',
        price: 2800000,
      ),
      Product(
        brand: 'Nike',
        name: 'Air Jordan 1 Low Red',
        imagePath: 'assets/AIR+JORDAN+1+LOW.png',
        price: 1800000,
      ),
      Product(
        brand: 'Nike',
        name: 'Air Jordan 1 Mid White',
        imagePath: 'assets/AIR+JORDAN+1+MID.png',
        price: 2000000,
      ),
      Product(
        brand: 'Nike',
        name: 'Air Jordan 4 Retro',
        imagePath: 'assets/AIR+JORDAN+4+RETRO.png',
        price: 3400000,
      ),
      Product(
        brand: 'Puma',
        name: 'One Piece Red Haired Shanks',
        imagePath: 'assets/Sepatu-Sneaker-Suede-Unisex-Red-Haired-Shanks-PUMA-x-ONE-PIECE.png',
        price: 1600000,
      ),
      Product(
        brand: 'Puma',
        name: 'One Piece Buggy the Genius Jester',
        imagePath: 'assets/Sepatu-Sneaker-Suede-Unisex-Buggy-the-Genius-Jester-PUMA-x-ONE-PIECE.png',
        price: 1600000,
      ),
      Product(
        brand: 'Puma',
        name: 'One Piece Blackbeard Teech',
        imagePath: 'assets/Sepatu-Sneaker-Suede-Unisex-Blackbeard-Teech-PUMA-x-ONE-PIECE.png',
        price: 1600000,
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


