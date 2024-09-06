import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Qualification {
  final String name;

  Qualification({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: QualificationPage(),
  ));
}

class QualificationPage extends StatefulWidget {
  @override
  _QualificationPageState createState() => _QualificationPageState();
}

class _QualificationPageState extends State<QualificationPage> {
  TextEditingController _qualificationController = TextEditingController();
  List<Qualification> _qualifications = [];

  @override
  void initState() {
    super.initState();
    _getQualifications();
  }

  void _getQualifications() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('qualifications').get();
    setState(() {
      _qualifications = querySnapshot.docs
          .map((doc) => Qualification(name: doc['name']))
          .toList();
    });
  }

  void _addQualification() async {
    Qualification newQualification =
        Qualification(name: _qualificationController.text);
    await FirebaseFirestore.instance
        .collection('qualifications')
        .add(newQualification.toMap());

    _qualificationController.clear();
    _getQualifications();
  }

  void _editQualification(String docId) {
    // Implement edit functionality
  }

  void _deleteQualification(String docId) {
    // Implement delete functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qualification Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _qualificationController,
                decoration: InputDecoration(labelText: 'Qualification Name'),
              ),
              ElevatedButton(
                onPressed: _addQualification,
                child: Text('Save'),
              ),
              SizedBox(height: 20),
              Text(
                'Qualifications List:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _qualifications.length,
                itemBuilder: (BuildContext context, int index) {
                  var qualification = _qualifications[index];
                  return ListTile(
                    title: Text(qualification.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              _editQualification(qualification.name),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _deleteQualification(qualification.name),
                        ),
                      ],
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
}
