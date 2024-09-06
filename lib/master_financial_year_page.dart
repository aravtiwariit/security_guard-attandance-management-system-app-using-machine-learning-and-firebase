// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MasterFinancialYearPage extends StatefulWidget {
  @override
  _MasterFinancialYearPageState createState() =>
      _MasterFinancialYearPageState();
}

class _MasterFinancialYearPageState extends State<MasterFinancialYearPage> {
  TextEditingController _financialYearController = TextEditingController();
  String _selectedIsActive = 'Active';
  List<Map<String, String>> _financialYearDataList = [];

  @override
  void dispose() {
    _financialYearController.dispose();
    super.dispose();
  }

  void _saveData() {
    FirebaseFirestore.instance.collection('financial_years').add({
      'Financial Year': _financialYearController.text,
      'Is Active Year': _selectedIsActive,
    }).then((value) {
      print("Financial Year Added");
      _financialYearController.clear();
      _selectedIsActive = 'Active'; // Reset dropdown to default value
    }).catchError((error) {
      print("Failed to add financial year: $error");
    });
  }

  void _editData(int index) {
    Map<String, String> currentData = _financialYearDataList[index];
    _financialYearController.text = currentData['Financial Year']!;
    _selectedIsActive = currentData['Is Active Year']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _financialYearController,
                decoration: InputDecoration(labelText: 'Financial Year'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedIsActive,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIsActive = newValue!;
                  });
                },
                items: <String>['Active', 'Deactive']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _financialYearDataList[index] = {
                    'Financial Year': _financialYearController.text,
                    'Is Active Year': _selectedIsActive,
                  };
                  _financialYearController.clear();
                  _selectedIsActive =
                      'Active'; // Reset dropdown to default value
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteData(int index) {
    setState(() {
      _financialYearDataList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Financial Year'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _financialYearController,
              decoration: InputDecoration(labelText: 'Financial Year'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedIsActive,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIsActive = newValue!;
                });
              },
              items: <String>['Active', 'Deactive']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Financial Year Data:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('financial_years')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Financial Year: ${data['Financial Year']}'),
                            Text('Is Active Year: ${data['Is Active Year']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editData(document.id as int),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteData(document.id as int),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: MasterFinancialYearPage(),
    ));
  }
}
