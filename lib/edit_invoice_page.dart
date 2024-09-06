// ignore_for_file: prefer_final_fields, library_private_types_in_public_api

import 'package:flutter/material.dart';

class EditInvoicePage extends StatefulWidget {
  const EditInvoicePage({super.key});

  @override
  _EditInvoicePageState createState() => _EditInvoicePageState();
}

class _EditInvoicePageState extends State<EditInvoicePage> {
  String? _selectedClient;
  String? _selectedUnit;
  String? _selectedGroupBill;

  List<String> _clients = ['Client A', 'Client B', 'Client C'];
  List<String> _units = ['Unit 1', 'Unit 2', 'Unit 3'];
  List<String> _groupBills = ['Group Bill 1', 'Group Bill 2', 'Group Bill 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Invoice'),
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
                });
              },
              decoration: const InputDecoration(
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
              decoration: const InputDecoration(
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
              decoration: const InputDecoration(
                labelText: 'Group Bill',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to show invoice page
                  },
                  child: const Text('Show'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Reset form
                    setState(() {
                      _selectedClient = null;
                      _selectedUnit = null;
                      _selectedGroupBill = null;
                    });
                  },
                  child: const Text('Reset'),
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
  runApp(const MaterialApp(
    home: EditInvoicePage(),
  ));
}
