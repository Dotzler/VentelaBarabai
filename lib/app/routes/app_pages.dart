import 'package:flutter_application_1/app/modules/home/views/cart_view.dart';
import 'package:flutter_application_1/app/modules/home/views/chat_view.dart';
import 'package:flutter_application_1/app/modules/home/views/login_view.dart';
import 'package:flutter_application_1/app/modules/home/views/profile_view.dart';
import 'package:flutter_application_1/app/modules/home/views/signup_view.dart';
import 'package:flutter_application_1/app/modules/home/views/store_view.dart';
import 'package:flutter_application_1/app/modules/home/views/wishlist_view.dart';
import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/cart_binding.dart'; // Tambahkan import CartBinding
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpPage(),
    ),
    GetPage(
      name: _Paths.STORE,
      page: () => StorePage(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartPage(),
      binding: CartBinding(), // Tambahkan binding di sini
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatPage(),
    ),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => WishlistPage(wishlist: const [],),
    ),
  ];
}
