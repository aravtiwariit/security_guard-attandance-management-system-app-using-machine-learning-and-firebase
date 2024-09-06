// ignore_for_file: unused_import, unused_field, depend_on_referenced_packages, prefer_is_not_empty, prefer_const_constructors, unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class NewEmployeePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NewEmployeePageState createState() => _NewEmployeePageState();
}

class _NewEmployeePageState extends State<NewEmployeePage> {
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dojController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _aadharNoController = TextEditingController();
  final TextEditingController _bankAccountNoController =
      TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _nameInPassbookController =
      TextEditingController();
  final TextEditingController _presentAddressHouseNoController =
      TextEditingController();
  final TextEditingController _presentAddressColonyController =
      TextEditingController();
  final TextEditingController _presentAddressSectorController =
      TextEditingController();
  final TextEditingController _presentAddressNearController =
      TextEditingController();
  final TextEditingController _presentAddressHomeMobileController =
      TextEditingController();
  final TextEditingController _presentAddressThanaController =
      TextEditingController();
  final TextEditingController _presentAddressEmailController =
      TextEditingController();
  final TextEditingController _presentAddressStateController =
      TextEditingController();
  final TextEditingController _presentAddressDistrictController =
      TextEditingController();
  final TextEditingController _presentAddressPinCodeController =
      TextEditingController();

