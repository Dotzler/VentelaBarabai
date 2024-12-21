import 'package:SneakerSpace/app/modules/connection/bindings/connection_binding.dart';

class DependencyInjection {
  static void init() {
    NetworkBinding().dependencies();
  }
}