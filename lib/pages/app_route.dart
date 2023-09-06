import 'package:alama_eorder_app/view/Home/HomeScreen.dart';
import 'package:get/get.dart';

import '../binding/HomeBinding.dart';
import '../binding/OrderBinding.dart';
import '../binding/enrollstudentBinding.dart';
import '../binding/registerBinding.dart';
import '../binding/stockTransactionBinding.dart';
import '../utils/constant.dart';
import '../view/Auth/Login_Screen.dart';
import '../view/Auth/Register_Screen.dart';
import '../view/Home/TabScreen/DetailScreen/StockTransactionDetails.dart';
import '../view/Home/TabScreen/EnrollStudentScreen.dart';
import '../view/Home/TabScreen/NonApprovedFranchiseScreen.dart';
import '../view/Home/TabScreen/OrderScreen.dart';
import '../view/Home/TabScreen/StockFilterScreen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: ROUTE_LOGIN, page: () => const LoginPage()),
    GetPage(
        name: ROUTE_REGISTER,
        page: () => const RegisterScreen(),
        binding: registerBinding()),
    GetPage(
        name: ROUTE_HOME,
        page: () => const HomeScreen(),
        binding: HomeBinding()),
    GetPage(
        name: ROUTE_NONAPPROVEDSCREEN,
        page: () => const NonApprovedFranchiseScreen()),
    GetPage(
        name: ROUTE_ENROLLSTUDENT,
        page: () => const EnrollStudentScreen(),
        binding: enrollstudentBinding()),
    GetPage(
        name: ROUTE_ORDER,
        page: () => const OrderScreen(),
        binding: OrderBinding()),
    GetPage(name: ROUTE_TRANSACTIONSCREEN, page: () => const StockTransactionScreen(), binding: StockTransactionBinding()),
    GetPage(name: ROUTE_STOCKFILTER, page: ()=> const StockFilterScreen())
  ];
}
