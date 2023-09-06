import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/Home_controller.dart';
import '../../../controller/stockTransaction_controller.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/constant.dart';

class StockFilterScreen extends StatefulWidget {
  const StockFilterScreen({Key? key}) : super(key: key);

  @override
  State<StockFilterScreen> createState() => _StockFilterScreenState();
}

class _StockFilterScreenState extends State<StockFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Stock Filter'),
              ),
              body: AnimationLimiter(
                child: Column(
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
                            ..text = DateFormat("yyyy-MM-dd").format(
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
                            ..text = DateFormat("yyyy-MM-dd").format(
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
                                  if (controller.todateText.text.isEmpty ||
                                      controller.fromdateText.text.isEmpty) {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Alert'),
                                        content: const Text(
                                            'Please enter From date & To date'),
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
                                    controller.StockFilterlistmethod();
                                    setState(() {});
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
                                  Get.back();
                                },
                                child: Text('Close'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenHeight * 0.5,
                      child: ListView.builder(
                        padding: EdgeInsets.all(_w / 30),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: controller.stockList.length,
                        itemBuilder: (BuildContext c, int i) {
                          var data = controller.stockList[i];
                          if (controller.stockList.isEmpty) {
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
                                      StockTransactionController stockcontrol =
                                          Get.put(StockTransactionController());
                                      stockcontrol.getTransaction(data.name!);
                                      Get.toNamed(ROUTE_TRANSACTIONSCREEN);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: _w / 20),
                                      height: _w / 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 40,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(data.name!),
                                        subtitle: Text(data.count!.toString()),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
