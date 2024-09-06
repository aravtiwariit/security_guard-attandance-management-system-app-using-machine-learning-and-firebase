// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PFCodePage extends StatefulWidget {
  const PFCodePage({super.key});

  @override
  _PFCodePageState createState() => _PFCodePageState();
}

class _PFCodePageState extends State<PFCodePage> {
  final TextEditingController _stateNameController = TextEditingController();
  final TextEditingController _pfCodeController = TextEditingController();
  String? _selectedCountry;
  List<String> _countries = [];
  List<String> _states = [];
  String? _selectedState;
  List<DocumentSnapshot> _pfCodes = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchPFCodes();
  }

  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchStates(String country) async {
    QuerySnapshot statesSnapshot = await FirebaseFirestore.instance
        .collection('states')
        .where('Country Name', isEqualTo: country)
        .get();
    setState(() {
      _states = statesSnapshot.docs
          .map((doc) => doc['State Name'] as String)
          .toList();
      _selectedState = null; // Reset selected state when states change
    });
  }

  Future<void> _fetchPFCodes() async {
    QuerySnapshot pfCodesSnapshot =
        await FirebaseFirestore.instance.collection('pf_codes').get();
    setState(() {
      _pfCodes = pfCodesSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PF Code'),
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
                  _fetchStates(newValue!);
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
            DropdownButtonFormField<String>(
              value: _selectedState,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedState = newValue;
                });
              },
              items: _states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              hint: const Text('Select State'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _pfCodeController,
              decoration: const InputDecoration(labelText: 'PF Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePFCode,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'PF Codes List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _pfCodes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('State Name: ${_pfCodes[index]['State Name']}'),
                  subtitle: Text('PF Code: ${_pfCodes[index]['PF Code']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPFCode(_pfCodes[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePFCode(_pfCodes[index].id),
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

  void _savePFCode() {
    String stateName = _stateNameController.text.trim();
    String pfCode = _pfCodeController.text.trim();
    if (_selectedCountry != null &&
        _selectedState != null &&
        pfCode.isNotEmpty) {
      FirebaseFirestore.instance.collection('pf_codes').add({
        'Country Name': _selectedCountry,
        'State Name': _selectedState,
        'PF Code': pfCode,
      }).then((value) {
        _fetchPFCodes();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('PF Code saved successfully.'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save PF Code: $error'),
          backgroundColor: Colors.red,
        ));
      });
      _stateNameController.clear();
      _pfCodeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editPFCode(DocumentSnapshot pfCode) {
    String stateName = pfCode['State Name'];
    String currentPFCode = pfCode['PF Code'];
    _stateNameController.text = stateName;
    _pfCodeController.text = currentPFCode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit PF Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _stateNameController,
                decoration: const InputDecoration(labelText: 'State Name'),
              ),
              TextFormField(
                controller: _pfCodeController,
                decoration: const InputDecoration(labelText: 'PF Code'),
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
                _updatePFCode(pfCode.id, _stateNameController.text,
                    _pfCodeController.text);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePFCode(String pfCodeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete PF Code'),
          content: const Text('Are you sure you want to delete this PF code?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('pf_codes')
                    .doc(pfCodeId)
                    .delete();
                _fetchPFCodes();
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

  void _updatePFCode(String pfCodeId, String newStateName, String newPFCode) {
    FirebaseFirestore.instance.collection('pf_codes').doc(pfCodeId).update({
      'State Name': newStateName,
      'PF Code': newPFCode,
    }).then((value) {
      _fetchPFCodes();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('PF Code updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update PF Code: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: PFCodePage(),
  ));
}
