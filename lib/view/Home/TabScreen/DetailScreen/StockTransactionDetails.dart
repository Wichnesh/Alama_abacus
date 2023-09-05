import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../controller/stockTransaction_controller.dart';
import '../../../../utils/colorUtils.dart';

class StockTransactionScreen extends StatefulWidget {
  const StockTransactionScreen({Key? key}) : super(key: key);

  @override
  State<StockTransactionScreen> createState() => _StockTransactionScreenState();
}

class _StockTransactionScreenState extends State<StockTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction List'),
        centerTitle: true,
      ),
      body: GetBuilder<StockTransactionController>(
        init: StockTransactionController(),
        builder: ((controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.all(_w / 30),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: controller.transaction.length,
                itemBuilder: (BuildContext c, int i) {
                  var data = controller.transaction[i];
                  if (controller.transaction.isEmpty) {
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
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(bottom: _w / 20),
                              height: _w / 4,
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Franchise Name : ${data.franchiseName}'),
                                    Text('Student ID : ${data.studentID}'),
                                    Text('Student Name : ${data.studentName}'),
                                    Text('Item Name : ${data.itemName}'),
                                    Text('Quantity : ${data.quantity}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }
        }),
      ),
    );
  }
}
