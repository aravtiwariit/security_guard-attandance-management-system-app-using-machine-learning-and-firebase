// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lakshya/invoice.dart';

class GenerateInvoicePage extends StatefulWidget {
  const GenerateInvoicePage({super.key});

  @override
  _GenerateInvoicePageState createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  String? _selectedClient;
  String? _selectedUnit;
  String? _selectedGroupBill;

  List<String> _clients = [];
  List<String> _units = [];
  List<String> _groupBills = ['Group Bill 1', 'Group Bill 2', 'Group Bill 3'];
  @override
  void initState() {
    super.initState();

    _fetchClients();
  }

  Future<void> _fetchClients() async {
    QuerySnapshot clientsSnapshot =
        await FirebaseFirestore.instance.collection('clients').get();
    setState(() {
      _clients = clientsSnapshot.docs
          .map((doc) => doc['Client Name'] as String)
          .toList();
      _selectedClient = null;
    });
  }

  Future<void> _fetchUnits(String client) async {
    QuerySnapshot clientsSnapshot = await FirebaseFirestore.instance
        .collection('units')
        .where('client', isEqualTo: client)
        .get();
    setState(() {
      _units = clientsSnapshot.docs
          .map((doc) => doc['Unit Name'] as String)
          .toList();
      _selectedUnit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedClient,
              items: _clients.map((String client) {
                return DropdownMenuItem(
                  value: client,
                  child: Text(client),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClient = value;
                  _fetchUnits(_selectedClient!);
                });
              },
              decoration: InputDecoration(
                labelText: 'Client',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              items: _units.map((String unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Unit',
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedGroupBill,
              items: _groupBills.map((String groupBill) {
                return DropdownMenuItem(
                  value: groupBill,
                  child: Text(groupBill),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGroupBill = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Group Bill',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_selectedClient != null && _selectedUnit != null) {
                      // Navigate to invoice page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SampleBillScreen(
                              client: _selectedClient!,
                              unit: _selectedUnit ?? ""),
                          //  AreaOfficerLocationPage(email:email,role:role),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Select all fields ')),
                      );
                    }
                  },
                  child: Text('Go To Invoice'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Reset form
                    setState(() {
                      _selectedClient = null;
                      _selectedUnit = null;
                      _selectedGroupBill = null;
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GenerateInvoicePage(),
  ));
}
