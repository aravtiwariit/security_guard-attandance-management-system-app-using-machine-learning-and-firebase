import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FieldAreaPage extends StatefulWidget {
  const FieldAreaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FieldAreaPageState createState() => _FieldAreaPageState();
}

class _FieldAreaPageState extends State<FieldAreaPage> {
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _fieldAreaNameController =
      TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();

  List<Map<String, dynamic>> _fieldAreas = [];

  @override
  void initState() {
    super.initState();
    _fetchFieldAreas();
  }

  Future<void> _fetchFieldAreas() async {
    QuerySnapshot fieldAreasSnapshot =
        await FirebaseFirestore.instance.collection('field_areas').get();
    setState(() {
      _fieldAreas = fieldAreasSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Area'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _branchNameController,
              decoration: const InputDecoration(labelText: 'Branch Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _fieldAreaNameController,
              decoration: const InputDecoration(labelText: 'Field Area Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _contactPersonController,
              decoration: const InputDecoration(labelText: 'Contact Person'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _mobileNoController,
              decoration: const InputDecoration(labelText: 'Mobile No'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveFieldArea,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Field Areas List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _fieldAreas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Field Area Name: ${_fieldAreas[index]['Field Area Name']}'),
                  subtitle:
                      Text('Branch: ${_fieldAreas[index]['Branch Name']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editFieldArea(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteFieldArea(index),
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

  void _saveFieldArea() {
    String branchName = _branchNameController.text.trim();
    String fieldAreaName = _fieldAreaNameController.text.trim();
    String contactPerson = _contactPersonController.text.trim();
    String mobileNo = _mobileNoController.text.trim();

    if (branchName.isNotEmpty &&
        fieldAreaName.isNotEmpty &&
        contactPerson.isNotEmpty &&
        mobileNo.isNotEmpty) {
      FirebaseFirestore.instance.collection('field_areas').add({
        'Branch Name': branchName,
        'Field Area Name': fieldAreaName,
        'Contact Person': contactPerson,
        'Mobile No': mobileNo,
      });
      _clearControllers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _clearControllers() {
    _branchNameController.clear();
    _fieldAreaNameController.clear();
    _contactPersonController.clear();
    _mobileNoController.clear();
  }

  void _editFieldArea(int index) {
    // Get the field area data at the specified index
    Map<String, dynamic> fieldAreaData = _fieldAreas[index];

    // Set the text controllers with the existing data
    _branchNameController.text = fieldAreaData['Branch Name'] ?? '';
    _fieldAreaNameController.text = fieldAreaData['Field Area Name'] ?? '';
    _contactPersonController.text = fieldAreaData['Contact Person'] ?? '';
    _mobileNoController.text = fieldAreaData['Mobile No'] ?? '';

    // Show dialog with text fields prefilled with existing data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Field Area'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add TextFormField widgets for each field
                // Prefill them with existing data
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Save changes to Firestore
                // Implement the save functionality here
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFieldArea(int index) {
    // Retrieve the document ID of the field area at the specified index
    String fieldAreaId = _fieldAreas[index]
        ['id']; // Assuming _fieldAreas is a List of DocumentSnapshots

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Field Area'),
          content:
              const Text('Are you sure you want to delete this field area?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Delete the field area document from Firestore
                FirebaseFirestore.instance
                    .collection('field_areas')
                    .doc(fieldAreaId)
                    .delete();

                // Update local list of field areas to reflect the deletion
                setState(() {
                  _fieldAreas.removeAt(index);
                });

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
}

void main() {
  runApp(const MaterialApp(
    home: FieldAreaPage(),
  ));
}
