import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/services/notification_service.dart';
import 'package:flutter_application_1/app/modules/home/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/app/modules/home/views/home_view.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService().initNotifications();
  Get.lazyPut<CartController>(() => CartController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
