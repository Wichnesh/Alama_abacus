import 'package:alama_eorder_app/view/Home/HomeScreen.dart';
import 'package:get/get.dart';

import '../binding/registerBinding.dart';
import '../utils/constant.dart';
import '../view/Auth/Login_Screen.dart';
import '../view/Auth/Register_Screen.dart';
import '../view/Home/TabScreen/EnrollStudentScreen.dart';
import '../view/Home/TabScreen/NonApprovedFranchiseScreen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: ROUTE_LOGIN, page: () => const LoginPage()),
    GetPage(
        name: ROUTE_REGISTER,
        page: () => const RegisterScreen(),
        binding: registerBinding()),
    GetPage(name: ROUTE_HOME, page: () => const HomeScreen()),
    GetPage(
        name: ROUTE_NONAPPROVEDSCREEN,
        page: () => const NonApprovedFranchiseScreen()),
    GetPage(name: ROUTE_ENROLLSTUDENT, page: () => const EnrollStudentScreen())
  ];
}
