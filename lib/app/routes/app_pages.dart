import 'package:get/get.dart';

import '../modules/AdminPage/bindings/admin_page_binding.dart';
import '../modules/AdminPage/views/admin_page_view.dart';
import '../modules/article_detail/bindings/article_detail_bindings.dart';
import '../modules/article_detail/views/article_detail_view.dart';
import '../modules/article_detail/views/article_detail_web_view.dart';
import '../modules/cart_page/views/cart_view.dart';
import '../modules/chat_page/views/chat_view.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/connection/views/connection_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/http_screen/bindings/http_binding.dart';
import '../modules/http_screen/views/http_view.dart';
import '../modules/login_page/views/login_view.dart';
import '../modules/microphone/views/microphone_view.dart';
import '../modules/order/views/order_view.dart';
import '../modules/profile_page/views/profile_view.dart';
import '../modules/reviewPage/bindings/review_page_binding.dart';
import '../modules/reviewPage/views/review_page_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/signup_page/views/signup_view.dart';
import '../modules/store_page/views/store_view.dart';
import '../modules/wishlist_page/views/wishlist_view.dart';

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
    // Add more routes here
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
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatPage(),
    ),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => WishlistPage(),
    ),
    GetPage(
      name: _Paths.HTTP,
      page: () => const HttpView(),
      binding: HttpBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_DETAILS,
      page: () => ArticleDetailPage(article: Get.arguments),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_DETAILS_WEBVIEW,
      page: () => ArticleDetailWebView(article: Get.arguments),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: _Paths.MICROPHONE,
      page: () => MicrophonePage(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderPage(),
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => const ConnectionView(),
      binding: NetworkBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_PAGE,
      page: () => const ReviewPageView(),
      binding: ReviewPageBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PAGE,
      page: () => AdminPage(),
      binding: AdminPageBinding(),
    ),
  ];
}
