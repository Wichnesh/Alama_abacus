import 'dart:developer';

import 'package:alama_eorder_app/controller/Order_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../api/url.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/constant.dart';
import '../../../utils/pref_manager.dart';

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
    totalAmount = 0;
    _razorpay?.clear();
  }

  int totalAmount = 0;

  void payment(String name, String contact, String email, String state,
      bool extraAmount) async {
    int totalCost = 0;
    String key = "";
    if (Prefs.getString(USERNAME) == "padma@gmail.com") {
      totalCost = 1 * 100;
    } else {
      if (state == 'Tamil Nadu') {
        key = RazorPay.Tn_Key;
        log("TN key Used");
        if (extraAmount == true) {
          totalCost = (400 + 300) * 100;
        } else {
          totalCost = 400 * 100;
        }
      } else {
        key = RazorPay.key;
        log("NON TN Key");
        if (extraAmount == true) {
          totalCost = (500 + 400) * 100;
        } else {
          totalCost = 500 * 100;
        }
      }
    }
    log("------$key-------");
    var options = {
      'key': key,
      'amount': totalCost,
      'name': name,
      'description': 'Order Payment',
      'prefill': {'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      totalAmount = totalCost;
      print("Payment Start");
      Map notes = {
        "contact": contact,
        "email": email,
        "state": state,
      };
      String? id = await orderController.createOrder(name, notes, totalCost);
      print("Order ID: $id");
      if (id != null) {
        options['order_id'] = id;
        _razorpay?.open(options);
      }
    } catch (e) {
      debugPrint("razorpay error ---> ${e.toString()}");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
    // orderController.updateOrder(response.paymentId ?? '',totalAmount);
    orderController.onOrderSuccess();
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
    String franchiseState = Prefs.getString(FRANCHISESTATE);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
          centerTitle: true,
          // automaticallyImplyLeading: false,
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
                        labelText: 'Completed Level',
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
                        labelText: 'Order Level',
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
                  Obx(() {
                    if (controller.isChecked.value) {
                      return Column(
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
                      );
                    } else {
                      return Column(
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
                      );
                    }
                  }),
                  Obx(() {
                    if (controller.currentlevel.value == 'Level 5' &&
                        controller.programText.text == 'AA') {
                      return CheckboxListTile(
                        title: const Text('continue MA Program *'),
                        value: controller.isChecked.value,
                        onChanged: (newValue) {
                          controller.Checkbox(newValue!);
                          controller.addBookList();
                          setState(() {});
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Obx(() {
                          if (controller.enableBtn.value ||
                              controller.programText.text == 'Level 8') {
                            return Container();
                          } else {
                            return Obx(
                              () => Expanded(
                                child: SizedBox(
                                  height: 55,
                                  width: 175,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return Colors
                                                .grey; // Grey when disabled
                                          }

                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Colors.green;
                                          }

                                          return primaryColor;
                                        },
                                      ),
                                    ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () {
                                            payment(
                                              controller.data.studentName!,
                                              controller.data.mobileNumber!,
                                              Prefs.getString(USERNAME),
                                              franchiseState,
                                              controller.transferBool.value,
                                            );
                                          },
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "Order",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
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
