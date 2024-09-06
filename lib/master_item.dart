// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Master Item Page',
    home: MasterItemPage(),
  ));
}

class MasterItemPage extends StatefulWidget {
  const MasterItemPage({super.key});

  @override
  _MasterItemPageState createState() => _MasterItemPageState();
}

class _MasterItemPageState extends State<MasterItemPage> {
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _openingStockController = TextEditingController();
  final TextEditingController _datedController = TextEditingController();
  final TextEditingController _deductionRateController =
      TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();
  final TextEditingController _igstController = TextEditingController();
  final TextEditingController _depreciationController = TextEditingController();
  final TextEditingController _deductionLimitController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedItemGroup = '';
  bool _isFixedAsset = false; // Initially unchecked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildItemGroupDropdown(),
            const SizedBox(height: 16.0),
            _buildTextField("Item Code", _itemCodeController),
            _buildTextField("Item Name", _itemNameController),
            _buildTextField("Description", _descriptionController),
            _buildCheckbox("Fixed Asset"),
            _buildTextField(
                "Opening Stock (Central Store)", _openingStockController),
            _buildTextField("Dated", _datedController),
            _buildTextField("Deduction Rate", _deductionRateController),
            _buildTextField("ROL", _rolController),
            _buildTextField("HSN Code", _hsnCodeController),
            _buildTextField("CGST (%)", _cgstController),
            _buildTextField("SGST (%)", _sgstController),
            _buildTextField("IGST (%)", _igstController),
            _buildTextField("Depreciation (%)", _depreciationController),
            _buildTextField("Re Issue",
                _itemNameController), // Placeholder, change as per requirement
            _buildTextField("Deduction Limit (Rs.)", _deductionLimitController),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveItem,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemGroupDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('itemGroups').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final items = snapshot.data!.docs;
        List<DropdownMenuItem<String>> dropdownItems = [];
        for (var item in items) {
          final itemName = item['name'];
          final dropdownItem = DropdownMenuItem<String>(
            child: Text(itemName),
            value: itemName,
          );
          dropdownItems.add(dropdownItem);
        }
        return DropdownButtonFormField<String>(
          items: dropdownItems,
          value: _selectedItemGroup.isNotEmpty ? _selectedItemGroup : null,
          onChanged: (value) {
            setState(() {
              _selectedItemGroup = value.toString();
            });
          },
          hint: const Text('Select Item Group'),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCheckbox(String label) {
    return Row(
      children: [
        Checkbox(
          value: _isFixedAsset,
          onChanged: (value) {
            setState(() {
              _isFixedAsset = value!;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  void _saveItem() async {
    final itemData = {
      'itemGroup': _selectedItemGroup,
      'itemCode': _itemCodeController.text,
      'itemName': _itemNameController.text,
      'description': _descriptionController.text,
      'isFixedAsset': _isFixedAsset,
      'openingStock': _openingStockController.text,
      'dated': _datedController.text,
      'deductionRate': _deductionRateController.text,
      'rol': _rolController.text,
      'hsnCode': _hsnCodeController.text,
      'cgst': _cgstController.text,
      'sgst': _sgstController.text,
      'igst': _igstController.text,
      'depreciation': _depreciationController.text,
      'deductionLimit': _deductionLimitController.text,
    };

    await _firestore
        .collection('items_group')
        .add(itemData); // Changed collection name

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item saved'),
      ),
    );

    _clearFields();
  }

  void _clearFields() {
    _selectedItemGroup = '';
    _isFixedAsset = false;
    _itemCodeController.clear();
    _itemNameController.clear();
    _descriptionController.clear();
    _openingStockController.clear();
    _datedController.clear();
    _deductionRateController.clear();
    _rolController.clear();
    _hsnCodeController.clear();
    _cgstController.clear();
    _sgstController.clear();
    _igstController.clear();
    _depreciationController.clear();
    _deductionLimitController.clear();
  }
}
