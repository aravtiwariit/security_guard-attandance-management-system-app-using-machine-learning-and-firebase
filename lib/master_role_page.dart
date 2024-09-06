import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String name;

  Role({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: MasterRolePage(),
  ));
}

class MasterRolePage extends StatefulWidget {
  const MasterRolePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MasterRolePageState createState() => _MasterRolePageState();
}

class _MasterRolePageState extends State<MasterRolePage> {
  final TextEditingController _roleController = TextEditingController();
  Stream<List<DocumentSnapshot>>? _rolesList;

  @override
  void initState() {
    super.initState();
    _rolesList = FirebaseFirestore.instance
        .collection('roles')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  void _addRole() {
    FirebaseFirestore.instance.collection('roles').add({
      'role': _roleController.text,
    });

    _roleController.clear();
  }

  void _editRole(String docId, String currentRole) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Role'),
          content: TextFormField(
            controller: _roleController..text = currentRole,
            decoration: const InputDecoration(
              hintText: 'Type Role Here',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('roles')
                    .doc(docId)
                    .update({'role': _roleController.text});
                _roleController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRole(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this role?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('roles')
                    .doc(docId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Role'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _roleController,
                    decoration: const InputDecoration(
                      hintText: 'Type Role Here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addRole,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Roles List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _rolesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No roles found.'),
                    );
                  }
                  // If there are no errors, build the ListView with the updated roles list
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var docSnapshot = snapshot.data![index];
                      String docId = docSnapshot.id;
                      String role = docSnapshot['role'];
                      return ListTile(
                        title: Text(role),
                        leading: Text('${index + 1}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editRole(docId, role),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteRole(docId),
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

void main2() {
  runApp(const MaterialApp(
    home: MasterRolePage(),
  ));
}
