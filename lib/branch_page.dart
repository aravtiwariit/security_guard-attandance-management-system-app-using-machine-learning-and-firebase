import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchPage extends StatefulWidget {
  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  final TextEditingController _districtNameController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _invoicePrefixController =
      TextEditingController();
  final TextEditingController _branchAddressController =
      TextEditingController();
  final TextEditingController _branchLocationController =
      TextEditingController();
  final TextEditingController _areaOfOperationController =
      TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _esiNoController = TextEditingController();
  final TextEditingController _vatNoController = TextEditingController();
  final TextEditingController _registrationChargeController =
      TextEditingController();
  final TextEditingController _alternateContactPersonController =
      TextEditingController();
  final TextEditingController _alternateMobileNoController =
      TextEditingController();
  final TextEditingController _alternateEmailController =
      TextEditingController();
  final TextEditingController _alternateDesignationController =
      TextEditingController();
  final TextEditingController _shopActNoController = TextEditingController();
  final TextEditingController _gstNoController = TextEditingController();
  final TextEditingController _professionalTaxNoController =
      TextEditingController();
  final TextEditingController _registrationChargeDeductionLimitController =
      TextEditingController();

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<Map<String, dynamic>> _branches = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchBranches();
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
      _branches = branchesSnapshot.docs.map((doc) {
        // Get the document ID
        String id = doc.id;
        // Get the branch data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Add the ID to the branch data
        data['_id'] = id;
        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Branch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    // TextFormField(
                    //   controller: _districtNameController,
                    //   decoration: InputDecoration(labelText: 'District Name'),
                    // ),

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
                      child: TextFormField(
                        controller: _regionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Region',
                        ),
                      ),
                    ),
                    // TextFormField(
                    //   controller: _regionController,
                    //   decoration: InputDecoration(labelText: 'Region'),
                    // ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _branchNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Branch Name',
                        ),
                      ),
                    ),
                    // TextFormField(
                    //   controller: _branchNameController,
                    //   decoration: InputDecoration(labelText: 'Branch Name'),
                    // ),

                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _invoicePrefixController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Invoice Prefix',
                        ),
                      ),
                    ),
                    // TextFormField(
                    //   controller: _invoicePrefixController,
                    //   decoration: InputDecoration(labelText: 'Invoice Prefix'),
                    // ),

                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _branchAddressController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Branch address',
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _branchLocationController,
                    //   decoration: InputDecoration(labelText: 'Branch Location'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _branchLocationController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Branch Location',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _areaOfOperationController,
                    //   decoration: InputDecoration(labelText: 'Area of Operation'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _areaOfOperationController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Area Of Operation',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _contactPersonController,
                    //   decoration: InputDecoration(labelText: 'Contact Person'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _contactPersonController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Contact Person',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _mobileNoController,
                    //   decoration: InputDecoration(labelText: 'Mobile No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _mobileNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Mobile No.',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _emailController,
                    //   decoration: InputDecoration(labelText: 'E-Mail'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'E-Mail',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _designationController,
                    //   decoration: InputDecoration(labelText: 'Designation'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _designationController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Designation',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _esiNoController,
                    //   decoration: InputDecoration(labelText: 'ESI No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _esiNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'ESI No.',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _vatNoController,
                    //   decoration: InputDecoration(labelText: 'VAT No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _vatNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'VAT No.',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _registrationChargeController,
                    //   decoration: InputDecoration(labelText: 'Registration Charge'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _registrationChargeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Registration Charge',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _alternateContactPersonController,
                    //   decoration:
                    //       InputDecoration(labelText: 'Alternate Contact Person'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _alternateContactPersonController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Alternate Contact Person',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _alternateMobileNoController,
                    //   decoration: InputDecoration(labelText: 'Alternate Mobile No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _alternateMobileNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Alternate Mobile No.',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _alternateEmailController,
                    //   decoration: InputDecoration(labelText: 'Alternate E-Mail'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _alternateEmailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Alternate E-Mail',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _alternateDesignationController,
                    //   decoration: InputDecoration(labelText: 'Alternate Designation'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _alternateDesignationController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Alternate Designation',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _shopActNoController,
                    //   decoration: InputDecoration(labelText: 'Shop Act No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _shopActNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Shop Act No',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _gstNoController,
                    //   decoration: InputDecoration(labelText: 'GST No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _gstNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'GST No',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _professionalTaxNoController,
                    //   decoration: InputDecoration(labelText: 'Professional Tax No'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _professionalTaxNoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Professional Tax No',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _registrationChargeDeductionLimitController,
                    //   decoration: InputDecoration(
                    //       labelText: 'Registration Charge Deduction Limit'),
                    // ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: TextFormField(
                        controller: _registrationChargeDeductionLimitController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Registration Charge Deduction Limit',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveBranch,
                      child: Text('Save'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Branches List:',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _branches.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4, // Add elevation for a shadow effect
                    margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal:
                            16), // Adjust margin for spacing between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Round the corners of the card
                    ),
                    child: ListTile(
                      // Display branch details
                      title: Text(
                          'Branch Name: ${_branches[index]['Branch Name']}'),
                      subtitle: Text(
                          'District: ${_branches[index]['District Name']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editBranch(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteBranch(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBranch() {
    // ignore: unused_local_variable
    String districtName = _districtNameController.text.trim();
    String region = _regionController.text.trim();
    String branchName = _branchNameController.text.trim();
    String invoicePrefix = _invoicePrefixController.text.trim();
    String branchAddress = _branchAddressController.text.trim();
    String branchLocation = _branchLocationController.text.trim();
    String areaOfOperation = _areaOfOperationController.text.trim();
    String contactPerson = _contactPersonController.text.trim();
    String mobileNo = _mobileNoController.text.trim();
    String email = _emailController.text.trim();
    String designation = _designationController.text.trim();
    String esiNo = _esiNoController.text.trim();
    String vatNo = _vatNoController.text.trim();
    String registrationCharge = _registrationChargeController.text.trim();
    String alternateContactPerson =
        _alternateContactPersonController.text.trim();
    String alternateMobileNo = _alternateMobileNoController.text.trim();
    String alternateEmail = _alternateEmailController.text.trim();
    String alternateDesignation = _alternateDesignationController.text.trim();
    String shopActNo = _shopActNoController.text.trim();
    String gstNo = _gstNoController.text.trim();
    String professionalTaxNo = _professionalTaxNoController.text.trim();
    String registrationChargeDeductionLimit =
        _registrationChargeDeductionLimitController.text.trim();

    FirebaseFirestore.instance.collection('branches').add({
      'Country Name': _selectedCountry,
      'State Name': _selectedState,
      'District Name': _selectedDistrict,
      'Region': region,
      'Branch Name': branchName,
      'Invoice Prefix': invoicePrefix,
      'Branch Address': branchAddress,
      'Branch Location': branchLocation,
      'Area of Operation': areaOfOperation,
      'Contact Person': contactPerson,
      'Mobile No': mobileNo,
      'E-Mail': email,
      'Designation': designation,
      'ESI No': esiNo,
      'VAT No': vatNo,
      'Registration Charge': registrationCharge,
      'Alternate Contact Person': alternateContactPerson,
      'Alternate Mobile No': alternateMobileNo,
      'Alternate E-Mail': alternateEmail,
      'Alternate Designation': alternateDesignation,
      'Shop Act No': shopActNo,
      'GST No': gstNo,
      'Professional Tax No': professionalTaxNo,
      'Registration Charge Deduction Limit': registrationChargeDeductionLimit,
    });
    _districtNameController.clear();
    _regionController.clear();
    _branchNameController.clear();
    _invoicePrefixController.clear();
    _branchAddressController.clear();
    _branchLocationController.clear();
    _areaOfOperationController.clear();
    _contactPersonController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _designationController.clear();
    _esiNoController.clear();
    _vatNoController.clear();
    _registrationChargeController.clear();
    _alternateContactPersonController.clear();
    _alternateMobileNoController.clear();
    _alternateEmailController.clear();
    _alternateDesignationController.clear();
    _shopActNoController.clear();
    _gstNoController.clear();
    _professionalTaxNoController.clear();
    _registrationChargeDeductionLimitController.clear();
    setState(() {
      _selectedCountry = null;
      _selectedDistrict = null;
      _selectedState = null;
    });
  }

  void _editBranch(int index) {
    // Get the branch data at the specified index
    Map<String, dynamic> branchData = _branches[index];

    // Set the text controllers with the existing data
    _districtNameController.text = branchData['District Name'] ?? '';
    _regionController.text = branchData['Region'] ?? '';
    _branchNameController.text = branchData['Branch Name'] ?? '';
    _invoicePrefixController.text = branchData['Invoice Prefix'] ?? '';
    _branchAddressController.text = branchData['Branch Address'] ?? '';
    _branchLocationController.text = branchData['Branch Location'] ?? '';
    _areaOfOperationController.text = branchData['Area of Operation'] ?? '';
    _contactPersonController.text = branchData['Contact Person'] ?? '';
    _mobileNoController.text = branchData['Mobile No'] ?? '';
    _emailController.text = branchData['E-Mail'] ?? '';
    _designationController.text = branchData['Designation'] ?? '';
    _esiNoController.text = branchData['ESI No'] ?? '';
    _vatNoController.text = branchData['VAT No'] ?? '';
    _registrationChargeController.text =
        branchData['Registration Charge'] ?? '';
    _alternateContactPersonController.text =
        branchData['Alternate Contact Person'] ?? '';
    _alternateMobileNoController.text = branchData['Alternate Mobile No'] ?? '';
    _alternateEmailController.text = branchData['Alternate E-Mail'] ?? '';
    _alternateDesignationController.text =
        branchData['Alternate Designation'] ?? '';
    _shopActNoController.text = branchData['Shop Act No'] ?? '';
    _gstNoController.text = branchData['GST No'] ?? '';
    _professionalTaxNoController.text = branchData['Professional Tax No'] ?? '';
    _registrationChargeDeductionLimitController.text =
        branchData['Registration Charge Deduction Limit'] ?? '';

    // Show dialog with text fields prefilled with existing data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Branch'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add TextFormField widgets for each field
                // Prefill them with existing data
                TextFormField(
                  controller: _districtNameController,
                  decoration: InputDecoration(labelText: 'District Name'),
                ),
                TextFormField(
                  controller: _regionController,
                  decoration: InputDecoration(labelText: 'Region'),
                ),
                TextFormField(
                  controller: _branchNameController,
                  decoration: InputDecoration(labelText: 'Branch Name'),
                ),
                TextFormField(
                  controller: _invoicePrefixController,
                  decoration: InputDecoration(labelText: 'Invoice Prefix'),
                ),
                TextFormField(
                  controller: _branchAddressController,
                  decoration: InputDecoration(labelText: 'Branch Address'),
                ),
                TextFormField(
                  controller: _branchLocationController,
                  decoration: InputDecoration(labelText: 'Branch Location'),
                ),
                TextFormField(
                  controller: _areaOfOperationController,
                  decoration: InputDecoration(labelText: 'Area Of Operation'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Save changes to Firestore
                _updateBranch(index);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateBranch(int index) {
    // Get the document ID of the branch at the specified index
    String branchId = _branches[index]
        ['_id']; // Assuming _branches is a List of DocumentSnapshots

    // Get the updated values from the text controllers
    String updatedDistrictName = _districtNameController.text.trim();
    String updatedRegion = _regionController.text.trim();
    String updatedBranchName = _branchNameController.text.trim();
    String updateInvoicePrefix = _invoicePrefixController.text.trim();
    String updateBranchAddress = _branchAddressController.text.trim();
    String updateBranchLocation = _branchLocationController.text.trim();
    String updateareaOfOperation = _areaOfOperationController.text.trim();
    // Continue getting updated values for all fields

    // Update the document in Firestore
    FirebaseFirestore.instance.collection('branches').doc(branchId).update({
      'District Name': updatedDistrictName,
      'Region': updatedRegion,
      'Branch Name': updatedBranchName,
      'Invoice Prefix': updateInvoicePrefix,
      'Branch Address': updateBranchAddress,
      'Branch Location': updateBranchLocation,
      'Area Of Operation': updateareaOfOperation
      // Add updates for all fields
    }).then((value) {
      // If update is successful, show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Branch updated successfully'),
        backgroundColor: Colors.green,
      ));

      // Optionally, you can clear the text controllers after update
      _clearControllers();

      // Optionally, you can also refetch the branches to update the UI
      _fetchBranches();
    }).catchError((error) {
      // If update fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update branch: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }

  void _clearControllers() {
    _districtNameController.clear();
    _regionController.clear();
    _branchNameController.clear();
    _branchAddressController.clear();
    _invoicePrefixController.clear();
    _branchLocationController.clear();
    _areaOfOperationController.clear();
    _contactPersonController.clear();
    _alternateContactPersonController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _esiNoController.clear();
    _alternateDesignationController.clear();
    _shopActNoController.clear();
    _gstNoController.clear();
    _professionalTaxNoController.clear();
    _registrationChargeController.clear();
    // Clear other text controllers similarly
  }

  void _deleteBranch(int index) {
    // Retrieve the document ID of the branch at the specified index
    String branchId = _branches[index]['_id'];
    print("State Updated");
    print(_branches);
    // // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Branch'),
          content: Text('Are you sure you want to delete this branch?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Delete the branch document from Firestore
                FirebaseFirestore.instance
                    .collection('branches')
                    .doc(branchId)
                    .delete();

                // Update local list of branches to reflect the deletion
                setState(() {
                  _branches.removeAt(index);
                });

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void main() {
    runApp(MaterialApp(
      home: BranchPage(),
    ));
  }
}
