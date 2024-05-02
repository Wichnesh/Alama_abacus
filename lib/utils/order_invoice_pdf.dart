// Order Invoice PDF file for generating invoice PDF
//Format
// 1. Invoice Header, Title and basic details like invoice number, date, customer name, address, etc.
// 2. Invoice Body List of: Student ID,Student name with Ordered level , District, State , Books they order and Cost

import 'dart:io';

import 'package:alama_eorder_app/model/studentmodel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class OrderInvoicePdf {
  static pw.Container buildHeader(SData data,{bool isOrder = false}) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Text(
            'Invoice',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Student ID: ${data.studentID}'),
          // pw.Text('Date: ${(data.levelOrders != null || data.levelOrders!.isNotEmpty) ? data.levelOrders?.last.date?.substring(0, 10):""}'),
          pw.Text('Student Name: ${data.studentName}'),
          pw.Text('Address: ${data.address}'),
        ],
      ),
    );
  }

  static pw.Container buildBody(SData data) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Order Details',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            context: null,
            data: <List<String>>[
              <String>['ID', 'Level', 'Program', 'Date', 'Cost',],
              ...data.levelOrders?.map((e) => [
                e.paymentID.toString(),
                e.level.toString(),
                e.program.toString(),
                e.date.toString().substring(0, 10),
                e.cost.toString(),
              ])?.toList() ?? <List<String>>[],
            ],
          ),
        ],
      ),
    );
  }

  static generateInvoice(SData data) async{
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            buildHeader(data),
            buildBody(data),
          ],
        ),
      ),
    );
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir.path}/pdf${DateTime.now()}.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFile.open(pdfFile.path);
  }
}