import 'package:alama_eorder_app/controller/FranchiseWiseStudent_controller.dart';
import 'package:get/get.dart';

class FWSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FranchiseWiseStudentController());
  }
}
