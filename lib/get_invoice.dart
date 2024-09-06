import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class InvoiceListScreen extends StatefulWidget {
  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  DateTimeRange? _selectedDateRange;

  void _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Stream<QuerySnapshot> _fetchInvoicesStream() {
    if (_selectedDateRange == null) {
      return FirebaseFirestore.instance.collection('bills').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('bills')
          .where('invoice date',
              isGreaterThanOrEqualTo:
                  DateFormat('dd-MM-yyyy').format(_selectedDateRange!.start))
          .where('invoice date',
              isLessThanOrEqualTo:
                  DateFormat('dd-MM-yyyy').format(_selectedDateRange!.end))
          .snapshots();
    }
  }

  // Custom function to convert number to words
  String numberToWords(int number) {
    const ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];
    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    if (number == 0) {
      return 'Zero';
    }

    if (number < 20) {
      return ones[number];
    }

    if (number < 100) {
      return tens[number ~/ 10] +
          (number % 10 != 0 ? ' ' + ones[number % 10] : '');
    }

    if (number < 1000) {
      return ones[number ~/ 100] +
          ' Hundred' +
          (number % 100 != 0 ? ' and ' + numberToWords(number % 100) : '');
    }

    if (number < 100000) {
      return numberToWords(number ~/ 1000) +
          ' Thousand' +
          (number % 1000 != 0 ? ' ' + numberToWords(number % 1000) : '');
    }

    if (number < 10000000) {
      return numberToWords(number ~/ 100000) +
          ' Lakh' +
          (number % 100000 != 0 ? ' ' + numberToWords(number % 100000) : '');
    }

    return numberToWords(number ~/ 10000000) +
        ' Crore' +
        (number % 10000000 != 0 ? ' ' + numberToWords(number % 10000000) : '');
  }

  Future<Uint8List> _generatePdf(Map<String, dynamic> billData) async {
    final pdf = pw.Document();
    // Fetch unit data from Firestore where 'unit name' equals billData['Unit Name']
    final unitSnapshot = await FirebaseFirestore.instance
        .collection('units')
        .where('Unit Name', isEqualTo: billData['Unit Name'])
        .get();

    if (unitSnapshot.docs.isEmpty) {
      throw Exception(
          'Unit data not found for unit name: ${billData['Unit Name']}');
    }

    final unitData = unitSnapshot.docs.first.data();
    final ByteData data = await rootBundle.load('assets/logo.jpeg');
    final Uint8List bytes = data.buffer.asUint8List();
    final ByteData data1 =
        await rootBundle.load('assets/mohar.jpeg'); // Load the mohar.jpeg image
    final Uint8List bytes1 = data1.buffer.asUint8List();
    final double cgstAmount = billData['cgstAmount'] ?? 0.0;
    final double sgstAmount = billData['sgstAmount'] ?? 0.0;
    final double igstAmount = billData['igstAmount'] ?? 0.0;
    final double taxTotal = cgstAmount + sgstAmount + igstAmount;
    final double grandTotal = billData['netAmount'];
    final grandTotalInWords = numberToWords(grandTotal.round());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1.0),
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(5.0)),
              // Adjust border color, width, and radius as needed
            ),
            padding: pw.EdgeInsets.all(16.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'Laksh vidhee security force',
                        style: pw.TextStyle(
                            fontSize: 15, fontWeight: pw.FontWeight.bold),
                      ),
                    ),

                    // Image container
                    pw.Container(
                      width: 60.0,
                      height: 60.0,
                      child: pw.Image(pw.MemoryImage(bytes)),
                    ),
                  ],
                ),

