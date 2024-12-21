import 'package:SneakerSpace/app/modules/cart_page/controllers/cart_controller.dart';
import 'package:SneakerSpace/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:SneakerSpace/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:SneakerSpace/app/data/services/notification_service.dart';
import 'package:SneakerSpace/app/data/services/http_controller.dart';
import 'package:SneakerSpace/app/modules/article_detail/bindings/article_detail_bindings.dart';
import 'package:SneakerSpace/app/modules/article_detail/views/article_detail_view.dart';
import 'package:SneakerSpace/app/modules/article_detail/views/article_detail_web_view.dart';
import 'package:SneakerSpace/app/modules/home/views/home_view.dart';
import 'package:SneakerSpace/app/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  await Firebase.initializeApp();
  await NotificationService().initNotifications();

  Get.put(HttpController());
  Get.put(CartController());
  AuthController authController = Get.put(AuthController(), permanent: true);
  
  await authController.checkLoginStatus();

  runApp(
    MyApp(
    )
  );
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sneaker Space',
      initialRoute: Routes.HOME,
      getPages: [
        GetPage(
          name: Routes.HOME,
          page: () => WillPopScope(
            onWillPop: () async {
              settingsController.stopAudio();
              return true;
            },
            child: HomePage(),
          ),
        ),
        GetPage(
          name: Routes.ARTICLE_DETAILS,
          page: () => WillPopScope(
            onWillPop: () async {
              settingsController.stopAudio();
              return true;
            },
            child: ArticleDetailPage(article: Get.arguments),
          ),
          binding: ArticleDetailBinding(),
        ),
        GetPage(
          name: Routes.ARTICLE_DETAILS_WEBVIEW,
          page: () => WillPopScope(
            onWillPop: () async {
              settingsController.stopAudio(); // Stop audio when navigating back
              return true;
            },
            child: ArticleDetailWebView(article: Get.arguments),
          ),
          binding: ArticleDetailBinding(),
        ),
      ],
    );
  }
}