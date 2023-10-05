import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../api/request.dart';
import 'dart:io';
import '../api/url.dart';
import '../model/Ordermodel.dart';

class OrderReportController extends GetxController {
var isLoading = false.obs;
var enableDownload = false.obs;
DateTime? fromdate;
DateTime? todate;
TextEditingController fromdateText = TextEditingController();
TextEditingController todateText = TextEditingController();
var orderList =List<OData>.empty(growable: true).obs;

void getOrderMethod() {
  isLoading.value = true;
  update();
  Map<String, dynamic>? requestData;
  requestData = {
    "startDate": "${fromdateText.text}",
    "endDate": "${todateText.text}",
  };
  RequestDio request = RequestDio(url: getallorders, body: requestData);
  if (kDebugMode) {
    print(requestData);
  }
  request.post().then((response) async {
    if (kDebugMode) {
      print(response.data);
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      OrderModel order = OrderModel.fromJson(response.data);
      if (order.status == true) {
        for (var element in order.data!) {
          orderList.add(element);
        }
        if(orderList.isNotEmpty){
          enableDownload.value = true ;
        }else{
          enableDownload.value = false;
        }
        isLoading.value = false;
        update();
      } else {
        Get.snackbar("Error", "Fetching error",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
      }
    } else if (response.statusCode == 201) {
      OrderModel order = OrderModel.fromJson(response.data);
      if (order.status == true) {
        for (var element in order.data!) {
          orderList.add(element);
        }
        isLoading.value = false;
        update();
      } else {
        Get.snackbar("Error", "Fetching error",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
      }
    } else {
      Get.snackbar("Error", "Fetching error",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    }
  });
}


void generatePdf() async {
  final pdf = pw.Document();
  final tableHeaders = ['S.no','Date','franchise' ,'Student ID', 'Current Level','Future Level','Program'];
  final tableRows = <List<dynamic>>[];

  int counter = 1; // Initialize a counter variable

  for (var data in orderList) {
    DateTime dateTime = DateTime.parse(data.createdAt!);

    // Format the DateTime object into "dd-mm-yyyy" format
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    tableRows.add(['${counter}','${formattedDate}','${data.franchise}','${data.studentID}', '${data.currentLevel}', '${data.futureLevel}', '${data.program}']);
    counter++; // Increment the counter
  }

  // Create a table widget
  final table = pw.Table.fromTextArray(
    headers: tableHeaders,
    data: tableRows,
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Light.ttf'))),
    cellStyle: pw.TextStyle(fontStyle: pw.FontStyle.italic,font: pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Light.ttf'))),
  );

  // Add the table to the PDF documentRoboto-Light.ttf
  pdf.addPage(
      pw.MultiPage(build: (pw.Context context) {
    return [
      pw.Center(child: pw.Text('Alama Abacus',style: pw.TextStyle(fontSize: 20,font: pw.Font.courierBold()))),
      pw.SizedBox(height: 20),
      pw.Center(child: pw.Text('Order Report -- ${fromdateText.text} To ${todateText.text}')),
      pw.SizedBox(height: 20),
      pw.Center(child: table),
    ];
  }));

  final tempDir = await getTemporaryDirectory();
  final pdfFile = File('${tempDir.path}/pdf${DateTime.now()}.pdf');
  await pdfFile.writeAsBytes(await pdf.save());
  await OpenFile.open(pdfFile.path);
}

}