  String? _aadharCardUrl;
  String? _panCardUrl;
  String? _photoUrl;
  String? _signUrl;
  String? _passbookUrl;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBranch;
  String? _selectedFieldArea;
  String? _selectedBank;
  String? _selectedSalutation;
  String? _selectedEmployeeType;
  String? _selectedDesignation;
  String? _selectedClient;
  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _branches = [];
  List<String> _fieldarea = [];
  List<String> _clients = [];
  List<String> _banks = [];
  List<String> _designation = [];
  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchBank();
    _fetchDesignation();
  }

  Future<void> _fetchDesignation() async {
    QuerySnapshot designationSnapshot =
        await FirebaseFirestore.instance.collection('services').get();
    setState(() {
      _designation = designationSnapshot.docs
          .map((doc) => doc['Post Name'] as String)
          .toList();
    });
  }

  //functions to fetch countries,states ,districts ,branches,field ares from stored firestore collection //
  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchBank() async {
    QuerySnapshot banksSnapshot =
        await FirebaseFirestore.instance.collection('banks').get();
    setState(() {
      _banks = banksSnapshot.docs.map((doc) => doc['name'] as String).toList();
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
      _selectedBranch = null; // Reset selected district when districts change
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

  Future<void> _fetchClients(String country, String state, String district,
      String branch, String area) async {
    QuerySnapshot clientsSnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .where('Country', isEqualTo: country)
        .where('State', isEqualTo: state)
        .where('District', isEqualTo: district)
        .where('Branch', isEqualTo: branch)
        .where('Area', isEqualTo: area)
        .get();
    setState(() {
      _clients = clientsSnapshot.docs
          .map((doc) => doc['Client Name'] as String)
          .toList();
      _selectedClient = null; // Reset selected district when districts change
    });
  }

  void _saveData() {
    // Validate email format
    if (!_presentAddressEmailController.text.isEmpty &&
        !_isValidEmail(_presentAddressEmailController.text)) {
      _showErrorMessage("Please enter a valid email address.");
      return;
    }

    FirebaseFirestore.instance.collection('employees').add({
      'country': _selectedCountry,
      'state': _selectedState,
      'district': _selectedDistrict,
      'branch': _selectedBranch,
      'area': _selectedFieldArea,
      'client': _selectedClient,
      'employmentType': _selectedEmployeeType,
      'salutation': _selectedSalutation,
      'mobileNo': _mobileNoController.text,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'dob': _dobController.text,
      'doj': _dojController.text,
      'designation': _selectedDesignation,
      'maritalStatus': _maritalStatusController.text,
      'fatherName': _fatherNameController.text,
      'motherName': _motherNameController.text,
      'education': _educationController.text,
      'aadharNo': _aadharNoController.text,
      'bankAccountNo': _bankAccountNoController.text,
      'ifscCode': _ifscCodeController.text,
      'bankName': _selectedBank,
      'nameInPassbook': _nameInPassbookController.text,
      'presentAddressHouseNo': _presentAddressHouseNoController.text,
      'presentAddressColony': _presentAddressColonyController.text,
      'presentAddressSector': _presentAddressSectorController.text,
      'presentAddressNear': _presentAddressNearController.text,
      'presentAddressHomeMobile': _presentAddressHomeMobileController.text,
      'presentAddressThana': _presentAddressThanaController.text,
      'presentAddressEmail': _presentAddressEmailController.text,
      'presentAddressState': _presentAddressStateController.text,
      'presentAddressDistrict': _presentAddressDistrictController.text,
      'presentAddressPinCode': _presentAddressPinCodeController.text,
      'aadharCardUrl': _aadharCardUrl,
      'panCardUrl': _panCardUrl,
      'photoUrl': _photoUrl,
      'signUrl': _signUrl,
      'passbookUrl': _passbookUrl,
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

  Future<void> _selectFile(FileType fileType, String field) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('$field/${result.files.first.name}');
      firebase_storage.UploadTask uploadTask =
          ref.putData(result.files.first.bytes!);
      uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();
        setState(() {
          if (field == 'aadhar_card') {
            _aadharCardUrl = downloadURL;
          } else if (field == 'pan_card') {
            _panCardUrl = downloadURL;
          } else if (field == 'photo') {
            _photoUrl = downloadURL;
          } else if (field == 'sign') {
            _signUrl = downloadURL;
          } else if (field == 'passbook') {
            _passbookUrl = downloadURL;
          }
        });
      });
    }
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
        title: Text('New Employee'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                    _fetchBranch(_selectedCountry!, _selectedState!, newValue!);
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

            SizedBox(height: 10),

            // Branch
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

            SizedBox(height: 10),

            // Field Area
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
                    _fetchClients(_selectedCountry!, _selectedState!,
                        _selectedDistrict!, _selectedBranch!, newValue!);
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

            SizedBox(height: 10),
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
            SizedBox(height: 10),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedEmployeeType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEmployeeType = newValue;
                  });
                },
                items: [
                  "Permanent",
                  "Contractual",
                ].map((etype) {
                  return DropdownMenuItem(
                    value: etype,
                    child: Text(etype),
                  );
                }).toList(),
                hint: Text('Select Employment type'),
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
                value: _selectedSalutation,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSalutation = newValue;
                  });
                },
                items: ["Mr.", "Mrs.", "Ms."].map((salutation) {
                  return DropdownMenuItem(
                    value: salutation,
                    child: Text(salutation),
                  );
                }).toList(),
                hint: Text('Select Salutation'),
              ),
            ),

            TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name*')),
            TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name')),

            TextField(
              controller: _mobileNoController,
              decoration: InputDecoration(labelText: 'MobileNo'),
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
            // TextField(
            //     controller: _dobController,
            //     decoration: InputDecoration(labelText: 'Date Of Birth')),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date Of Birth',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      // Set this parameter to false to hide the time picker
                      helpText: 'Select date', // optional
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(), // Set the theme
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null &&
                        pickedDate != _dobController.text) {
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        _dobController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              readOnly: true, // Prevent direct text input
            ),
            // TextField(
            //     controller: _dojController,
            //     decoration: InputDecoration(labelText: 'Date Of Joining')),
            TextField(
              controller: _dojController,
              decoration: InputDecoration(
                labelText: 'Date Of Joining',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      // Set this parameter to false to hide the time picker
                      helpText: 'Select date', // optional
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light(), // Set the theme
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null &&
                        pickedDate != _dojController.text) {
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        _dojController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              readOnly: true, // Prevent direct text input
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedDesignation,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDesignation = newValue;
                  });
                },
                items: _designation.map((desig) {
                  return DropdownMenuItem(
                    value: desig,
                    child: Text(desig),
                  );
                }).toList(),
                hint: Text('Select Designation'),
              ),
            ),
            TextField(
                controller: _maritalStatusController,
                decoration: InputDecoration(labelText: 'Marital Status')),
            TextField(
                controller: _fatherNameController,
                decoration: InputDecoration(labelText: 'Father Name')),
            TextField(
                controller: _motherNameController,
                decoration: InputDecoration(labelText: 'Mother Name')),
            TextField(
                controller: _educationController,
                decoration: InputDecoration(labelText: 'Highest Education')),
            TextField(
                controller: _aadharNoController,
                decoration: InputDecoration(labelText: 'AADHAR No')),
            TextField(
                controller: _bankAccountNoController,
                decoration: InputDecoration(labelText: 'Bank Account No')),
            TextField(
                controller: _ifscCodeController,
                decoration: InputDecoration(labelText: 'IFSC Code')),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedBank,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBank = newValue;
                  });
                },
                items: _banks.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                hint: Text('Select Bank'),
              ),
            ),
            SizedBox(height: 10),
            TextField(
                controller: _nameInPassbookController,
                decoration:
                    InputDecoration(labelText: 'Name In Bank Passbook')),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectFile(FileType.any, 'aadhar_card'),
              child: Text('Upload Aadhar Card'),
            ),
            ElevatedButton(
              onPressed: () => _selectFile(FileType.any, 'pan_card'),
              child: Text('Upload Pan Card'),
            ),
            ElevatedButton(
              onPressed: () => _selectFile(FileType.any, 'photo'),
              child: Text('Upload Photo'),
            ),
            ElevatedButton(
              onPressed: () => _selectFile(FileType.any, 'sign'),
              child: Text('Upload Sign'),
            ),
            ElevatedButton(
              onPressed: () => _selectFile(FileType.any, 'passbook'),
              child: Text('Upload Passbook'),
            ),
            SizedBox(height: 16),
            Text('Present/Local Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
                controller: _presentAddressHouseNoController,
                decoration: InputDecoration(labelText: 'House No.')),
            TextField(
                controller: _presentAddressColonyController,
                decoration: InputDecoration(labelText: 'Colony')),
            TextField(
                controller: _presentAddressSectorController,
                decoration: InputDecoration(labelText: 'Sector')),
            TextField(
                controller: _presentAddressNearController,
                decoration: InputDecoration(labelText: 'Near')),
            TextField(
                controller: _presentAddressHomeMobileController,
                decoration: InputDecoration(labelText: 'Home Mobile No.')),
            TextField(
                controller: _presentAddressThanaController,
                decoration: InputDecoration(labelText: 'Name of Police Thana')),
            // TextField(
            //     controller: _presentAddressEmailController,
            //     decoration: InputDecoration(labelText: 'E-MailID')),
            TextFormField(
              controller: _presentAddressEmailController,
              decoration: InputDecoration(labelText: 'E-MailID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                } else if (!(value.endsWith('@gmail.com') ||
                    value.endsWith('@yahoo.com') ||
                    value.endsWith('@outlook.com'))) {
                  return 'Please enter a valid Gmail, Yahoo, or Outlook email address';
                }
                return null; // Return null if the validation passes
              },
            ),
            TextField(
                controller: _presentAddressStateController,
                decoration: InputDecoration(labelText: 'State')),
            TextField(
                controller: _presentAddressDistrictController,
                decoration: InputDecoration(labelText: 'District')),
            TextField(
                controller: _presentAddressPinCodeController,
                decoration: InputDecoration(labelText: 'PinCode')),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
