import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../controller/Home_controller.dart';
import '../../../utils/notificationBadge.dart';
import 'DetailScreen/FranchaiseDetails.dart';

class ApprovedFranchiseScreen extends StatefulWidget {
  const ApprovedFranchiseScreen({super.key});

  @override
  State<ApprovedFranchiseScreen> createState() =>
      _ApprovedFranchiseScreenState();
}

class _ApprovedFranchiseScreenState extends State<ApprovedFranchiseScreen> {
  HomeController homeController = Get.find<HomeController>();
  Future<void> showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: const Text('Filter Options'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown 1
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedState.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "State",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.stateData.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.selectedDistrict.value = 'Select';
                          homeController.updateSelectedState(val!);
                        });
                      },
                    ),
                  ),
                ),
                // Dropdown 2
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(homeController.selectedDistrict.value),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "District",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.districtData[homeController.selectedState.value]!
                          .map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.selectedDistrict.value = val!;
                        });
                      },
                    ),
                  ),
                ),
                // Text Field 1
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text(
                        homeController.selectedFranchise.value,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 25,
                      decoration: const InputDecoration(
                        labelText: "Franchise",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      items: homeController.approvedfranchiselist.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val.name,
                            child: Text(
                              val.name!,
                            ),
                            onTap: () {
                              setState(() {

                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          homeController.updateSelectedFranchise(val!);
                        });

                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () {
                  homeController.filterFranchiseListAllFranchise(
                      homeController.selectedFranchise.value,homeController.selectedState.value,homeController.selectedDistrict.value);
                  if (kDebugMode) {
                    print('pressed');
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: buildAppBar(),
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
                itemCount: controller.approvedfranchiselist.length,
                itemBuilder: (BuildContext c, int i) {
                  var data = controller.approvedfranchiselist[i];
                  if (controller.approvedfranchiselist.isEmpty) {
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

  Widget buildAppBar() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        if (controller.nonapprovedfranchiselist.isEmpty) {
          return AppBar(
            title: const Text("Franchise List"),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                homeController.selectedDistrict.value = "Select";
                homeController.selectedState.value = "Select";
                homeController.nametext.text = "";
                homeController.contactNo.text ="";
                showFilterDialog();
              }, icon: const Icon(Icons.filter_alt)),
               Center(
                child: Column(
                  children: [
                    Text(''),
                    NamedIcon(
                      text: '',
                      iconData: Icons.notifications,
                      notificationCount: 0,
                    ),
                  ],
                ),
              )
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          );
        } else {
          return AppBar(
            title: const Text("Franchise List"),
            centerTitle: true,
            actions: [
              Center(
                child: Column(
                  children: [
                    const Text(''),
                    NamedIcon(
                      text: '',
                      iconData: Icons.notifications,
                      notificationCount:
                          controller.nonapprovedfranchiselist.length,
                      onTap: () {
                        Get.toNamed(ROUTE_NONAPPROVEDSCREEN);
                      },
                    ),
                  ],
                ),
              )
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          );
        }
      },
    );
  }
}
