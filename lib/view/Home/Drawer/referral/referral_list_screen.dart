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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral List'),
      ),
      body: Obx(() {
        /// 🔥 1. LOADING STATE (FIRST LOAD)
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// 🔥 2. EMPTY STATE
        if (controller.referrals.isEmpty) {
          return const Center(
            child: Text("No Data Found"),
          );
        }

        /// 🔥 3. DATA STATE
        return RefreshIndicator(
          onRefresh: controller.refreshList,
          child: Column(
            children: [
              /// 🔢 COUNT
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Total Referrals: ${controller.totalCount}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 📋 LIST
              Expanded(
                child: ListView.builder(
                  itemCount: controller.referrals.length,
                  itemBuilder: (context, index) {
                    final item = controller.referrals[index];

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
                        trailing: Text(
                          item.createdAt != null
                              ? "${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}"
                              : "",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.toNamed(ROUTE_ADDREFERRAL);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
