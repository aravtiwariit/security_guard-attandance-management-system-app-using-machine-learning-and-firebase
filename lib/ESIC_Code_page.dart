// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class ESICCodePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ESICCodePageState createState() => _ESICCodePageState();
}

class _ESICCodePageState extends State<ESICCodePage> {
  final TextEditingController _stateNameController = TextEditingController();
  final TextEditingController _esicRegionController = TextEditingController();
  final TextEditingController _esicCodeController = TextEditingController();
  String? _selectedCountry;
  List<String> _countries = [];
  List<DocumentSnapshot> _esicCodes = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchESICCodes();
  }

  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchESICCodes() async {
    QuerySnapshot esicCodesSnapshot =
        await FirebaseFirestore.instance.collection('esic_codes').get();
    setState(() {
      _esicCodes = esicCodesSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESIC Code'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
              },
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              hint: const Text('Select Country'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _stateNameController,
              decoration: const InputDecoration(labelText: 'State Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _esicRegionController,
              decoration: const InputDecoration(labelText: 'ESIC Region'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _esicCodeController,
              decoration: const InputDecoration(labelText: 'ESIC Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveESICCode,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'ESIC Codes List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _esicCodes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('State Name: ${_esicCodes[index]['State Name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ESIC Region: ${_esicCodes[index]['ESIC Region']}'),
                      Text('ESIC Code: ${_esicCodes[index]['ESIC Code']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editESICCode(_esicCodes[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteESICCode(_esicCodes[index].id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveESICCode() {
    String stateName = _stateNameController.text.trim();
    String esicRegion = _esicRegionController.text.trim();
    String esicCode = _esicCodeController.text.trim();
    if (_selectedCountry != null &&
        stateName.isNotEmpty &&
        esicRegion.isNotEmpty &&
        esicCode.isNotEmpty) {
      FirebaseFirestore.instance.collection('esic_codes').add({
        'Country Name': _selectedCountry,
        'State Name': stateName,
        'ESIC Region': esicRegion,
        'ESIC Code': esicCode,
      }).then((value) {
        _fetchESICCodes();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ESIC Code saved successfully.'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save ESIC Code: $error'),
          backgroundColor: Colors.red,
        ));
      });
      _stateNameController.clear();
      _esicRegionController.clear();
      _esicCodeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editESICCode(DocumentSnapshot esicCode) {
    String stateName = esicCode['State Name'];
    String esicRegion = esicCode['ESIC Region'];
    String currentESICCode = esicCode['ESIC Code'];
    _stateNameController.text = stateName;
    _esicRegionController.text = esicRegion;
    _esicCodeController.text = currentESICCode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit ESIC Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _stateNameController,
                decoration: const InputDecoration(labelText: 'State Name'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _esicRegionController,
                decoration: const InputDecoration(labelText: 'ESIC Region'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _esicCodeController,
                decoration: const InputDecoration(labelText: 'ESIC Code'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateESICCode(esicCode.id);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteESICCode(String esicCodeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ESIC Code'),
          content:
              const Text('Are you sure you want to delete this ESIC Code?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('esic_codes')
                    .doc(esicCodeId)
                    .delete();
                _fetchESICCodes(); // Refresh the ESIC codes list after deletion
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateESICCode(String esicCodeId) {
    String updatedStateName = _stateNameController.text.trim();
    String updatedESICRegion = _esicRegionController.text.trim();
    String updatedESICCode = _esicCodeController.text.trim();

    FirebaseFirestore.instance.collection('esic_codes').doc(esicCodeId).update({
      'State Name': updatedStateName,
      'ESIC Region': updatedESICRegion,
      'ESIC Code': updatedESICCode,
    }).then((value) {
      _fetchESICCodes(); // Refresh the ESIC codes list after updating
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ESIC Code updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update ESIC Code: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: ESICCodePage(),
  ));
}
