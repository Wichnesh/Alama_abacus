import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                    int? quantity;
                    int? totalquantity;
                    bool? type = false;
                    bool? removed = false;
                    // Check if data.createdDate is not null before parsing
                    DateTime? transactionDate = data.createdDate != null ? DateTime.parse(data.createdDate!) : null;
                    String? formattedDate = transactionDate != null ? DateFormat('yy-MM-dd').format(transactionDate) : null;
                    // Calculate the current quantity based on whether data.quantity is positive or negative
                    int addedQuantity = data.quantity! > 0 ? data.quantity! : 0;
                    int removedQuantity = data.quantity! < 0 ? -data.quantity! : 0;
                    if(addedQuantity != 0){
                      quantity = data.quantity! - data.currentQuantity!;
                      totalquantity = quantity + data.currentQuantity!;
                      type = true;
                    }else{
                      addedQuantity = 0;
                      totalquantity = data.currentQuantity! - removedQuantity;
                    }
                    // Check if quantity is negative, and if so, set removed to true
                    if (quantity != null && quantity < 0) {
                      removed = true;
                    }
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
                              height: _w / 1.8,
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
                                    const SizedBox(height: 4,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Franchise Name : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${data.franchiseName}',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                   data.studentID!.isEmpty ?
                                   RichText(
                                       text: const TextSpan(
                                         children: [
                                           TextSpan(
                                             text: 'Student ID : ',
                                             style: TextStyle(color: Colors.black),
                                           ),
                                           TextSpan(
                                             text: '-----',
                                             style: TextStyle(color: Colors.blue),
                                           ),
                                         ],
                                       )) : RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Student ID : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${data.studentID}',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                   data.studentName!.isEmpty ? RichText(
                                     text: const TextSpan(
                                       children: [
                                         TextSpan(
                                           text: 'Student Name : ',
                                           style: TextStyle(color: Colors.black),
                                         ),
                                         TextSpan(
                                           text: '-----',
                                           style: TextStyle(color: Colors.blue),
                                         ),
                                       ],
                                     ),
                                   ) : RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Student Name : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${data.studentName}',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                   type ?
                                   removed ?
                                   RichText(
                                     text: const TextSpan(
                                       children: [
                                         TextSpan(
                                           text: 'Type : ',
                                           style: TextStyle(color: Colors.black),
                                         ),
                                         TextSpan(
                                           text: 'Removed',
                                           style: TextStyle(color: Colors.red),
                                         ),
                                       ],
                                     ),
                                   ):
                                   RichText(
                                     text: const TextSpan(
                                       children: [
                                         TextSpan(
                                           text: 'Type : ',
                                           style: TextStyle(color: Colors.black),
                                         ),
                                         TextSpan(
                                           text: 'Adjusted',
                                           style: TextStyle(color: Colors.green),
                                         ),
                                       ],
                                     ),
                                   ) :
                                   RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Type : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: 'Enrolled',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Item Name : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${data.itemName}',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Transaction Date: ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${formattedDate}',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                   quantity==null ?
                                   RichText(
                                     text: const TextSpan(
                                       children: [
                                         TextSpan(
                                           text: 'Add Quantity : ',
                                           style: TextStyle(color: Colors.black),
                                         ),
                                         TextSpan(
                                           text: '0',
                                           style: TextStyle(color: Colors.blue),
                                         ),
                                       ],
                                     ),
                                   ) :
                                   RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Adjusted Quantity : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: quantity.toString(),
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Enroll Quantity : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: removedQuantity.toString(),
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'previous Quantity : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '${data.currentQuantity}',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Current Stock : ',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '$totalquantity',
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
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
