import 'package:alama_eorder_app/controller/referral_controller.dart';
import 'package:alama_eorder_app/utils/colorUtils.dart';
import 'package:alama_eorder_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Referrals: ${controller.totalCount}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Obx(() => Row(
                              children: [
                                const Text("Select All"),
                                Checkbox(
                                  value: controller.isAllSelected,
                                  onChanged: (value) {
                                    if (value == true) {
                                      controller.selectAll();
                                    } else {
                                      controller.clearSelection();
                                    }
                                  },
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.referrals.length,
                      itemBuilder: (context, index) {
                        final item = controller.referrals[index];

                        return Obx(() {
                          final isSelected = controller.selectedList.any(
                            (e) => e["phone"] == item.phoneNumber,
                          );

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              onTap: () =>
                                  controller.toggleSelection(item),

                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      controller
                                          .toggleSelection(item);
                                    },
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Text(
                                      (item.name?.isNotEmpty ?? false)
                                          ? item.name![0]
                                              .toUpperCase()
                                          : "?",
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(item.name ?? ''),
                              subtitle:
                                  Text(item.phoneNumber ?? ''),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 FIXED BUTTON (DOES NOT SCROLL)
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14),
                  ),
                  onPressed: controller.selectedList.isEmpty
                      ? null
                      : () {
                          /// 🔥 YOUR ACTION
                         
                        },
                  child: Text(
                    controller.selectedList.isEmpty
                        ? "Select Users"
                        : "Send Link (${controller.selectedList.length})",
                  ),
                )),
          ),
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

      if (controller.statusModel.value == null) {
        return const Center(child: Text("No Data"));
      }

      final counts = controller.statusModel.value!.counts;

      return Column(
        children: [
          /// 🔥 COUNT FILTER BOXES
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _countBox("All", counts["total"] ?? 0, 0),
                _countBox("Interested", counts["interested"] ?? 0, 1),
                _countBox(
                    "Not Interested", counts["notInterested"] ?? 0, 2),
              ],
            ),
          ),

          /// LIST
          Expanded(
            child: controller.currentList.isEmpty
                ? const Center(child: Text("No Data Found"))
                : ListView.builder(
                    itemCount: controller.currentList.length,
                    itemBuilder: (context, index) {
                      final item = controller.currentList[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              item["name"] != null
                                  ? item["name"][0].toUpperCase()
                                  : "?",
                            ),
                          ),
                          title: Text(item["name"] ?? ""),
                          subtitle: Text(item["phone"] ?? ""),
                          trailing: Text(
                            item["submitted"] == true
                                ? "Submitted"
                                : "Pending",
                            style: TextStyle(
                              color: item["submitted"] == true
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _countBox(String title, int count, int index) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;

      return GestureDetector(
        onTap: () {
          controller.selectedTab.value = index;
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}