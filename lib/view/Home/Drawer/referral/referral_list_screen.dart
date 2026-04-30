import 'package:alama_eorder_app/controller/Home_controller.dart';
import 'package:alama_eorder_app/controller/referral_controller.dart';
import 'package:alama_eorder_app/model/HomeModel.dart';
import 'package:alama_eorder_app/model/get_refferal_status_model.dart';
import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:alama_eorder_app/utils/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralListScreen extends GetView<ReferralController> {
  const ReferralListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Referral List'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Send Link"),
              Tab(text: "Status"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SendLinkTab(),
            StatusTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            Get.toNamed(ROUTE_ADDREFERRAL);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// 🔥 SEND LINK TAB (YOUR EXISTING UI)
////////////////////////////////////////////////////////////////////////////////

class SendLinkTab extends GetView<ReferralController> {
  const SendLinkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.referrals.isEmpty) {
        return const Center(child: Text("No Data Found"));
      }

      return Stack(
        children: [
          /// 🔥 SCROLLABLE CONTENT
          RefreshIndicator(
            onRefresh: controller.refreshList,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80), // 👈 space for button
              child: Column(
                children: [
                  /// COUNT + SELECT ALL
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pending Referrals: ${controller.pendingReferrals.length}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.pendingReferrals.length,
                      itemBuilder: (context, index) {
                        final item = controller.pendingReferrals[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: primaryColor,
                              child: Text(
                                (item.name?.isNotEmpty ?? false)
                                    ? item.name![0].toUpperCase()
                                    : "?",
                              ),
                            ),
                            title: Text(item.name ?? ''),
                            subtitle: Text(item.phoneNumber ?? ''),
                            trailing: Obx(() {
                              final isLoading =
                                  controller.loadingIndex.value == index;

                              return IconButton(
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Icon(Icons.send,
                                        color: Colors.green),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        controller.createLink(index);
                                      },
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}

////////////////////////////////////////////////////////////////////////////////
/// 🔥 STATUS TAB
////////////////////////////////////////////////////////////////////////////////

class StatusTab extends GetView<ReferralController> {
  const StatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = controller.filteredStatusList;

      return RefreshIndicator(
        onRefresh: controller.refreshList,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// 🔥 STATUS TABS (HORIZONTAL)
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    _tab("Link Sent", 0),
                    _tab("Interested", 1),
                    Prefs.getBoolen(SHARED_ADMIN) == true
                        ? Container()
                        : _tab("Free Enrolled", 2),
                    Prefs.getBoolen(SHARED_ADMIN) == true
                        ? Container()
                        : _tab("Paid Enrolled", 4),
                    _tab("Not Interested", 3),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 📋 LIST
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text("No Data Found"))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Text(
                                  (item.name != null && item.name!.isNotEmpty)
                                      ? item.name![0].toUpperCase()
                                      : "?",
                                ),
                              ),

                              title: Text(item.name ?? ""),

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.phone ?? ""),
                                  Text(item.state ?? ""),
                                  if(item.className != null)
                                    Text("Class: ${item.className}"),
                                ],
                              ),

                              /// 🔥 STATUS BADGE
                              trailing: _trailingWidget(item),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 🔥 TAB WIDGET
  Widget _tab(String title, int index) {
    return Obx(() {
      final isSelected = controller.selectedStatusTab.value == index;

      return GestureDetector(
        onTap: () {
          controller.selectedStatusTab.value = index;
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// 🔥 STATUS CHIP
  Widget _statusChip(All item) {
    String status = item.status ?? "";

    Color color;

    switch (status) {
      case "enrolledForFreeProgram":
        color = Colors.blue;
        status = "Enrolled";
        break;
      case "Not interested":
        color = Colors.red;
        break;
      case "enrolledForPaidProgram":
        color = Colors.green;
        status = "Enrolled to Paid";
        break;  
      default:
        if (item.interested == true) {
          color = Colors.green;
          status = "Interested";
        } else {
          color = Colors.orange;
          status = "Link Sent";
        }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _trailingWidget(All item) {
    final status = (item.status ?? "").toLowerCase();
    final isAdmin = Prefs.getBoolen(SHARED_ADMIN);

    if (status == "enrolledforfreeprogram") {
      return ElevatedButton(
        onPressed: () {
          Get.toNamed(ROUTE_ENROLLSTUDENT, arguments: {
            "referralId": item.id,
            "name": item.name,
            "phone": item.phone,
          });
          //controller.enrollToPaid(item.id ?? ""); // or any action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: const Size(0, 36),
        ),
        child: const Text(
          "Enrolled",
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    if (isAdmin && status == "interested") {
      return ElevatedButton(
        onPressed: () {
          _showAssignDialog(item);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: const Size(0, 36),
        ),
        child: const Text(
          "Assign",
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    if (!isAdmin && status == "interested") {
      return ElevatedButton(
        onPressed: () {
          controller.enrollForFreeProgram(item);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: const Size(0, 36),
        ),
        child: const Text(
          "Free Enroll",
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    if(status == "enrolledForPaidProgram"){
      return ElevatedButton(
        onPressed: () {
           
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: const Size(0, 36),
        ),
        child: const Text(
          "Enrolled to Paid",
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    return _statusChip(item);
  }

  void _showAssignDialog(All item) {
    final HomeController homeController = Get.find<HomeController>();
    Get.defaultDialog(
      title: "Assign Franchise",
      content: Obx(() {
        final list = homeController.approvedfranchiselist;

        return Column(
          children: [
            DropdownButtonFormField<FMData>(
              isExpanded: true,
              hint: const Text("Select Franchise"),
              value: controller.selectedFranchise.value,
              items: list.map((franchise) {
                return DropdownMenuItem(
                  value: franchise,
                  child: Text(
                    "${franchise.name} (${franchise.franchiseID})",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedFranchise.value = value;
              },
            ),

            const SizedBox(height: 20),

            /// 🔥 ASSIGN BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedFranchise.value == null) {
                    Get.snackbar("Error", "Please select franchise");
                    return;
                  }

                  controller.assignToFranchise(item.id ?? "",
                      controller.selectedFranchise.value!.franchiseID ?? "");

                  Get.back(); // close dialog
                },
                child: const Text("Assign"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