// pw.SizedBox(height: 8),
                pw.Text(
                    'PRASHURAM PLAZA, SHOP NO 101, ABOVE CHANDRABHAGA MARRIAGE HALL,',
                    style: pw.TextStyle(fontSize: 7)),

                pw.Text('PISAVALI KALYAN EAST, THANE, MAHARASHTRA, 421306',
                    style: pw.TextStyle(fontSize: 7)),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.black, width: 1.0)),
                  ),
                  padding: pw.EdgeInsets.only(bottom: 8.0),
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Phone: 9699520007',
                            style: pw.TextStyle(fontSize: 8)),
                        pw.Text('Email: lakshyagroups7@gmail.com',
                            style: pw.TextStyle(fontSize: 8)),
                        pw.Text('PAN: AKXPT2970K',
                            style: pw.TextStyle(fontSize: 8)),
                        pw.Text('GSTIN: 27AKXPT2970K1Z4',
                            style: pw.TextStyle(fontSize: 8)),
                        pw.Text('State: Maharashtra Code: MH',
                            style: pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            'Invoice Month: June - 2024',
                            style: pw.TextStyle(fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'TAX INVOICE',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Divider(),
                      ],
                    ),
                  ],
                ),

                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.black, width: 1.0)),
                  ),
                  padding: pw.EdgeInsets.only(bottom: 8.0),
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('To,', style: pw.TextStyle(fontSize: 7)),
                          pw.Text('${billData['unit']}',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text('${unitData['print address(billed to)']}',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text('GSTIN: 27AAAFX2637C1ZE',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text('State: ${unitData['Billing to state']}',
                              style: pw.TextStyle(fontSize: 7)),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 1.0,
                      height: 80.0, // Adjust the height as needed
                      color: PdfColors.black,
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Invoice No.: ${billData['Invoice Number']}',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text('Invoice Date: ${billData['invoice date']}',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text(
                              'Invoice Period: ${billData['startDate']} to ${billData['endDate']}',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text('Site At: ${unitData['Site At']}',
                              style: pw.TextStyle(fontSize: 7)),
                          pw.Text(
                              'Place Of Supply: ${unitData['Place Of Supply']}',
                              style: pw.TextStyle(fontSize: 7)),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.black, width: 1.0)),
                  ),
                  padding: pw.EdgeInsets.only(bottom: 8.0),
                ),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text('Description',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text('SAC',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text('Rate',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text('Duties',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text('NOP',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4.0),
                          child: pw.Text('Amount(Rs)',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        ),
                      ],
                    ),
                    ...billData['services'].map<pw.TableRow>((item) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['service'],
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['service'],
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['basic'].toString(),
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['duty'].toString(),
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['nos'].toString(),
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['amount'].toString(),
                                style: pw.TextStyle(fontSize: 7)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 1.0,
                      height: 65.0, // Adjust the height as needed
                      color: PdfColors.white,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Total : ${billData['totalAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('Sub Total: ${billData['totalAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('Service Charges: 0.00',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('Taxable Value: ${billData['totalAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                      ],
                    ),
                  ],
                ),

                //divider again
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.black, width: 1.0)),
                  ),
                  padding: pw.EdgeInsets.only(bottom: 8.0),
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Bank details,',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text(
                            'Bank Name: KOTAK MAHINDRA BANK ${billData['bankName']}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('Bank A/C: 3547294758 ${billData['accountNo']}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text(
                            'Bank IFSC: KKBK0000628 ${billData['ifscCode']}',
                            style: pw.TextStyle(fontSize: 7)),
                      ],
                    ),
                    // pw.Container(
                    //   width: 1.0,
                    //   height: 100.0, // Adjust the height as needed
                    //   color: PdfColors.black,
                    // ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('CGST: ${billData['cgstAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('SGST: ${billData['sgstAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('IGST: ${billData['igstAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                      ],
                    ),
                  ],
                ),
                //divider again
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.black, width: 1.0)),
                  ),
                  padding: pw.EdgeInsets.only(bottom: 8.0),
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('GST on Reverse Charge: No',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Container(
                          width: 200.0, // Adjust the width as needed
                          child: pw.Wrap(
                            children: [
                              pw.Text('Amount in Words: $grandTotalInWords',
                                  style: pw.TextStyle(fontSize: 7)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Tax Total: ${taxTotal.toStringAsFixed(2)}',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text('Grand Total: ${billData['netAmount']}',
                            style: pw.TextStyle(fontSize: 7)),
                      ],
                    ),
                  ],
                ),

                //divider again
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.black, width: 1.0)),
                  ),
                  padding: pw.EdgeInsets.only(bottom: 8.0),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            'Payment through bank DD/NEFT/RTGS/Cheque favouring',
                            style: pw.TextStyle(fontSize: 5)),
                        pw.Text('Laksh Vidhee Security Force',
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text(
                            'All Disputes subjects to Mumbai jurisdiction only.',
                            style: pw.TextStyle(fontSize: 5)),
                        pw.SizedBox(height: 8),
                      ],
                    ),
                    // pw.Container(
                    //   width: 1.0,
                    //   height: 19.0, // Adjust the height as needed
                    //   color: PdfColors.black,
                    // ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Positioned(
                          right: 16.0,
                          bottom: 16.0,
                          child: pw.Image(pw.MemoryImage(bytes1),
                              width: 50.0, height: 50.0),
                        ),
                      ],
                    ),
                  ],
                ),

                //  pw.Container(
                //     width: 80.0,
                //     height: 80.0,
                //     child: pw.Image(pw.MemoryImage(bytes1)), // Display mohar.jpeg image here
                //   ),

                // Add other details as needed
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  void _downloadInvoice(Map<String, dynamic> billData) async {
    final pdfData = await _generatePdf(billData);
    await Printing.sharePdf(bytes: pdfData, filename: 'invoice.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: _selectedDateRange == null
          ? Center(
              child: ElevatedButton(
                onPressed: _pickDateRange,
                child: Text('Select Date Range'),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _fetchInvoicesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No invoices found'));
                }

                final invoices = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: invoices.length,
                  itemBuilder: (context, index) {
                    final invoiceData =
                        invoices[index].data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text('Invoice Client: ${invoiceData['client']}'),
                      subtitle: Text('Unit: ${invoiceData['unit']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Date: ${invoiceData['invoice date']}'),
                          IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => _downloadInvoice(invoiceData),
                          ),
                          IconButton(
                            icon: Icon(Icons.print),
                            onPressed: () async {
                              final pdfData = await _generatePdf(invoiceData);
                              await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async =>
                                      pdfData);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
