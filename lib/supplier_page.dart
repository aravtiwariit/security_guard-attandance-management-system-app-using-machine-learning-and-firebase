import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    title: 'Master Supplier Page',
    home: MasterSupplierPage(),
  ));
}

class MasterSupplierPage extends StatefulWidget {
  @override
  _MasterSupplierPageState createState() => _MasterSupplierPageState();
}

class _MasterSupplierPageState extends State<MasterSupplierPage> {
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _gstNoController = TextEditingController();
  final TextEditingController _tanNoController = TextEditingController();
  final TextEditingController _gst2Controller = TextEditingController();
  final TextEditingController _panNoController = TextEditingController();
  final TextEditingController _gst3Controller = TextEditingController();
  final TextEditingController _typeOfSupplierController =
      TextEditingController();
  final TextEditingController _paymentTermController = TextEditingController();
  final TextEditingController _paymentDaysController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountNoController =
      TextEditingController();
  final TextEditingController _branchAddressController =
      TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _termsAndConditionsController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Supplier'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("Supplier Name", _supplierNameController),
            _buildTextField("Opening Balance", _openingBalanceController),
            _buildTextField("Address", _addressController),
            _buildTextField("Contact Person", _contactPersonController),
            _buildTextField("Mobile No", _mobileNoController),
            _buildTextField("Email", _emailController),
            _buildTextField("GST No.", _gstNoController),
            _buildTextField("Tan No.", _tanNoController),
            _buildTextField("GST 2", _gst2Controller),
            _buildTextField("Pan No.", _panNoController),
            _buildTextField("GST 3", _gst3Controller),
            _buildTextField("Type of Supplier", _typeOfSupplierController),
            _buildTextField("Payment Term", _paymentTermController),
            _buildTextField("Payment Days", _paymentDaysController),
            _buildTextField("Bank Name", _bankNameController),
            _buildTextField("Bank A/c No.", _bankAccountNoController),
            _buildTextField("Branch Address", _branchAddressController),
            _buildTextField("IFSC Code", _ifscCodeController),
            _buildTextField(
                "Terms & Conditions", _termsAndConditionsController),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveSupplier,
              child: Text('Save'),
            ),
            SizedBox(height: 16.0),
            _buildSuppliersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSuppliersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('suppliers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final suppliers = snapshot.data!.docs;
        return Column(
          children: suppliers.map<Widget>((doc) {
            final supplierData = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(supplierData['supplierName']),
              subtitle: Text(supplierData['contactPerson']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Implement edit functionality
                      // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditSupplierPage(docId: doc.id)));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteSupplier(doc.id);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _saveSupplier() async {
    final supplierData = {
      'supplierName': _supplierNameController.text,
      'openingBalance': _openingBalanceController.text,
      'address': _addressController.text,
      'contactPerson': _contactPersonController.text,
      'mobileNo': _mobileNoController.text,
      'email': _emailController.text,
      'gstNo': _gstNoController.text,
      'tanNo': _tanNoController.text,
      'gst2': _gst2Controller.text,
      'panNo': _panNoController.text,
      'gst3': _gst3Controller.text,
      'typeOfSupplier': _typeOfSupplierController.text,
      'paymentTerm': _paymentTermController.text,
      'paymentDays': _paymentDaysController.text,
      'bankName': _bankNameController.text,
      'bankAccountNo': _bankAccountNoController.text,
      'branchAddress': _branchAddressController.text,
      'ifscCode': _ifscCodeController.text,
      'termsAndConditions': _termsAndConditionsController.text,
    };

    await _firestore.collection('suppliers').add(supplierData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Supplier data saved'),
      ),
    );

    _clearFields();
  }

  void _deleteSupplier(String docId) async {
    await _firestore.collection('suppliers').doc(docId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Supplier data deleted'),
      ),
    );
  }

  void _clearFields() {
    _supplierNameController.clear();
    _openingBalanceController.clear();
    _addressController.clear();
    _contactPersonController.clear();
    _mobileNoController.clear();
    _emailController.clear();
    _gstNoController.clear();
    _tanNoController.clear();
    _gst2Controller.clear();
    _panNoController.clear();
    _gst3Controller.clear();
    _typeOfSupplierController.clear();
    _paymentTermController.clear();
    _paymentDaysController.clear();
    _bankNameController.clear();
    _bankAccountNoController.clear();
    _branchAddressController.clear();
    _ifscCodeController.clear();
    _termsAndConditionsController.clear();
  }
}
