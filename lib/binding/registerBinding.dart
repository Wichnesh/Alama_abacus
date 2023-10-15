import 'package:get/get.dart';

import '../controller/register_controller.dart';

class registerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}