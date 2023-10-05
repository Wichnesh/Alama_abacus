import 'package:get/get.dart';
import '../controller/stockTransaction_controller.dart';

class StockTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StockTransactionController());
  }
}
