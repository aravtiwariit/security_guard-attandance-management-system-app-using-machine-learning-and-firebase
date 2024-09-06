//make a page for "Right" botton , which contains following information,
//Type Role( rectuangular box)
//"add" bottom whith solid red and text is white ,
//when we click on the 'add' bottom then it add the role in to the firebase store , and show all the data below on the screen from the firestore ,
//and also edit and delete option for seperately?

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RightPage extends StatefulWidget {
  const RightPage({Key? key}) : super(key: key);

  @override
  _RightPageState createState() => _RightPageState();
}

class _RightPageState extends State<RightPage> {
  final TextEditingController _roleController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Right Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                hintText: 'Enter Role',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore.collection('roles').add({
                'role': _roleController.text,
              });
              _roleController.clear();
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('roles').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final roles = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    return ListTile(
                      title: Text(role['role']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Implement edit functionality?
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final TextEditingController _editController =
                                      TextEditingController(text: role['role']);
                                  return AlertDialog(
                                    title: const Text('Edit Role'),
                                    content: TextField(
                                      controller: _editController,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          role.reference.update({
                                            'role': _editController.text,
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Implement delete functionality?
                              role.reference.delete();
                            },
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
    );
  }
}
