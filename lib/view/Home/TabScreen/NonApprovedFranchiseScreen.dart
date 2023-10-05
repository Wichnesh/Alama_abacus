import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../controller/Home_controller.dart';
import 'DetailScreen/FranchaiseDetails.dart';

class NonApprovedFranchiseScreen extends StatefulWidget {
  const NonApprovedFranchiseScreen({Key? key}) : super(key: key);

  @override
  State<NonApprovedFranchiseScreen> createState() =>
      _NonApprovedFranchiseScreenState();
}

class _NonApprovedFranchiseScreenState
    extends State<NonApprovedFranchiseScreen> {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Non - Approved Franchise List'),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(),
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
                itemCount: controller.nonapprovedfranchiselist.length,
                itemBuilder: (BuildContext c, int i) {
                  var data = controller.nonapprovedfranchiselist[i];
                  if (controller.nonapprovedfranchiselist.isEmpty) {
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
                              Get.to(() => franchiseDetail(data: data));
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
                                subtitle: Text(data.contactNumber!),
                                trailing: ElevatedButton(
                                  child: const Text('Approve'),
                                  onPressed: () {
                                    controller.approve(data.franchiseID!);
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
        }),
      ),
    );
  }
}
