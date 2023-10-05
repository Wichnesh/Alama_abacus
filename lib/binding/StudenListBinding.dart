import 'package:get/get.dart';
import '../controller/StudentList_controller.dart';

class StudentListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentListController());
  }
}
