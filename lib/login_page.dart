// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, unused_field, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_login_page.dart'; // Import AdminLoginPage
import 'area_officer_login_page.dart'; // Import AreaOfficerLoginPage
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  String? _fetchedRole;
  @override
  void initState() {
    super.initState();
    // Retrieve stored preferences data for email and role
    _retrieveStoredPreferences();
  }

  Future<void> _retrieveStoredPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedRole = prefs.getString('role');

    if (storedEmail != null && storedRole != null) {
      // Auto-login if email and role are stored
      setState(() {
        _emailController.text = storedEmail;
        _selectedRole = storedRole; // Set the selected role here
      });
    }
  }

  // Method to handle user login
  Future<void> _login(BuildContext context) async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .get();
      if (userQuery.docs.isNotEmpty) {
        // Extract the role from the user document
        String? role = userQuery.docs.first.get('role');
        //store the data in shared preferences for further use
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _emailController.text);
        prefs.setString('role', role ?? '');
        // Navigate based on selected role
        if (_selectedRole == role && role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminLoginPage(),
            ),
          );
        } else if (_selectedRole == role && role == 'Area Officer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AreaOfficerLoginPage(
                  email: _emailController.text, role: _selectedRole ?? ""),
            ),
          );
        } else {
          // Handle other roles or unauthorized access
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Select the right role'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User does not exists.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle login failure
      // ignore: avoid_print
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        flexibleSpace: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.red, // Setting the app bar background color to red
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            // Dropdown for role selection
            DropdownButtonFormField<String>(
              value: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              items: ['Admin', 'Area Officer'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Select Role'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
