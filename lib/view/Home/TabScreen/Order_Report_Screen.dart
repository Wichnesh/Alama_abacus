import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/Order_report_controller.dart';
import '../../../utils/colorUtils.dart';

class OrderReportScreen extends StatefulWidget {
  const OrderReportScreen({super.key});

  @override
  State<OrderReportScreen> createState() => _OrderReportScreenState();
}

class _OrderReportScreenState extends State<OrderReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Report'),
      ),
      body: GetBuilder<OrderReportController>(
        init: OrderReportController(),
        builder: ((controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? date = DateTime.now();
                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if (date != null) {
                        controller.fromdate = date;
                        controller.update();
                      }
                    },
                    controller: controller.fromdateText
                      ..text = DateFormat("dd-MM-yyyy").format(
                          controller.fromdate == null
                              ? DateTime.now()
                              : controller.fromdate ?? DateTime.now()),
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      labelText: "From Date",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? date = DateTime.now();

                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());

                      if (date != null) {
                        controller.todate = date;
                        controller.update();
                      }
                    },
                    controller: controller.todateText
                      ..text = DateFormat("dd-MM-yyyy").format(
                          controller.todate == null
                              ? DateTime.now()
                              : controller.todate ?? DateTime.now()),
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      labelText: "To Date",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
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
                                if (states.contains(MaterialState.pressed)) {
                                  // Change the button color when pressed
                                  return Colors.green;
                                }
                                // Return the default button color
                                return primaryColor;
                              },
                            ),
                          ),
                          onPressed: () {
                            if (controller.fromdateText.text.isEmpty) {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Alert'),
                                  content: const Text(
                                      'Please enter From date '),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              controller.getReportMethod();
                            }
                          },
                          child: const SizedBox(
                            height: 50,
                            width: 165,
                            child: Center(
                              child: Text(
                                "Submit",
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
                      child: Container(
                        height: 55,
                        width: 175,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
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
                            Get.back();
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              controller.enableDownload.isTrue
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
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
                                if (controller.enableDownload.isTrue) {
                                  controller.reportGeneratePdf();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Data Not Available');
                                }
                              },
                              child: const SizedBox(
                                height: 50,
                                width: 165,
                                child: Center(
                                  child: Text(
                                    "Download PDF",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          );
        }),
      ),
    );
  }
}
