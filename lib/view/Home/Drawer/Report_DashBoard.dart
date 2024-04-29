import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';

class ReportDashboard extends StatelessWidget {
  const ReportDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Number of columns
        children: _buildReportItems(context),
      ),
    );
  }

  List<Widget> _buildReportItems(BuildContext context) {
    final reportItems = {
      'Franchise Wise Student Report': ROUTE_FWS,
      'Order Report': ROUTE_ORDERREPORTS,
      'Franchise Wise Order Report' : ROUTE_FWO
    };

    return reportItems.entries.map((entry) {
      return _buildReportItem(context, entry.key, entry.value);
    }).toList();
  }

  Widget _buildReportItem(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () {
        if(route.isEmpty){

        }else{
          Get.toNamed(route);
        }
      },
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}
