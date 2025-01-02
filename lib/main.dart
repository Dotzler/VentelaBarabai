import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/auth_controller.dart';
import 'package:flutter_application_1/app/data/services/notification_service.dart';
import 'package:flutter_application_1/app/modules/cart_page/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/app/modules/home/views/home_view.dart';
import 'package:flutter_application_1/app/modules/admin_page/controllers/admin_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  Get.put(AdminController());
  await NotificationService().initNotifications();
  Get.put(CartController());
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ventela Barabai',
      initialRoute: Routes.HOME,
      getPages: [
        GetPage(
          name: Routes.HOME,
          page: () => HomePage(),
        ),
      ],
    );
  }
}
