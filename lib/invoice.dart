// ignore_for_file: unused_import

import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// class Item {
//   double rate;
//   double monthDays;
//   double duty;
//   double amount;

//   Item({this.rate = 0.0, this.monthDays = 0.0, this.duty = 0.0, this.amount = 0.0});
// }

class SampleBillScreen extends StatefulWidget {
  final String client;
  final String unit;

  const SampleBillScreen({Key? key, required this.client, required this.unit})
      : super(key: key);

  @override
  _SampleBillScreenState createState() => _SampleBillScreenState();
}

class _SampleBillScreenState extends State<SampleBillScreen> {
  // List<Item> _items = [
  //   Item(rate: 10.0, monthDays: 30.0, duty: 0.0, amount: 0.0),
  //   Item(rate: 15.0, monthDays: 30.0, duty: 0.0, amount: 0.0),
  //   Item(rate: 20.0, monthDays: 30.0, duty: 0.0, amount: 0.0),
  // ];
  String? _selectedCBank;
  List<ServiceRow> _serviceRows = [];
  List<String> _availableServices = [];
  List<String> _cbanks = [];
  TextEditingController _cgstController = TextEditingController();
  TextEditingController _igstController = TextEditingController();
  TextEditingController _sgstController = TextEditingController();
  TextEditingController _tdsController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _ifsController = TextEditingController();
  TextEditingController _aCNoController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchServicesOfClient();
    _fetchCommBanks();
  }

  Future<void> _fetchCommBanks() async {
    QuerySnapshot comBanksSnapshot =
        await FirebaseFirestore.instance.collection('company_banks').get();
    setState(() {
      _cbanks = comBanksSnapshot.docs
          .map((doc) => doc['Bank Name'] as String)
          .toList();
    });
  }

  Future<void> _fetchServicesOfClient() async {
    try {
      QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
          .collection('bill_rate')
          .where('client', isEqualTo: widget.client)
          .where('unit', isEqualTo: widget.unit)
          .get();

      List<String> services =
          serviceSnapshot.docs.map((doc) => doc['service'] as String).toList();

      setState(() {
        _availableServices = services;
        _serviceRows = serviceSnapshot.docs.map((doc) {
          String service = doc['service'] as String;
          String basic = doc['basic'] as String;
          String nos = doc['nos'] as String;
          return ServiceRow(
            service: service,
            basic: basic,
            nos: nos,
            monthoddaysController: TextEditingController(),
            dutyController: TextEditingController(),
            amountController: TextEditingController(),
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching services: $e");
      // Handle error appropriately here
    }
  }

  @override
  void dispose() {
    _cgstController.dispose();
    _sgstController.dispose();
    _tdsController.dispose();
    _igstController.dispose();
    _serviceRows.forEach((row) {
      row.monthoddaysController.dispose();
      row.dutyController.dispose();
      row.amountController.dispose();
      _startDateController.dispose();
      _endDateController.dispose();
    });
    super.dispose();
  }

  double _calculateTotal() {
    double totalAmount = 0.0;
    // _items.forEach((item) {
    //   totalAmount += item.amount;
    // });
    _serviceRows.forEach((row) {
      totalAmount += double.tryParse(row.amountController.text) ?? 0.0;
    });
    return totalAmount;
  }

  double _calculateCGST(double totalAmount, double cgstRate) {
    return totalAmount * cgstRate / 100;
  }

  double _calculateIGST(double totalAmount, double igstRate) {
    return totalAmount * igstRate / 100;
  }

  double _calculateSGST(double totalAmount, double sgstRate) {
    return totalAmount * sgstRate / 100;
  }

  double _calculateTDS(double totalAmount, double tdsRate) {
    return totalAmount * tdsRate / 100;
  }

  void _addServiceRow(String selectedService) {
    setState(() {
      _serviceRows.add(ServiceRow(
        service: selectedService,
        basic: '0.0',
        nos: '0', // You can initialize with default values as needed
        monthoddaysController: TextEditingController(),
        dutyController: TextEditingController(),
        amountController: TextEditingController(),
      ));
    });
  }

  String _generateInvoiceNumber() {
    final now = DateTime.now();
    final year = DateFormat('yyyy').format(now);
    final random = Random();
    final number = (random.nextInt(9000) + 1000).toString();
    return 'MH/LSF/$year/$number';
  }

  Future<void> _save() async {
    try {
      // Create a list of service data maps
      List<Map<String, dynamic>> servicesData = _serviceRows.map((serviceRow) {
        return {
          'service': serviceRow.service,
          'basic': serviceRow.basic,
          'nos': serviceRow.nosController.text,
          'monthDays': serviceRow.monthoddaysController.text,
          'duty': serviceRow.dutyController.text,
          'amount': serviceRow.amountController.text,
        };
      }).toList();

      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

      // Create a map for the bill data
      Map<String, dynamic> billData = {
        'Invoice Number': _generateInvoiceNumber(),
        'client': widget.client,
        'unit': widget.unit,
        'cgst': _cgstController.text,
        'sgst': _sgstController.text,
        'igst': _igstController.text,
        'tds': _tdsController.text,
        'totalAmount': _calculateTotal(),
        'cgstAmount': _calculateCGST(
            _calculateTotal(), double.tryParse(_cgstController.text) ?? 0.0),
        'sgstAmount': _calculateSGST(
            _calculateTotal(), double.tryParse(_sgstController.text) ?? 0.0),
        'igstAmount': _calculateIGST(
            _calculateTotal(), double.tryParse(_igstController.text) ?? 0.0),
        'tdsAmount': _calculateTDS(
            _calculateTotal(), double.tryParse(_tdsController.text) ?? 0.0),
        'netAmount': _calculateTotal() +
            _calculateCGST(_calculateTotal(),
                double.tryParse(_cgstController.text) ?? 0.0) +
            _calculateSGST(_calculateTotal(),
                double.tryParse(_sgstController.text) ?? 0.0) -
            _calculateTDS(
                _calculateTotal(), double.tryParse(_tdsController.text) ?? 0.0),
        'invoice date': formattedDate,
        'bankName': _bankNameController.text,
        'ifscCode': _ifsController.text,
        'accountNo': _aCNoController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'services': servicesData,
      };

      // Store the bill data in the Firestore collection
      await FirebaseFirestore.instance.collection('bills').add(billData);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill data saved successfully')),
      );

      //  _printPdf(billData);
    } catch (e) {
      print("Error saving bill data: $e");
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save bill data')),
      );
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
    _updateMonthDays();
  }

  void _updateMonthDays() {
    if (_startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty) {
      DateTime startDate =
          DateFormat('dd-MM-yyyy').parse(_startDateController.text);
      DateTime endDate =
          DateFormat('dd-MM-yyyy').parse(_endDateController.text);
      int daysDifference = endDate.difference(startDate).inDays +
          1; // +1 to include the end date

      setState(() {
        _serviceRows.forEach((row) {
          row.monthoddaysController.text = daysDifference.toString();
        });
      });
    }
  }

  Future<void> _changeValue(String? bank) async {
    if (bank == null || bank.isEmpty) {
      // Handle the case where bank is null or empty
      setState(() {
        _bankNameController.text = 'Invalid bank name';
        _ifsController.text = '';
        _aCNoController.text = '';
      });
      return;
    }

    try {
      QuerySnapshot cbankkSnapshot = await FirebaseFirestore.instance
          .collection('company_banks')
          .where('Bank Name', isEqualTo: bank)
          .get();

      if (cbankkSnapshot.docs.isNotEmpty) {
        String service = cbankkSnapshot.docs.first['Bank Name'];
        String ifs = cbankkSnapshot.docs.first['IFSC Code'];
        String ack = cbankkSnapshot.docs.first['Account No'];

        setState(() {
          _bankNameController.text = service;
          _ifsController.text = ifs;
          _aCNoController.text = ack;
        });
      } else {
        // Handle case where no documents match the query
        setState(() {
          _bankNameController.text = 'No matching bank found';
          _ifsController.text = '';
          _aCNoController.text = '';
        });
      }
    } catch (e) {
      print("Error fetching bank details: $e");
      // Handle error appropriately here
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = _calculateTotal();
    double cgstRate = _cgstController.text.isNotEmpty
        ? double.parse(_cgstController.text)
        : 0.0;
    double sgstRate = _sgstController.text.isNotEmpty
        ? double.parse(_sgstController.text)
        : 0.0;
    double igstRate = _igstController.text.isNotEmpty
        ? double.parse(_igstController.text)
        : 0.0;
    double tdsRate = _tdsController.text.isNotEmpty
        ? double.parse(_tdsController.text)
        : 0.0;

    double cgstAmount = _calculateCGST(totalAmount, cgstRate);
    double sgstAmount = _calculateSGST(totalAmount, sgstRate);
    double igstAmount = _calculateSGST(totalAmount, igstRate);
    double tdsAmount = _calculateTDS(totalAmount, tdsRate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Bill'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Invoice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Client: ${widget.client}'),
            Text('Unit: ${widget.unit}'),
            SizedBox(height: 10),
            SizedBox(height: 20),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date'),
              readOnly: true,
              onTap: () => _selectDate(context, _startDateController),
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
              readOnly: true,
              onTap: () => _selectDate(context, _endDateController),
            ),
            SizedBox(height: 20),

            //dropdown for service
            DropdownButtonFormField<String>(
              value: null,
              items: _availableServices.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              hint: Text('Select a service'),
              onChanged: (String? selectedService) {
                if (selectedService != null) {
                  _addServiceRow(selectedService);
                }
              },
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Service')),
                  DataColumn(label: Text('Basic')),
                  DataColumn(label: Text('Number of Person(nos)')),
                  DataColumn(label: Text('Month/Days')),
                  DataColumn(label: Text('Duty')),
                  DataColumn(label: Text('Amount')),
                ],
                rows: _serviceRows.map((serviceRow) {
                  return DataRow(cells: [
                    DataCell(Text(serviceRow.service)),
                    DataCell(Text(serviceRow.basic)),
                    DataCell(TextField(
                      controller: serviceRow.nosController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // double duty = double.tryParse(value) ?? 0.0;
                          // double monthoddays = double.tryParse(serviceRow.monthoddaysController.text) ?? 0.0;
                          // double basic = double.tryParse(serviceRow.basic) ?? 0.0;
                          // serviceRow.amountController.text = ((basic / monthoddays) * duty).toStringAsFixed(0);
                        });
                      },
                    )),
                    DataCell(TextField(
                      controller: serviceRow.monthoddaysController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (value) {
                        setState(() {
                          double monthoddays = double.tryParse(value) ?? 0.0;
                          double duty =
                              double.tryParse(serviceRow.dutyController.text) ??
                                  0.0;
                          double basic =
                              double.tryParse(serviceRow.basic) ?? 0.0;
                          serviceRow.amountController.text =
                              ((basic / monthoddays) * duty).toStringAsFixed(2);
                        });
                      },
                    )),
                    DataCell(TextField(
                      controller: serviceRow.dutyController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (value) {
                        setState(() {
                          double duty = double.tryParse(value) ?? 0.0;
                          String monthoddaysText =
                              serviceRow.monthoddaysController.text;

                          if (monthoddaysText.isNotEmpty) {
                            double monthoddays =
                                double.tryParse(monthoddaysText) ?? 0.0;
                            double basic =
                                double.tryParse(serviceRow.basic) ?? 0.0;
                            serviceRow.amountController.text =
                                ((basic / monthoddays) * duty)
                                    .toStringAsFixed(0);
                          }
                        });
                      },
                    )),
                    DataCell(TextField(
                      controller: serviceRow.amountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                    )),
                  ]);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cgstController,
              decoration: InputDecoration(labelText: 'CGST (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _sgstController,
              decoration: InputDecoration(labelText: 'SGST (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _igstController,
              decoration: InputDecoration(labelText: 'IGST (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tdsController,
              decoration: InputDecoration(labelText: 'TDS (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),

            Text(
              'Total Amount: \₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'CGST (${cgstRate.toStringAsFixed(2)}%): \₹${cgstAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'SGST (${sgstRate.toStringAsFixed(2)}%): \₹${sgstAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'IGST (${igstRate.toStringAsFixed(2)}%): \₹${igstAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'TDS (${tdsRate.toStringAsFixed(2)}%): \₹${tdsAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Net Amount: \₹${(totalAmount + double.parse(cgstAmount.toStringAsFixed(0)).toInt() + double.parse(sgstAmount.toStringAsFixed(0)).toInt() + double.parse(igstAmount.toStringAsFixed(0)).toInt() - double.parse(tdsAmount.toStringAsFixed(0)).toInt()).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            //dropdown for service
            DropdownButtonFormField<String>(
              value: _selectedCBank,
              items: _cbanks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              hint: Text('Select a service'),
              onChanged: (String? selectedBank) {
                if (selectedBank != null) {
                  setState(() {
                    _selectedCBank = selectedBank;
                    _changeValue(_selectedCBank);
                  });
                }
              },
            ),

            TextField(
              controller: _bankNameController,
              decoration: InputDecoration(labelText: 'Bank name'),
            ),
            TextField(
              controller: _ifsController,
              decoration: InputDecoration(labelText: 'IFSC Code'),
            ),
            TextField(
              controller: _aCNoController,
              decoration: InputDecoration(labelText: 'Account No.'),
            ),
            ElevatedButton(
              onPressed: _save,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceRow {
  final String service;
  final String basic;
  final String nos;
  final TextEditingController monthoddaysController;
  final TextEditingController dutyController;
  final TextEditingController amountController;
  final TextEditingController nosController;

  ServiceRow({
    required this.service,
    required this.basic,
    required this.nos,
    required this.monthoddaysController,
    required this.dutyController,
    required this.amountController,
  }) : nosController = TextEditingController(text: nos);
}
