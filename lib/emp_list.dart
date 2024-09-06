// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lakshya/location_admin.dart';

import 'admin_login_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  late Stream<QuerySnapshot> _employeeStream;

  @override
  void initState() {
    super.initState();
    _employeeStream =
        FirebaseFirestore.instance.collection('employees').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // This sets the AppBar color to red
        title: const Text(
          'Emp list',
          style: TextStyle(
              color: Colors.white), // This sets the text color to white
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminLoginPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListPage()),
                );
                // Navigate to employees screen or perform employees-related action
              },
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLocationPage()),
                );
                // Navigate to location screen or perform location-related action
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                // Navigate to create post screen or perform create post-related action
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _employeeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> employeeData =
                  documents[index].data() as Map<String, dynamic>;

              // Ensure fields are not null before accessing them
              String firstName = employeeData['firstName'] ?? '';
              String lastName = employeeData['lastName'] ?? '';
              String designation = employeeData['designation'] ?? '';

              return ListTile(
                title: Text(firstName + ' ' + lastName),
                subtitle: Text(designation),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editEmployee(
                          employeeData, documents[index].reference),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteEmployee(documents[index].reference),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editEmployee(
      Map<String, dynamic> employeeData, DocumentReference reference) {
    String firstName = employeeData['firstName'] ?? '';
    String lastName = employeeData['lastName'] ?? '';
    String designation = employeeData['designation'] ?? '';

    String newFirstName = firstName;
    String newLastName = lastName;
    String newDesignation = designation;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: firstName,
                onChanged: (value) => newFirstName = value,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                initialValue: lastName,
                onChanged: (value) => newLastName = value,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                initialValue: designation,
                onChanged: (value) => newDesignation = value,
                decoration: const InputDecoration(labelText: 'Designation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update employee information in Firestore
                reference.update({
                  'firstName': newFirstName,
                  'lastName': newLastName,
                  'designation': newDesignation,
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(DocumentReference reference) {
    reference.delete();
  }
}
