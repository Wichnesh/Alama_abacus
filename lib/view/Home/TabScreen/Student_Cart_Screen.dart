import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../controller/Student_Cart_Controller.dart';
import '../../../utils/constant.dart';
import '../../../utils/pref_manager.dart';

class StudentCartListScreen extends StatefulWidget {
  const StudentCartListScreen({Key? key}) : super(key: key);

  @override
  State<StudentCartListScreen> createState() => _StudentCartListScreenState();
}

class _StudentCartListScreenState extends State<StudentCartListScreen> {
  StudentCardListController enrollController = Get.find<StudentCardListController>();
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  void payment(int count,int cost, String email) async {
    int totalCost = cost * 100;
    if (kDebugMode) {
      print('total cost--------$totalCost');
    }
    var options = {
      //'key': 'rzp_test_uMK9VbEsTuePim',
      'key' : 'rzp_live_FaHtY1SM9hLWek',
      'amount': totalCost,
      'name': 'Abacus Enrollment ',
      'description': 'No of Student $count',
      'prefill': {
        'contact': "",
        'email': email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
    if (response.orderId == null) {
      enrollController.updatePaymentId(response.paymentId!);
    } else {
      enrollController.updatePaymentId(response.paymentId!);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    bool admin = Prefs.getBoolen(SHARED_ADMIN);
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: (){
            Get.offAllNamed(ROUTE_HOME);
          },
            child: const Icon(Icons.arrow_back_rounded)),
      ),
      body: GetBuilder<StudentCardListController>(
        init: StudentCardListController(),
        builder: ((controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  height:  _h * 0.8,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(_w / 30),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: controller.studentCardList.length,
                      itemBuilder: (BuildContext c, int i) {
                        var data = controller.studentCardList[i];
                        if (controller.studentCardList.isEmpty) {
                          return const Center(
                            child: Text(
                              'No Data',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        } else {
                          return AnimationConfiguration.staggeredList(
                            position: i,
                            delay: const Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              horizontalOffset: 30,
                              verticalOffset: 300.0,
                              child: FlipAnimation(
                                duration: const Duration(milliseconds: 3000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                flipAxis: FlipAxis.y,
                                child: InkWell(
                                  onTap: () {
                                    //Get.to(() => StudentDetails(data: data));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: _w / 20),
                                        height: _w / 5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 40,
                                              spreadRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          title: Text(data.studentName ?? ''),
                                          subtitle: Text(data.mobileNumber ?? ''),
                                          trailing: InkWell(
                                            onTap: (){
                                              controller.deleteStudent(data.studentID ?? '');
                                            },
                                              child: const Icon(Icons.delete,color: Colors.red,)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                   int total = controller.updateTotalCost();
                   if (kDebugMode) {
                     print(total);
                   }
                    payment(controller.studentCardList.length,total,Prefs.getString(USERNAME));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(0), // Use zero padding to let the Container control padding
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Enroll Student',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
