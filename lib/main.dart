import 'package:VentelaBarabai/app/modules/AdminPage/controllers/admin_page_controller.dart';
import 'package:VentelaBarabai/app/modules/cart_page/controllers/cart_controller.dart';
import 'package:VentelaBarabai/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:VentelaBarabai/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:VentelaBarabai/app/data/services/notification_service.dart';
import 'package:VentelaBarabai/app/data/services/http_controller.dart';
import 'package:VentelaBarabai/app/modules/article_detail/bindings/article_detail_bindings.dart';
import 'package:VentelaBarabai/app/modules/article_detail/views/article_detail_view.dart';
import 'package:VentelaBarabai/app/modules/article_detail/views/article_detail_web_view.dart';
import 'package:VentelaBarabai/app/modules/home/views/home_view.dart';
import 'package:VentelaBarabai/app/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  await Firebase.initializeApp();
  await NotificationService().initNotifications();

  Get.put(AdminPageController());
  Get.put(HttpController());
  Get.put(CartController());
  Get.put(AuthController(), permanent: true);
  
  runApp(MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ventela Barabai',
      home: HomePage(),
      getPages: [
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
              settingsController.stopAudio();
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