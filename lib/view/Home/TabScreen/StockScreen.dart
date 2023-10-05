import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../../../controller/Home_controller.dart';
import '../../../controller/stockTransaction_controller.dart';
import '../../../model/stockmodel.dart';
import '../../../utils/constant.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {

  void updateUi(){
    setState(() {
      if (kDebugMode) {
        print('I\'m Executed this Update UI');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    bool admin = Prefs.getBoolen(SHARED_ADMIN);
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(ROUTE_STOCKFILTER);
            },
            icon: const Icon(Icons.filter_alt_rounded),
          )
        ],
      ),
      body: GetBuilder<HomeController>(
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
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(data.name!),
                                  subtitle: Obx(() => controller.stockIsLoading.value ? const CircularProgressIndicator() : Text(data.count.toString())),
                                  trailing: ElevatedButton(
                                    child: const Text('update'),
                                    onPressed: () {
                                      admin ? _showUpdateDialogAdmin(data) : _showUpdateDialogFranchise(data);
                                    },
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
        }
        ),
      ),
    );
  }
// Function to show the update stock dialog
  Future<void> _showUpdateDialogAdmin(StData data) async {
    int adjustedCount = data.count!;
    bool isAdding = true;

    await showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Update Stock--> ${data.name!}'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Current Stock Count: ${data.count}'),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            try {
                              controller.count.value = value;
                              adjustedCount = int.parse(value);
                            } catch (e) {
                              // Handle invalid input here if needed
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Adjust Count',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isAdding = true;
                                    if (isAdding) {
                                      adjustedCount += data.count!;
                                    } else {
                                      adjustedCount =
                                          data.count! - adjustedCount;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: isAdding ? Colors.green : null,
                                ),
                                child: const Text('Add'),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isAdding = false;
                                      if (isAdding) {
                                        adjustedCount += data.count!;
                                      } else {
                                        adjustedCount = data.count! - adjustedCount;
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: !isAdding ? Colors.red : null,
                                  ),
                                  child: const Text('Subtract'),
                                )),
                          ],
                        ),
                        Text('Adjusted Stock Count: $adjustedCount'),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          await controller.updateStock(
                              adjustedCount, data.sId.toString());
                          await Future.delayed(const Duration(seconds: 2));
                          updateUi();
                        },
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            });
      },
    );
  }
  // Function to show the update stock dialog
  Future<void> _showUpdateDialogFranchise(StData data) async {
    int adjustedCount = data.count!;
    bool isAdding = true;

    await showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Update Stock--> ${data.name!}'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Current Stock Count: ${data.count}'),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            try {
                              controller.count.value = value;
                              adjustedCount = int.parse(value);
                            } catch (e) {
                              // Handle invalid input here if needed
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Adjust Count',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isAdding = true;
                                    if (isAdding) {
                                      adjustedCount += data.count!;
                                    } else {
                                      adjustedCount =
                                          data.count! - adjustedCount;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: isAdding ? Colors.green : null,
                                ),
                                child: const Text('Add'),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isAdding = false;
                                  if (isAdding) {
                                    adjustedCount += data.count!;
                                  } else {
                                    adjustedCount = data.count! - adjustedCount;
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: !isAdding ? Colors.red : null,
                              ),
                              child: const Text('Subtract'),
                            )),
                          ],
                        ),
                        Text('Adjusted Stock Count: $adjustedCount'),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                         if(controller.count.value == '0'){
                           return;
                         }else{
                           await controller.updateStock(adjustedCount, data.sId.toString());
                         }
                         await Future.delayed(const Duration(seconds: 2));
                        updateUi();
                      },
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            });
      },
    );
  }
}
