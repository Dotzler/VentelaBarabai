import 'package:get/get.dart';

import '../controllers/connection_controller.dart';

class NetworkBinding extends Bindings { 
  @override 
  void dependencies() { 
    Get.put<NetworkController>(NetworkController(),permanent: true); 
  }  
} 