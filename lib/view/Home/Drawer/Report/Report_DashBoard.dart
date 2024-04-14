import 'package:flutter/material.dart';

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
        children: [
          _buildReportItem(context, 'Franchise Report'),
          _buildReportItem(context, 'Order Report'),
        ],
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // Navigate to respective report screen
        // You can implement navigation logic here
      },
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReportDashboard(),
  ));
}
