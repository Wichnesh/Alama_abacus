import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alama_eorder_app/controller/referral_controller.dart';

class AddReferralScreen extends GetView<ReferralController> {
  AddReferralScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Referral')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              /// Franchise ID
              TextFormField(
                controller: controller.franchiseIdController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Franchise ID',
                ),
                validator: controller.validateFranchiseId,
              ),

              const SizedBox(height: 16),

              /// Phone
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: controller.validatePhone,
                maxLength: 10,
              ),

              const SizedBox(height: 16),

              /// Name
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: controller.validateName,
              ),

              const SizedBox(height: 24),

              /// Submit Button
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            controller.submitForm();
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}