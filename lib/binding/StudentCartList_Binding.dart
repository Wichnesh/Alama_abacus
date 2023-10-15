import 'package:get/get.dart';
import '../controller/Student_Cart_Controller.dart';

class StudentCardListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentCardListController());
  }
}
