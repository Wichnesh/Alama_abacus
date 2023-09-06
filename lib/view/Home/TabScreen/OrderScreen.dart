import 'package:alama_eorder_app/controller/Order_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../utils/colorUtils.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Razorpay? _razorpay;
  final OrderController orderController = Get.find<OrderController>();

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

  void payment(String name, String contact, String email) async {
    int totalCost = 500 * 100;
    var options = {
      'key': 'rzp_test_r0nbHDzzVtfN6m',
      'amount': totalCost,
      'name': name,
      'description': 'Payment',
      'prefill': {'contact': contact, 'email': email},
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
    orderController.updateOrder();
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: GetBuilder<OrderController>(
          builder: ((controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Student ID',
                      ),
                      controller: TextEditingController(
                          text: controller.data.studentID.toString()),
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Current Level',
                      ),
                      controller: TextEditingController(
                          text: controller.currentlevel.value),
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Future Level',
                      ),
                      controller: TextEditingController(
                          text: controller.futurelevel.value),
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Program',
                      ),
                      controller: controller.programText,
                      readOnly: true,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.BookList.map((book) {
                      // Use CheckboxListTile to create each checkbox item
                      return CheckboxListTile(
                        title: Text(book),
                        value:
                            true, // Set this to true for default checked state
                        onChanged: (bool? newValue) {
                          // Handle checkbox state change if needed
                        },
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 55,
                            width: 175,
                            color: primaryColor,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      // Change the button color when pressed
                                      return Colors.green;
                                    }
                                    // Return the default button color
                                    return primaryColor;
                                  },
                                ),
                              ),
                              onPressed: () {
                                payment(
                                    controller.data.studentName!,
                                    controller.data.mobileNumber!,
                                    controller.data.email!);
                              },
                              child: const SizedBox(
                                height: 50,
                                width: 165,
                                child: Center(
                                  child: Text(
                                    "Order",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            width: 175,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      // Change the button color when pressed
                                      return Colors.green;
                                    }
                                    // Return the default button color
                                    return Colors
                                        .red; // or any other color you want
                                  },
                                ),
                              ),
                              onPressed: () {
                                // Handle the button click event
                                Get.delete();
                                Get.back();
                              },
                              child: Text('Close'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ));
  }
}