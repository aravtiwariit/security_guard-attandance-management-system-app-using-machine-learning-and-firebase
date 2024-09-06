// ignore_for_file: prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';

class ReportUnitPage extends StatefulWidget {
  const ReportUnitPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportUnitPageState createState() => _ReportUnitPageState();
}

class _ReportUnitPageState extends State<ReportUnitPage> {
  String _selectedStatus = 'Hide';

  List<String> _statusOptions = ['Hide', 'Show'];

  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  TextEditingController _fieldAreaController = TextEditingController();
  TextEditingController _clientController = TextEditingController();
  TextEditingController _agreementDateController = TextEditingController();
  TextEditingController _insertDateFromController = TextEditingController();
  TextEditingController _insertDateToController = TextEditingController();

  void _showReport() {
    // Implement logic to show report
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Unit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            const SizedBox(height: 10),

            // State
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 10),

            // District
            TextFormField(
              controller: _districtController,
              decoration: const InputDecoration(labelText: 'District'),
            ),
            const SizedBox(height: 10),

            // Branch
            TextFormField(
              controller: _branchController,
              decoration: const InputDecoration(labelText: 'Branch'),
            ),
            const SizedBox(height: 10),

            // Field Area
            TextFormField(
              controller: _fieldAreaController,
              decoration: const InputDecoration(labelText: 'Field Area'),
            ),
            const SizedBox(height: 10),

            // Client
            TextFormField(
              controller: _clientController,
              decoration: const InputDecoration(labelText: 'Client'),
            ),
            const SizedBox(height: 10),

            // Agreement Date
            TextFormField(
              controller: _agreementDateController,
              decoration: const InputDecoration(labelText: 'Agreement Date'),
            ),
            const SizedBox(height: 10),

            // Insert Date From
            TextFormField(
              controller: _insertDateFromController,
              decoration: const InputDecoration(labelText: 'Insert Date From'),
            ),
            const SizedBox(height: 10),

            // Insert Date To
            TextFormField(
              controller: _insertDateToController,
              decoration: const InputDecoration(labelText: 'Insert Date To'),
            ),
            const SizedBox(height: 10),

            // Status Dropdown
            DropdownButtonFormField(
              value: _selectedStatus,
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue.toString();
                });
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 20),

            // Show Button
            ElevatedButton(
              onPressed: _showReport,
              child: const Text(
                'Show',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReportUnitPage(),
  ));
}
