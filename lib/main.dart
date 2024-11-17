import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/services/http_controller.dart';
import 'package:flutter_application_1/app/data/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter_application_1/app/modules/article_detail/bindings/article_detail_bindings.dart';
import 'package:flutter_application_1/app/modules/article_detail/views/article_detail_view.dart';
import 'package:flutter_application_1/app/modules/article_detail/views/article_detail_web_view.dart';
import 'package:flutter_application_1/app/modules/home/views/home_view.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // Pastikan widget sudah diinisialisasi sebelum Firebase dijalankan
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();
  await NotificationService().initNotifications();

  Get.put(HttpController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sneaker Space',
      initialRoute: Routes.HOME,
      getPages: [
        // Halaman utama
        GetPage(
          name: Routes.HOME,
          page: () => HomePage(),
        ),
        // Halaman detail artikel dengan Binding untuk ArticleDetailController
        GetPage(
          name: Routes.ARTICLE_DETAILS,
          page: () => ArticleDetailPage(article: Get.arguments),
          binding: ArticleDetailBinding(), // Inisialisasi controller
        ),
        // Halaman WebView artikel dengan Binding
        GetPage(
          name: Routes.ARTICLE_DETAILS_WEBVIEW,
          page: () => ArticleDetailWebView(article: Get.arguments),
          binding: ArticleDetailBinding(), // Inisialisasi controller
        ),
      ],
    );
  }
}
