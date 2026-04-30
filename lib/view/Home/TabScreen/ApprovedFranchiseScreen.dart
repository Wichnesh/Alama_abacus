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
  final HomeController homeController = Get.find<HomeController>();

  /// 🔥 FILTER DIALOG
  Future<void> showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Options'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// STATE DROPDOWN
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    value: homeController.selectedState.value == "Select"
                        ? null
                        : homeController.selectedState.value,
                    hint: const Text("Select State"),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "State",
                      border: OutlineInputBorder(),
                    ),
                    items: homeController.stateData
                        .map((val) => DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        homeController.selectedDistrict.value = "Select";
                        homeController.updateSelectedState(val!);
                      });
                    },
                  ),
                ),

                /// DISTRICT DROPDOWN
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    value: homeController.selectedDistrict.value == "Select"
                        ? null
                        : homeController.selectedDistrict.value,
                    hint: const Text("Select District"),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "District",
                      border: OutlineInputBorder(),
                    ),
                    items: homeController
                        .districtData[homeController.selectedState.value]!
                        .map((val) => DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        homeController.selectedDistrict.value = val!;
                      });
                    },
                  ),
                ),

                /// FRANCHISE DROPDOWN
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    value: homeController.selectedFranchise.value == "Select"
                        ? null
                        : homeController.selectedFranchise.value,
                    hint: const Text("Select Franchise"),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Franchise",
                      border: OutlineInputBorder(),
                    ),
                    items: homeController.approvedfranchiselist
                        .map((val) => DropdownMenuItem(
                              value: val.name,
                              child: Text(val.name ?? ""),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        homeController.updateSelectedFranchise(val!);
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  homeController.selectedState.value = "Select";
                  homeController.selectedDistrict.value = "Select";
                  homeController.selectedFranchise.value = "Select";
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () {
                  homeController.filterFranchiseListAllFranchise(
                    homeController.selectedFranchise.value,
                    homeController.selectedState.value,
                    homeController.selectedDistrict.value,
                  );
                  Navigator.pop(context);
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
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: buildAppBar(),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.approvedfranchiselist.isEmpty) {
            return const Center(child: Text('No Data'));
          }

          return AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(w / 30),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.approvedfranchiselist.length,
              itemBuilder: (c, i) {
                var data = controller.approvedfranchiselist[i];

                return AnimationConfiguration.staggeredList(
                  position: i,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50,
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => franchiseDetail(data: data));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: w / 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(data.username ?? ""),
                            subtitle: Text(data.contactNumber ?? ""),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      title: const Text("Franchise List"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            showFilterDialog();
          },
          icon: const Icon(Icons.filter_alt),
        ),

        GetBuilder<HomeController>(
          builder: (controller) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 10),
                child: NamedIcon(
                  text: '',
                  iconData: Icons.notifications,
                  notificationCount: controller.nonapprovedfranchiselist.length,
                  onTap: () {
                    Get.toNamed(ROUTE_NONAPPROVEDSCREEN);
                  },
                ),
              ),
            );
          },
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
