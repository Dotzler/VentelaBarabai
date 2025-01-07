import 'package:get/get.dart';

import '../controllers/admin_page_controller.dart';

class AdminPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPageController>(() => AdminPageController(),
    );
  }
}
