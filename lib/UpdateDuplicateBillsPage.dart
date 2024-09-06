// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class UpdateDuplicateBillsPage extends StatefulWidget {
  @override
  _UpdateDuplicateBillsPageState createState() =>
      _UpdateDuplicateBillsPageState();
}

class _UpdateDuplicateBillsPageState extends State<UpdateDuplicateBillsPage> {
  String _selectedMonth = '';
  String _selectedYear = '';
  TextEditingController _billNoController = TextEditingController();
  TextEditingController _clientController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> _years = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013'
  ];

  @override
  void dispose() {
    _billNoController.dispose();
    _clientController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Duplicate Bills'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField(
              value: _selectedMonth.isNotEmpty ? _selectedMonth : null,
              items: _months.map((String month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Month',
              ),
            ),
            TextFormField(
              controller: _billNoController,
              decoration: InputDecoration(labelText: 'Bill No'),
            ),
            TextFormField(
              controller: _clientController,
              decoration: InputDecoration(labelText: 'Client'),
            ),
            TextFormField(
              controller: _unitController,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
            DropdownButtonFormField(
              value: _selectedYear.isNotEmpty ? _selectedYear : null,
              items: _years.map((String year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Year',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your update logic here
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UpdateDuplicateBillsPage(),
  ));
}
