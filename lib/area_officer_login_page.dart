// ignore_for_file: unused_import, unnecessary_brace_in_string_interps, use_super_parameters, library_private_types_in_public_api, avoid_print, unused_element, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'area_officer_location.dart';
import 'login_page.dart';
import 'new_emp_page.dart';
import 'location_background.dart';

class MyDrawer extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String address;
  final VoidCallback signOutCallback;

  const MyDrawer(
      {super.key,
      required this.name,
      required this.role,
      required this.email,
      required this.address,
      required this.signOutCallback});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/logo.jpeg'), // Or use NetworkImage for network images
                  radius: 40, // Adjust as needed
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Role: ${role}'),
            onTap: () {
              // Navigate to desired screen when this item is tapped
            },
          ),
          ListTile(
            title: Text('Email: ${email}'),
            onTap: () {
              // Navigate to desired screen when this item is tapped
            },
          ),
          // Add more ListTiles for additional items in the drawer
          ListTile(
            title: Text('Address: ${address}'),
            onTap: () {
              // Navigate to desired screen when this item is tapped
            },
          ),
          const SizedBox(
              height: 16), // Add spacing between user info and buttons
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      // AreaOfficerLocationPage(email: email, role: role),
                      LocationScreen(email: email, role: role),
                ),
              );
              // Handle button 1 tap
            },
            child: const Text('My Visited Areas'),
          ),
          const SizedBox(height: 8), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewEmployeePage(),
                ),
              );
              // Handle button 2 tap
            },
            child: const Text('Add Employee'),
          ),
          const SizedBox(height: 8), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              // Handle button 3 tap
            },
            child: const Text('Employee Attendance'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: signOutCallback,
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class AreaOfficerLoginPage extends StatefulWidget {
  final String email;
  final String role;

  const AreaOfficerLoginPage(
      {Key? key, required this.email, required this.role})
      : super(key: key);

  @override
  _AreaOfficerLoginPageState createState() => _AreaOfficerLoginPageState();
}

class _AreaOfficerLoginPageState extends State<AreaOfficerLoginPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture;
  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user data
    _userFuture = _getUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .where('role', isEqualTo: widget.role)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first;
        } else {
          throw 'No user found with email ${widget.email} and role ${widget.role}';
        }
      });
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  void _updateLocationInFirestore(String email, String role, double latitude,
      double longitude, bool sharing) {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('role', isEqualTo: role)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          FirebaseFirestore.instance.collection('users').doc(doc.id).update({
            'isSharingLocation': sharing,
            'latitude': latitude,
            'longitude': longitude,
            'timestamp': DateTime.now(),
          }).then((value) =>
              print('Location updated for user: $email, role: $role'));
        }
      } else {
        print('No user found with email: $email and role: $role');
      }
    }).catchError((error) {
      print('Error querying users in Firestore: $error');
    });
  }

  // Sign out method
  Future<void> _signOut(BuildContext context) async {
    try {
      // _updateLocationInFirestore(widget.email, widget.role, 0, 0, false);
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login page after sign out
      // Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), // Replace LoginPage() with your actual login page widget
      );
    } catch (e) {
      print('Sign out failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Area Officer Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Extract user data from snapshot
            Map<String, dynamic> userData = snapshot.data!.data()!;
            return MyDrawer(
              name: userData['name'],
              role: userData['role'],
              email: userData['email'],
              address: userData['address'],
              signOutCallback: () => _signOut(context),
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Extract user data from snapshot
              Map<String, dynamic> userData = snapshot.data!.data()!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome to Area Officer Dashboard',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text('Email: ${widget.email}'),
                  Text('Role: ${widget.role}'),
                  // Show user data fetched from Firestore
                  Text(
                      'Name: ${userData['name']}'), // Adjust field name as per your Firestore schema
                  Text(
                      'Address: ${userData['address']}'), // Adjust field name as per your Firestore schema
                  // Add more user data fields as needed
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
