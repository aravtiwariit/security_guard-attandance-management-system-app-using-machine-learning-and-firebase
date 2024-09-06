// ignore_for_file: library_private_types_in_public_api, unused_field, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class BillRateBreakupPage extends StatefulWidget {
  @override
  _BillRateBreakupPageState createState() => _BillRateBreakupPageState();
}

class _BillRateBreakupPageState extends State<BillRateBreakupPage> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBranch;
  String? _selectedUnit;
  String? _selectedShift;
  String? _selectedService;
  String? _selectedClient;
  double? _basicAmount;
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _nosController = TextEditingController();

  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _branches = [];
  List<String> _units = [];
  List<String> _clients = [];
  List<String> _shifts = [];
  List<String> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchShifts();
    _fetchServices();
  }

  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchShifts() async {
    QuerySnapshot shiftsSnapshot =
        await FirebaseFirestore.instance.collection('shifts').get();
    setState(() {
      _shifts = shiftsSnapshot.docs
          .map((doc) => doc['Shift Name'] as String)
          .toList();
    });
  }

  Future<void> _fetchServices() async {
    QuerySnapshot servicesSnapshot =
        await FirebaseFirestore.instance.collection('services').get();
    setState(() {
      _services = servicesSnapshot.docs
          .map((doc) => doc['Post Name'] as String)
          .toList();
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
      _selectedState = null;
      _selectedDistrict = null;
      _selectedBranch = null;
      _selectedClient = null;
      _selectedUnit = null;
    });
  }

  Future<void> _fetchDistricts(String country, String state) async {
    QuerySnapshot districtsSnapshot = await FirebaseFirestore.instance
        .collection('districts')
        .where('country', isEqualTo: country)
        .where('state', isEqualTo: state)
        .get();
    setState(() {
      _districts =
          districtsSnapshot.docs.map((doc) => doc['name'] as String).toList();
      _selectedDistrict = null;
      _selectedBranch = null;
      _selectedClient = null;
      _selectedUnit = null;
    });
  }

  Future<void> _fetchBranch(
      String country, String state, String district) async {
    QuerySnapshot branchesSnapshot = await FirebaseFirestore.instance
        .collection('branches')
        .where('Country Name', isEqualTo: country)
        .where('State Name', isEqualTo: state)
        .where('District Name', isEqualTo: district)
        .get();
    setState(() {
      _branches = branchesSnapshot.docs
          .map((doc) => doc['Branch Name'] as String)
          .toList();
      _selectedBranch = null;
      _selectedClient = null;
      _selectedUnit = null;
    });
  }

  Future<void> _fetchClients(
      String country, String state, String district, String branch) async {
    QuerySnapshot clientsSnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .where('Country', isEqualTo: country)
        .where('State', isEqualTo: state)
        .where('District', isEqualTo: district)
        .where('Branch', isEqualTo: branch)
        .get();
    setState(() {
      _clients = clientsSnapshot.docs
          .map((doc) => doc['Client Name'] as String)
          .toList();
      _selectedClient = null;
      _selectedUnit = null;
    });
  }

  Future<void> _fetchUnits(String client) async {
    QuerySnapshot unitsSnapshot = await FirebaseFirestore.instance
        .collection('units')
        .where('client', isEqualTo: client)
        .get();
    setState(() {
      _units =
          unitsSnapshot.docs.map((doc) => doc['Unit Name'] as String).toList();
      _selectedUnit = null;
    });
  }

  void _save() {
    FirebaseFirestore.instance.collection('bill_rate').add({
      'country': _selectedCountry,
      'state': _selectedState,
      'district': _selectedDistrict,
      'branch': _selectedBranch,
      'client': _selectedClient,
      'unit': _selectedUnit,
      'shift': _selectedShift,
      'service': _selectedService,
      'basic': _billController.text,
      'nos': _nosController.text,
    }).then((_) {
      _showSuccessMessage();
    }).catchError((error) {
      _showErrorMessage('Failed to add data. Please try again.');
    });
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data added successfully')),
    );
  }

  void _showErrorMessage(String err) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err)),
    );
  }

  void _editData(String docId, Map<String, dynamic> currentData) {
    _selectedService = currentData['service'];
    _billController.text = currentData['basic'];
    _selectedClient = currentData['client'];
    _selectedService = currentData['service'];
    _selectedUnit = currentData['unit'];
    _nosController.text = currentData['nos'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<void>(
          future: _fetchUnits(_selectedClient!), // Wait for fetching units
          builder: (context, snapshot) {
            return AlertDialog(
              title: Text('Edit Data'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedClient,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedClient = newValue;
                        _fetchUnits(_selectedClient!);
                      });
                    },
                    items: _clients.map((client) {
                      return DropdownMenuItem(
                        value: client,
                        child: Text(client),
                      );
                    }).toList(),
                    hint: Text('Select Client'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUnit = newValue;
                      });
                    },
                    items: _units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    hint: Text('Select Unit'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedService,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedService = newValue;
                      });
                    },
                    items: _services.map((ser) {
                      return DropdownMenuItem(
                        value: ser,
                        child: Text(ser),
                      );
                    }).toList(),
                    hint: Text('Select Services'),
                  ),
                  TextFormField(
                    controller: _billController,
                    decoration: InputDecoration(labelText: 'Enter Basic:'),
                  ),
                  TextFormField(
                    controller: _nosController,
                    decoration: InputDecoration(labelText: 'Enter Nos'),
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
                    if (_selectedUnit == null ||
                        _selectedService == null ||
                        _billController.text.isEmpty ||
                        _nosController.text.isEmpty) {
                      _showErrorMessage('Fill in all fields');
                    } else {
                      FirebaseFirestore.instance
                          .collection('bill_rate')
                          .doc(docId)
                          .update({
                        'client': _selectedClient,
                        'unit': _selectedUnit,
                        'service': _selectedService,
                        'basic': _billController.text,
                        'nos': _nosController.text,
                      }).then((value) {
                        _billController.clear();
                        _nosController.clear();
                        setState(() {
                          _selectedCountry = null;
                          _selectedState = null;
                          _selectedDistrict = null;
                          _selectedBranch = null;
                          _selectedClient = null;
                          _selectedUnit = null;
                          _selectedShift = null;
                          _selectedService = null;
                        });
                        Navigator.pop(context);
                      }).catchError((error) {
                        _showErrorMessage(
                            'Failed to edit data. Please try again.');
                      });
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteData(String docId) {
    // Delete the document from Firestore
    FirebaseFirestore.instance
        .collection('bill_rate')
        .doc(docId)
        .delete()
        .then((value) {
      print("record bill rate  Deleted");
    }).catchError((error) {
      print("Failed to delete bill rate: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bill Rate Breakup Page')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                    _fetchStates(_selectedCountry!);
                  });
                },
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Country'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedState,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                    _fetchDistricts(_selectedCountry!, _selectedState!);
                  });
                },
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select State'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                    _fetchBranch(
                        _selectedCountry!, _selectedState!, _selectedDistrict!);
                  });
                },
                items: _districts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select District'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedBranch,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBranch = newValue;
                    _fetchClients(_selectedCountry!, _selectedState!,
                        _selectedDistrict!, _selectedBranch!);
                  });
                },
                items: _branches.map((branch) {
                  return DropdownMenuItem(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Branch'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedClient,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClient = newValue;
                    _fetchUnits(_selectedClient!);
                  });
                },
                items: _clients.map((client) {
                  return DropdownMenuItem(
                    value: client,
                    child: Text(client),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Client'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                },
                items: _units.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Unit'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedShift,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedShift = newValue;
                  });
                },
                items: _shifts.map((shift) {
                  return DropdownMenuItem(
                    value: shift,
                    child: Text(shift),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Shift'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedService,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
                items: _services.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Service'),
              ),
              TextFormField(
                controller: _billController,
                decoration: InputDecoration(labelText: 'Enter Basic:'),
              ),
              TextFormField(
                controller: _nosController,
                decoration: InputDecoration(labelText: 'Enter Nos'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text('Save'),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bill_rate')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text('Post Name: ${data['service']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Client Name: ${data['client']}'),
                            Text('Bill Rate: ${data['basic']}'),
                            Text('Nos: ${data['nos']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editData(document.id, data),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteData(document.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
