import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class ServicesPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _postNameController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _sacHsnCodeController = TextEditingController();
  final TextEditingController _gstCategoryController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();
  final TextEditingController _igstController = TextEditingController();

  List<DocumentSnapshot> _services = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchServices();
    });
  }

  Future<void> _fetchServices() async {
    try {
      QuerySnapshot servicesSnapshot =
          await FirebaseFirestore.instance.collection('services').get();
      setState(() {
        _services = servicesSnapshot.docs;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _postNameController,
              decoration: const InputDecoration(labelText: 'Post Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _postCodeController,
              decoration: const InputDecoration(labelText: 'Post Code'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _sacHsnCodeController,
              decoration: const InputDecoration(labelText: 'SAC/HSN Code'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _gstCategoryController,
              decoration: const InputDecoration(labelText: 'GST Category'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cgstController,
              decoration: const InputDecoration(labelText: 'CGST (in %)'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _sgstController,
              decoration: const InputDecoration(labelText: 'SGST (in %)'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _igstController,
              decoration: const InputDecoration(labelText: 'IGST (in %)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveService,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Services List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _services.length,
              itemBuilder: (context, index) {
                var service = _services[index];
                _postNameController.text = service['Post Name'] ?? '';
                _postCodeController.text = service['Post Code'] ?? '';
                _sacHsnCodeController.text = service['SAC/HSN Code'] ?? '';
                _gstCategoryController.text = service['GST Category'] ?? '';
                _cgstController.text = service['CGST'] ?? '';
                _sgstController.text = service['SGST'] ?? '';
                _igstController.text = service['IGST'] ?? '';

                return ListTile(
                  title: Text('Post Name: ${service['Post Name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Post Code: ${service['Post Code']}'),
                      Text('SAC/HSN Code: ${service['SAC/HSN Code']}'),
                      Text('GST Category: ${service['GST Category']}'),
                      Text('CGST: ${service['CGST']}%'),
                      Text('SGST: ${service['SGST']}%'),
                      Text('IGST: ${service['IGST']}%'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editService(service),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteService(service.id),
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

  void _saveService() {
    String postName = _postNameController.text.trim();
    String postCode = _postCodeController.text.trim();
    String sacHsnCode = _sacHsnCodeController.text.trim();
    String gstCategory = _gstCategoryController.text.trim();
    String cgst = _cgstController.text.trim();
    String sgst = _sgstController.text.trim();
    String igst = _igstController.text.trim();

    if (postName.isNotEmpty &&
        postCode.isNotEmpty &&
        sacHsnCode.isNotEmpty &&
        gstCategory.isNotEmpty &&
        cgst.isNotEmpty &&
        sgst.isNotEmpty &&
        igst.isNotEmpty) {
      FirebaseFirestore.instance.collection('services').add({
        'Post Name': postName,
        'Post Code': postCode,
        'SAC/HSN Code': sacHsnCode,
        'GST Category': gstCategory,
        'CGST': cgst,
        'SGST': sgst,
        'IGST': igst,
      });
      _postNameController.clear();
      _postCodeController.clear();
      _sacHsnCodeController.clear();
      _gstCategoryController.clear();
      _cgstController.clear();
      _sgstController.clear();
      _igstController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editService(DocumentSnapshot service) {
    _postNameController.text = service['Post Name'] ?? '';
    _postCodeController.text = service['Post Code'] ?? '';
    _sacHsnCodeController.text = service['SAC/HSN Code'] ?? '';
    _gstCategoryController.text = service['GST Category'] ?? '';
    _cgstController.text = service['CGST'] ?? '';
    _sgstController.text = service['SGST'] ?? '';
    _igstController.text = service['IGST'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _postNameController,
                  decoration: const InputDecoration(labelText: 'Post Name'),
                ),
                TextFormField(
                  controller: _postCodeController,
                  decoration: const InputDecoration(labelText: 'Post Code'),
                ),
                TextFormField(
                  controller: _sacHsnCodeController,
                  decoration: const InputDecoration(labelText: 'SAC/HSN Code'),
                ),
                TextFormField(
                  controller: _gstCategoryController,
                  decoration: const InputDecoration(labelText: 'GST Category'),
                ),
                TextFormField(
                  controller: _cgstController,
                  decoration: const InputDecoration(labelText: 'CGST (in %)'),
                ),
                TextFormField(
                  controller: _sgstController,
                  decoration: const InputDecoration(labelText: 'SGST (in %)'),
                ),
                TextFormField(
                  controller: _igstController,
                  decoration: const InputDecoration(labelText: 'IGST (in %)'),
                ),
              ],
            ),
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
                _updateService(service.id);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Service'),
          content: const Text('Are you sure you want to delete this service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('services')
                    .doc(serviceId)
                    .delete();
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

  void _updateService(String serviceId) {
    String postName = _postNameController.text.trim();
    String postCode = _postCodeController.text.trim();
    String sacHsnCode = _sacHsnCodeController.text.trim();
    String gstCategory = _gstCategoryController.text.trim();
    String cgst = _cgstController.text.trim();
    String sgst = _sgstController.text.trim();
    String igst = _igstController.text.trim();

    if (postName.isNotEmpty &&
        postCode.isNotEmpty &&
        sacHsnCode.isNotEmpty &&
        gstCategory.isNotEmpty &&
        cgst.isNotEmpty &&
        sgst.isNotEmpty &&
        igst.isNotEmpty) {
      FirebaseFirestore.instance.collection('services').doc(serviceId).update({
        'Post Name': postName,
        'Post Code': postCode,
        'SAC/HSN Code': sacHsnCode,
        'GST Category': gstCategory,
        'CGST': cgst,
        'SGST': sgst,
        'IGST': igst,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    _postNameController.dispose();
    _postCodeController.dispose();
    _sacHsnCodeController.dispose();
    _gstCategoryController.dispose();
    _cgstController.dispose();
    _sgstController.dispose();
    _igstController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ServicesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchServices();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchServices();
  }

  @override
  void reassemble() {
    super.reassemble();
    _fetchServices();
  }
}

void main() {
  runApp(MaterialApp(
    home: ServicesPage(),
  ));
}
