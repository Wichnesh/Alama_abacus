

import 'package:alama_eorder_app/controller/FranchiseWiseOrderController.dart';
import 'package:get/get.dart';

class FWOBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => FWOController());
  }

}