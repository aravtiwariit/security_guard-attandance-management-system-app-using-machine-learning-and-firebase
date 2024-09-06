// ignore_for_file: file_names, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NatureOfServicesPage extends StatefulWidget {
  const NatureOfServicesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NatureOfServicesPageState createState() => _NatureOfServicesPageState();
}

class _NatureOfServicesPageState extends State<NatureOfServicesPage> {
  final TextEditingController _natureOfServicesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nature of Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _natureOfServicesController,
              decoration: const InputDecoration(labelText: 'Nature of Service'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNatureOfService,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: NatureOfServiceList(),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNatureOfService() {
    String newNatureOfService = _natureOfServicesController.text.trim();
    if (newNatureOfService.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('nature_of_services')
          .add({'name': newNatureOfService});
      _natureOfServicesController.clear();
    }
  }
}

class NatureOfServiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('nature_of_services')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No nature of services found.'),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var docSnapshot = snapshot.data!.docs[index];
            String docId = docSnapshot.id;
            String name = docSnapshot['name'];
            return ListTile(
              title: Text(name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editNatureOfService(context, docId, name),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNatureOfService(docId),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _editNatureOfService(BuildContext context, String docId, String name) {
    TextEditingController _editController = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Nature of Service'),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(labelText: 'Nature of Service'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('nature_of_services')
                    .doc(docId)
                    .update({'name': _editController.text});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNatureOfService(String docId) {
    FirebaseFirestore.instance
        .collection('nature_of_services')
        .doc(docId)
        .delete();
  }
}

void main() {
  runApp(const MaterialApp(
    home: NatureOfServicesPage(),
  ));
}
