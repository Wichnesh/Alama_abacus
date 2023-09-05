import '../controller/Student_controller.dart';
import 'package:get/get.dart';

class enrollstudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentController());
  }
}
