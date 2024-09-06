// ignore_for_file: prefer_final_fields, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class AdditionalQualificationPage extends StatefulWidget {
  @override
  _AdditionalQualificationPageState createState() =>
      _AdditionalQualificationPageState();
}

class _AdditionalQualificationPageState
    extends State<AdditionalQualificationPage> {
  TextEditingController _qualificationController = TextEditingController();
  List<String> _qualificationsList = [];

  @override
  void dispose() {
    _qualificationController.dispose();
    super.dispose();
  }

  void _saveQualification() {
    String qualificationName = _qualificationController.text.trim();
    if (qualificationName.isNotEmpty) {
      FirebaseFirestore.instance.collection('qualifications').add({
        'name': qualificationName,
      });
      setState(() {
        _qualificationsList.add(qualificationName);
        _qualificationController.clear();
      });
    }
  }

  void _editQualification(int index, String qualificationId) {
    _qualificationController.text = _qualificationsList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Qualification'),
          content: TextField(
            controller: _qualificationController,
            decoration: const InputDecoration(
                labelText: 'Additional Qualification Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newQualificationName =
                    _qualificationController.text.trim();
                FirebaseFirestore.instance
                    .collection('qualifications')
                    .doc(qualificationId)
                    .update({
                  'name': newQualificationName,
                });
                setState(() {
                  _qualificationsList[index] = newQualificationName;
                  _qualificationController.clear();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteQualification(int index, String qualificationId) {
    FirebaseFirestore.instance
        .collection('qualifications')
        .doc(qualificationId)
        .delete();
    setState(() {
      _qualificationsList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Additional Qualification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _qualificationController,
              decoration: const InputDecoration(
                  labelText: 'Additional Qualification Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveQualification,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('qualifications')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final qualifications = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: qualifications.length,
                    itemBuilder: (context, index) {
                      final qualification = qualifications[index];
                      String qualificationId = qualification.id;
                      String qualificationName = qualification['name'];
                      return ListTile(
                        title: Text(qualificationName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _editQualification(index, qualificationId),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteQualification(index, qualificationId),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdditionalQualificationPage(),
  ));
}
