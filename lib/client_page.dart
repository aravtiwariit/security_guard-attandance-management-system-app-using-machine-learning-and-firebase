import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _contractExpiredDateController =
      TextEditingController();
  String? _selectedBranch;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedFieldArea;
  String? _selectedZone;
  List<String> _branches = [];
  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _zones = [];
  List<String> _fieldarea = [];

  void initState() {
    super.initState();

    _fetchBranches();
    _fetchCountries();
    _fetchZones();
  }

  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
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

  void _saveClientData() {
    // Get all the values from the text controllers
    String clientName = _clientNameController.text.trim();
    String address = _addressController.text.trim();

    String pin = _pinController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();

    String contractExpiredDate = _contractExpiredDateController.text.trim();

    // Save the data to Firestore
    FirebaseFirestore.instance.collection('clients').add({
      'Client Name': clientName,
      'Address': address,
      'Country': _selectedCountry,
      'Zone': _selectedZone,
      'State': _selectedState,
      'District': _selectedDistrict,
      'Branch': _selectedBranch,
      'Area': _selectedFieldArea,
      'Pin': pin,
      'Phone': phone,
      'E-Mail': email,
    });

    // Show a message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data added successfully'),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Client'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Name
            // TextFormField(
            //   controller: _clientNameController,
            //   decoration: InputDecoration(labelText: 'Client Name'),
            // ),

            SizedBox(height: 10),
            //client Name fiels
            Container(
              height: 50, // Set the height as needed
              width: 250, // Set the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Make border round
                border: Border.all(), // Add border
              ),
              child: TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust content padding
                  labelText: 'Client Name',
                ),
              ),
            ),

            // Address
            // TextFormField(
            //   controller: _addressController,
            //   decoration: InputDecoration(labelText: 'Address'),
            // ),
            SizedBox(height: 10),
            Container(
              height: 50, // Set the height as needed
              width: 250, // Set the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Make border round
                border: Border.all(), // Add border
              ),
              child: TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust content padding
                  labelText: 'Address',
                ),
              ),
            ),

            // Country
            // TextFormField(
            //   controller: _countryController,
            //   decoration: InputDecoration(labelText: 'Country'),
            // ),
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

            // Zone
            // TextFormField(
            //   controller: _zoneController,
            //   decoration: InputDecoration(labelText: 'Zone'),
            // ),

            SizedBox(height: 10),
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
            SizedBox(height: 10),
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

            SizedBox(height: 20),

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
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedZone,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedZone = newValue;

                    // Fetch states for the selected country
                  });
                },
                items: _zones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList(),
                hint: Text('Select Zone'),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(height: 10),

            SizedBox(height: 10),
            Container(
              height: 50, // Set the height as needed
              width: 250, // Set the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Make border round
                border: Border.all(), // Add border
              ),
              child: TextFormField(
                controller: _pinController,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust content padding
                  labelText: 'Pin',
                ),
              ),
            ),

            SizedBox(height: 10),
            Container(
              height: 50, // Set the height as needed
              width: 250, // Set the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Make border round
                border: Border.all(), // Add border
              ),
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust content padding
                  labelText: 'Phone',
                ),
              ),
            ),

            // E-Mail
            // TextFormField(
            //   controller: _emailController,
            //   decoration: InputDecoration(labelText: 'E-Mail'),
            // ),
            SizedBox(height: 10),
            Container(
              height: 50, // Set the height as needed
              width: 250, // Set the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Make border round
                border: Border.all(), // Add border
              ),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10), // Optional: Adjust content padding
                  labelText: 'E-Mail',
                ),
              ),
            ),

            // Web
            // TextFormField(
            //   controller: _webController,
            //   decoration: InputDecoration(labelText: 'Web'),
            // ),
            // SizedBox(height: 10),

            // // Nature of Services
            // TextFormField(
            //   controller: _natureOfServicesController,
            //   decoration: InputDecoration(labelText: 'Nature of Services'),
            // ),
            // SizedBox(height: 10),

            // // Current Status
            // TextFormField(
            //   controller: _currentStatusController,
            //   decoration: InputDecoration(labelText: 'Current Status'),
            // ),
            // SizedBox(height: 10),

            // // Client Category
            // TextFormField(
            //   controller: _clientCategoryController,
            //   decoration: InputDecoration(labelText: 'Client Category'),
            // ),
            // SizedBox(height: 10),

            // // Client Vertical
            // TextFormField(
            //   controller: _clientVerticalController,
            //   decoration: InputDecoration(labelText: 'Client Vertical'),
            // ),
            // SizedBox(height: 10),

            // // Security Deposit Amount
            // TextFormField(
            //   controller: _securityDepositAmountController,
            //   decoration: InputDecoration(labelText: 'Security Deposit Amount'),
            // ),
            // SizedBox(height: 10),

            // // Fdr/DD No/Bg No/Date
            // TextFormField(
            //   controller: _fdrDdBgNoDateController,
            //   decoration: InputDecoration(labelText: 'Fdr/DD No/Bg No/Date'),
            // ),
            // SizedBox(height: 10),

            // // Maturity Date
            // TextFormField(
            //   controller: _maturityDateController,
            //   decoration: InputDecoration(labelText: 'Maturity Date'),
            // ),
            // SizedBox(height: 10),

            // // Refund Date
            // TextFormField(
            //   controller: _refundDateController,
            //   decoration: InputDecoration(labelText: 'Refund Date'),
            // ),
            // SizedBox(height: 10),

            // // Is Cash Van
            // TextFormField(
            //   controller: _isCashVanController,
            //   decoration: InputDecoration(labelText: 'Is Cash Van'),
            // ),
            // SizedBox(height: 10),

            // // Work Order No
            // TextFormField(
            //   controller: _workOrderNoController,
            //   decoration: InputDecoration(labelText: 'Work Order No'),
            // ),
            // SizedBox(height: 10),

            // // Work Order Date
            // TextFormField(
            //   controller: _workOrderDateController,
            //   decoration: InputDecoration(labelText: 'Work Order Date'),
            // ),
            // SizedBox(height: 10),

            // // Agreement No
            // TextFormField(
            //   controller: _agreementNoController,
            //   decoration: InputDecoration(labelText: 'Agreement No'),
            // ),
            // SizedBox(height: 10),

            // // Agreement Date
            // TextFormField(
            //   controller: _agreementDateController,
            //   decoration: InputDecoration(labelText: 'Agreement Date'),
            // ),
            // SizedBox(height: 10),

            // // Contract Date
            // TextFormField(
            //   controller: _contractDateController,
            //   decoration: InputDecoration(labelText: 'Contract Date'),
            // ),
            // SizedBox(height: 10),

            // // Contract Expired Date
            // TextFormField(
            //   controller: _contractExpiredDateController,
            //   decoration: InputDecoration(labelText: 'Contract Expired Date'),
            // ),
            // SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: _saveClientData,
            //   child: Text('Save'),
            // ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ClientPage(),
  ));
}
