import 'package:get/get.dart';
import 'package:alama_eorder_app/controller/referral_controller.dart';

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralController>(() => ReferralController());
  }
}
