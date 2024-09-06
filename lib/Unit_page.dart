// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UnitPage extends StatefulWidget {
  @override
  _UnitPageState createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  final TextEditingController _unitNameController = TextEditingController();
  final TextEditingController _printNameToController = TextEditingController();
  final TextEditingController _addressToController = TextEditingController();
  final TextEditingController _printAddressToController =
      TextEditingController();
  final TextEditingController _billingGSTINController = TextEditingController();
  final TextEditingController _gstInController = TextEditingController();
  final TextEditingController _siteAtController = TextEditingController();
  final TextEditingController _pinCodeToController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberOfEmployeeController =
      TextEditingController();
  // final TextEditingController _workOrderDateController =
  //     TextEditingController();
  // final TextEditingController _workStartDateController =
  //     TextEditingController();
  // final TextEditingController _agrNoController = TextEditingController();
  // final TextEditingController _agrDateController = TextEditingController();
  // final TextEditingController _agrExpiryDateController =
  //     TextEditingController();
  // final TextEditingController _contactNameController = TextEditingController();

  // final TextEditingController _openingController = TextEditingController();
  // final TextEditingController _serviceTaxController = TextEditingController();
  // final TextEditingController _panNoController = TextEditingController();
  // final TextEditingController _tinNoController = TextEditingController();
  // final TextEditingController _tanNoController = TextEditingController();
  // final TextEditingController _rocDateController = TextEditingController();
  // final TextEditingController _wagesController = TextEditingController();
  // final TextEditingController _renewalController = TextEditingController();
  // final TextEditingController _controllerController = TextEditingController();

  String? _selectedClient;
  String? _selectedBranch;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedBillingToState;
  String? _selectedDistrict;
  String? _selectedBilingState;
  String? _selectedPlaceOfSupply;
  String? _selectedZone;
  String? _selectedBillType;
  String? _selectedBillGenerateType;
  String? _selectedPrintFormat;
  String? _selectedCompanyBank;
  String? _selectedPFcode;
  String? _selectedESICCode;
  String? _selectedBranch2;
  String? _selectedFieldArea;
  //checkbox values here
  // bool _isGSTApplicable = false;
  // bool _isIGSTApplicable = false;
  // bool _isUnionTerritory = false;
  // bool _isSystemBilling = false;
  // bool _isBillingInDecimal = false;
  // bool _isContractPeriodShown = false;

  List<String> _clients = [];
  List<String> _branches = [];
  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _zones = [];
  List<String> _companyBanks = [];
  List<String> _esic = [];
  List<String> _pf = [];
  List<String> _fieldarea = [];
  void initState() {
    super.initState();

    _fetchBranches();
    _fetchCountries();
    _fetchZones();
    _fetchPF();
    _fetchESIC();
    _fetchCompanyBank();
  }

  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchPF() async {
    QuerySnapshot pfSnapshot =
        await FirebaseFirestore.instance.collection('pf_codes').get();
    setState(() {
      _pf = pfSnapshot.docs.map((doc) => doc['PF Code'] as String).toList();
    });
  }

  Future<void> _fetchESIC() async {
    QuerySnapshot esicSnapshot =
        await FirebaseFirestore.instance.collection('esic_codes').get();
    setState(() {
      _esic =
          esicSnapshot.docs.map((doc) => doc['ESIC Code'] as String).toList();
    });
  }

  Future<void> _fetchCompanyBank() async {
    QuerySnapshot companyBanksSnapshot =
        await FirebaseFirestore.instance.collection('company_banks').get();
    setState(() {
      _companyBanks = companyBanksSnapshot.docs
          .map((doc) => doc['Bank Name'] as String)
          .toList();
    });
  }

  Future<void> _fetchZones() async {
    QuerySnapshot zonesSnapshot =
        await FirebaseFirestore.instance.collection('zones').get();
    setState(() {
      _zones =
          zonesSnapshot.docs.map((doc) => doc['Zone Name'] as String).toList();
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

  Future<void> _fetchDistricts(String country, String state) async {
    QuerySnapshot districtsSnapshot = await FirebaseFirestore.instance
        .collection('districts')
        .where('country', isEqualTo: country)
        .where('state', isEqualTo: state)
        .get();
    setState(() {
      _districts =
          districtsSnapshot.docs.map((doc) => doc['name'] as String).toList();
      _selectedDistrict = null; // Reset selected district when districts change
    });
  }

  Future<void> _fetchClients(String branch) async {
    QuerySnapshot clientsSnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .where('Branch', isEqualTo: branch)
        .get();
    setState(() {
      _clients = clientsSnapshot.docs
          .map((doc) => doc['Client Name'] as String)
          .toList();
      _selectedClient = null;
    });
  }

  Future<void> _fetchBranches() async {
    QuerySnapshot branchesSnapshot =
        await FirebaseFirestore.instance.collection('branches').get();
    setState(() {
      _branches = branchesSnapshot.docs
          .map((doc) => doc['Branch Name'] as String)
          .toList();
    });
  }

  Future<void> _fetchFieldArea(String branch) async {
    QuerySnapshot fieldAreaSnapshot = await FirebaseFirestore.instance
        .collection('field_areas')
        .where('Branch Name', isEqualTo: branch)
        .get();
    setState(() {
      _fieldarea = fieldAreaSnapshot.docs
          .map((doc) => doc['Field Area Name'] as String)
          .toList();
      _selectedFieldArea =
          null; // Reset selected district when districts change
    });
  }

  void _saveData() {
    // Validate email format

    FirebaseFirestore.instance.collection('units').add({
      'branch': _selectedBranch,
      'client': _selectedClient,
      'Unit Name': _unitNameController.text,
      'Print Name': _printNameToController.text,
      "address(shipped to)": _addressToController.text,
      "print address(billed to)": _printAddressToController.text,
      'country': _selectedCountry,
      'state': _selectedState,
      'Billing to state': _selectedBillingToState,
      'district': _selectedDistrict,
      'Billing GSTIN': _billingGSTINController.text,
      'billing state': _selectedBilingState,
      'GSTIN': _gstInController.text,
      'Place Of Supply': _selectedPlaceOfSupply,
      'branch Selected': _selectedBranch2,
      'Site At': _siteAtController.text,
      'area': _selectedFieldArea,
      'Pin Code': _pinCodeToController.text,
      'Phone': _phoneController.text,
      'E-Mail': _emailController.text,
      'No of employee': _numberOfEmployeeController.text,
      // 'work order no': _workOrderNoController.text,
      // 'work order date': _workOrderDateController.text,
      // 'workStartDate': _workStartDateController.text,
      // 'agrNo': _agrNoController.text,
      // 'agrDate': _agrDateController.text,
      // 'agrExpiryDate': _agrExpiryDateController.text,
      // 'contactName': _contactNameController.text,
      // // 'designation': _designationController.text,
      // 'opening': _openingController.text,
      // 'serviceTax': _serviceTaxController.text,
      // 'panNo': _panNoController.text,
      // 'tinNo': _tinNoController.text,
      // 'rocDate': _rocDateController.text,
      // 'tanNo': _tanNoController.text,
      // 'wages': _wagesController.text,
      // 'renewal': _renewalController.text,
      // 'controller': _controllerController.text,
      // 'bill type': _selectedBillType,
      // 'bill generate type': _selectedBillGenerateType,
      // 'print format': _selectedPrintFormat,
      // 'company bank': _selectedCompanyBank,
      // 'pf code': _selectedPFcode,
      // 'esic code': _selectedESICCode,
      // 'isGSTApplicable': _isGSTApplicable,
      // 'isIGSTApplicable': _isIGSTApplicable,
      // 'isUnionTerritory': _isUnionTerritory,
      // 'isSystemBilling': _isSystemBilling,
      // 'isBillingInDecimal': _isBillingInDecimal,
      // 'isContractPeriodShown': _isContractPeriodShown,
    }).then((_) {
      _showSuccessMessage();
    }).catchError((error) {
      _showErrorMessage('Failed to add data. Please try again.');
    });
  }

  bool _isValidEmail(String email) {
    // Use a regular expression to validate the email format
    // This regex is a basic example and may not cover all cases
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Branch',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedBranch,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBranch = newValue;
                    _fetchClients(newValue!);
                    // Fetch states for the selected country
                  });
                },
                items: _branches.map((branch) {
                  return DropdownMenuItem(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                hint: Text('Select Branch'),
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedClient,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClient = newValue;
                    // Fetch states for the selected country
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
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            TextField(
                controller: _unitNameController,
                decoration: InputDecoration(
                  labelText: 'Unit Name* (Shippped To)',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            TextField(
                controller: _printNameToController,
                decoration: InputDecoration(
                  labelText: 'Print Name* (Billed To)',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            TextField(
                controller: _addressToController,
                decoration: InputDecoration(
                  labelText: 'Address* (Shipped To)',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            TextField(
                controller: _printAddressToController,
                decoration: InputDecoration(
                  labelText: 'Print Address (Billed To)',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedCountry,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                    _fetchStates(
                        newValue!); // Fetch states for the selected country
                  });
                },
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                hint: Text('Select Country'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedBillingToState,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBillingToState = newValue;

                    // Fetch states for the selected country
                  });
                },
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                hint: Text('Billing To State'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedState,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                    _fetchDistricts(_selectedCountry!, newValue!);
                  });
                },
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                hint: Text('Select State'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedDistrict,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                  });
                },
                items: _districts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                hint: Text('Select District'),
              ),
            ),
            SizedBox(height: 20),
            TextField(
                controller: _billingGSTINController,
                decoration: InputDecoration(
                    labelText: 'Billing GSTIN', border: OutlineInputBorder())),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedBilingState,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBilingState = newValue;
                  });
                },
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                hint: Text('Select Billing State'),
              ),
            ),
            SizedBox(height: 20),
            TextField(
                controller: _gstInController,
                decoration: InputDecoration(
                  labelText: 'GSTIN',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedPlaceOfSupply,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlaceOfSupply = newValue;
                  });
                },
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                hint: Text('Select Place Of Supply'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedBranch2,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBranch2 = newValue;
                    _fetchFieldArea(newValue!);
                  });
                },
                items: _branches.map((branch) {
                  return DropdownMenuItem(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                hint: Text('Select Branch'),
              ),
            ),
            SizedBox(height: 20),
            TextField(
                controller: _siteAtController,
                decoration: InputDecoration(
                  labelText: 'Site At',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedFieldArea,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFieldArea = newValue;
                  });
                },
                items: _fieldarea.map((field) {
                  return DropdownMenuItem(
                    value: field,
                    child: Text(field),
                  );
                }).toList(),
                hint: Text('Select Field Area'),
              ),
            ),
            SizedBox(height: 20),
            TextField(
                controller: _pinCodeToController,
                decoration: InputDecoration(
                  labelText: 'PIN CODE',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: 'Phone', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12), // Including "+91"
                TextInputFormatter.withFunction((oldValue, newValue) {
                  // Check if the new value is empty or already starts with "+91"
                  if (newValue.text.isEmpty ||
                      newValue.text.startsWith("+91")) {
                    return newValue;
                  }

                  // Check if the new value starts with "91" and add "+" if not
                  if (newValue.text.startsWith("91")) {
                    return TextEditingValue(
                      text: "+${newValue.text}",
                      selection: TextSelection.collapsed(
                          offset: newValue.selection.end + 1),
                    );
                  }

                  // Check if the new value starts with a digit and add "+91" if not
                  if (newValue.text.isNotEmpty &&
                      (newValue.text.codeUnitAt(0) >= 48 &&
                          newValue.text.codeUnitAt(0) <= 57)) {
                    return TextEditingValue(
                      text: "+91${newValue.text}",
                      selection: TextSelection.collapsed(
                          offset: newValue.selection.end + 3),
                    );
                  }

                  // Return the new value as it is if none of the conditions match
                  return newValue;
                }),
              ],
            ),
            SizedBox(height: 20),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            TextField(
                controller: _numberOfEmployeeController,
                decoration: InputDecoration(
                  labelText: 'No. Of Employee',
                  border: OutlineInputBorder(),
                )),
            SizedBox(height: 20),
            // TextField(
            //     controller: _workOrderNoController,
            //     decoration: InputDecoration(
            //       labelText: 'Work Order No',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _workOrderDateController,
            //     decoration: InputDecoration(
            //       labelText: 'Work Order Date',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _workStartDateController,
            //     decoration: InputDecoration(
            //       labelText: 'Work Start Date',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _agrNoController,
            //     decoration: InputDecoration(
            //       labelText: 'Agr. No.',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _agrDateController,
            //     decoration: InputDecoration(
            //       labelText: 'Agr Date',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _agrExpiryDateController,
            //     decoration: InputDecoration(
            //       labelText: 'Agr Exp Date',
            //       border: OutlineInputBorder(),
            //     )),
            SizedBox(height: 20),
            // TextField(
            //     controller: _contactNameController,
            //     decoration: InputDecoration(
            //       labelText: 'Contact Name',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _designationController,
            //     decoration: InputDecoration(
            //       labelText: 'Designation',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _openingController,
            //     decoration: InputDecoration(
            //       labelText: 'Opening (\$)',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedZone,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedZone = newValue;
            //         _fetchClients(newValue!);
            //         // Fetch states for the selected country
            //       });
            //     },
            //     items: _zones.map((zone) {
            //       return DropdownMenuItem(
            //         value: zone,
            //         child: Text(zone),
            //       );
            //     }).toList(),
            //     hint: Text('Select Zone'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _serviceTaxController,
            //     decoration: InputDecoration(
            //       labelText: 'Service Tax Number',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _panNoController,
            //     decoration: InputDecoration(
            //       labelText: 'PAN Card No.',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _tinNoController,
            //     decoration: InputDecoration(
            //       labelText: 'Tin No',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _tanNoController,
            //     decoration: InputDecoration(
            //       labelText: 'Tan No.',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _rocDateController,
            //     decoration: InputDecoration(
            //       labelText: 'ROC',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _wagesController,
            //     decoration: InputDecoration(
            //       labelText: 'Wages Revision',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _renewalController,
            //     decoration: InputDecoration(
            //       labelText: 'Renewal Letter Send Date',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // TextField(
            //     controller: _controllerController,
            //     decoration: InputDecoration(
            //       labelText: 'Controller',
            //       border: OutlineInputBorder(),
            //     )),
            // SizedBox(height: 20),
            // SizedBox(height: 20),
            // SizedBox(height: 16),
            // Text(
            //   'Bill Terms',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedBillType,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedBillType = newValue;
            //       });
            //     },
            //     items: ["Muster", "Fixed"].map((btype) {
            //       return DropdownMenuItem(
            //         value: btype,
            //         child: Text(btype),
            //       );
            //     }).toList(),
            //     hint: Text('Select Bill Type'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedBillGenerateType,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedBillGenerateType = newValue;
            //       });
            //     },
            //     items: [
            //       "Invioce",
            //       "Invoice F2",
            //       "Invoice F3",
            //       "Invoice F6",
            //       "Invoice F8",
            //       "Invoice F9",
            //       "Invoice F11",
            //       "Invoice F11 Mannual"
            //     ].map((bgentype) {
            //       return DropdownMenuItem(
            //         value: bgentype,
            //         child: Text(bgentype),
            //       );
            //     }).toList(),
            //     hint: Text('Select Bill  Generate Type'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedPrintFormat,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedPrintFormat = newValue;
            //       });
            //     },
            //     items: [
            //       "Std",
            //       "F2",
            //       "F3",
            //       "F4",
            //       "F5",
            //       "F6",
            //       "F7",
            //       "F8",
            //       "F9",
            //       "F10",
            //       "F11",
            //       "F12",
            //       "F13"
            //     ].map((pFormat) {
            //       return DropdownMenuItem(
            //         value: pFormat,
            //         child: Text(pFormat),
            //       );
            //     }).toList(),
            //     hint: Text('Select Print Format'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedCompanyBank,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedCompanyBank = newValue;
            //       });
            //     },
            //     items: _companyBanks.map((bank) {
            //       return DropdownMenuItem(
            //         value: bank,
            //         child: Text(bank),
            //       );
            //     }).toList(),
            //     hint: Text('Bank'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedPFcode,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedPFcode = newValue;
            //       });
            //     },
            //     items: _pf.map((pfVal) {
            //       return DropdownMenuItem(
            //         value: pfVal,
            //         child: Text(pfVal),
            //       );
            //     }).toList(),
            //     hint: Text('PF Code'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     value: _selectedESICCode,
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedESICCode = newValue;
            //       });
            //     },
            //     items: _esic.map((es) {
            //       return DropdownMenuItem(
            //         value: es,
            //         child: Text(es),
            //       );
            //     }).toList(),
            //     hint: Text('ESIC Code'),
            //   ),
            // ),
            // SizedBox(height: 20),
            // SizedBox(height: 16),
            // Text(
            //   'Bill Not Create for this Unit',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // CheckboxListTile(
            //   title: Text('GST Applicable'),
            //   value: _isGSTApplicable,
            //   onChanged: (value) {
            //     setState(() {
            //       _isGSTApplicable = value!;
            //     });
            //   },
            // ),
            // CheckboxListTile(
            //   title: Text('IGST Applicable'),
            //   value: _isIGSTApplicable,
            //   onChanged: (value) {
            //     setState(() {
            //       _isIGSTApplicable = value!;
            //     });
            //   },
            // ),
            // CheckboxListTile(
            //   title: Text('Union Territory'),
            //   value: _isUnionTerritory,
            //   onChanged: (value) {
            //     setState(() {
            //       _isUnionTerritory = value!;
            //     });
            //   },
            // ),
            // CheckboxListTile(
            //   title: Text('System Billing'),
            //   value: _isSystemBilling,
            //   onChanged: (value) {
            //     setState(() {
            //       _isSystemBilling = value!;
            //     });
            //   },
            // ),
            // CheckboxListTile(
            //   title: Text('Is Billing In Decimal'),
            //   value: _isBillingInDecimal,
            //   onChanged: (value) {
            //     setState(() {
            //       _isBillingInDecimal = value!;
            //     });
            //   },
            // ),
            // CheckboxListTile(
            //   title: Text('Contract Period Shown'),
            //   value: _isContractPeriodShown,
            //   onChanged: (value) {
            //     setState(() {
            //       _isContractPeriodShown = value!;
            //     });
            //   },
            // ),
            SizedBox(height: 16),
            // Text(
            //   'Accounts Officer',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 20),
            // TextField(
            //   decoration: InputDecoration(
            //       labelText: 'Mobile No', border: OutlineInputBorder()),
            //   keyboardType: TextInputType.phone,
            //   inputFormatters: <TextInputFormatter>[
            //     FilteringTextInputFormatter.digitsOnly,
            //     LengthLimitingTextInputFormatter(12), // Including "+91"
            //     TextInputFormatter.withFunction((oldValue, newValue) {
            //       // Check if the new value is empty or already starts with "+91"
            //       if (newValue.text.isEmpty ||
            //           newValue.text.startsWith("+91")) {
            //         return newValue;
            //       }

            //       // Check if the new value starts with "91" and add "+" if not
            //       if (newValue.text.startsWith("91")) {
            //         return TextEditingValue(
            //           text: "+${newValue.text}",
            //           selection: TextSelection.collapsed(
            //               offset: newValue.selection.end + 1),
            //         );
            //       }

            //       // Check if the new value starts with a digit and add "+91" if not
            //       if (newValue.text.isNotEmpty &&
            //           (newValue.text.codeUnitAt(0) >= 48 &&
            //               newValue.text.codeUnitAt(0) <= 57)) {
            //         return TextEditingValue(
            //           text: "+91${newValue.text}",
            //           selection: TextSelection.collapsed(
            //               offset: newValue.selection.end + 3),
            //         );
            //       }

            //       // Return the new value as it is if none of the conditions match
            //       return newValue;
            //     }),
            //   ],
            // ),
            // SizedBox(height: 16),
            // SizedBox(height: 20),
            // SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
