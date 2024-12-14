import 'package:get/get.dart';

class StoreController extends GetxController {
  var currentIndex = 0.obs; // State untuk indeks halaman saat ini

  void changePage(int index) {
    currentIndex.value = index; // Mengupdate halaman berdasarkan index
  }
}