// ignore_for_file: unused_field, avoid_print, unused_element

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class AreaOfficerLocationPage extends StatefulWidget {
  final String email;
  final String role;

  // ignore: use_super_parameters
  const AreaOfficerLocationPage(
      {Key? key, required this.email, required this.role})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AreaOfficerLocationPageState createState() =>
      _AreaOfficerLocationPageState();
}

class _AreaOfficerLocationPageState extends State<AreaOfficerLocationPage> {
  late StreamSubscription<LocationData> _locationSubscription;
  bool _isSharingLocation = false;
  double _latitude = 0;
  double _longitude = 0;
  File? _image;
  String? _profileUrl;

  @override
  void initState() {
    super.initState();
    // Start listening for location updates when the widget is initialized
    _startLocationUpdates();
  }

  @override
  void dispose() {
    // _pinController.dispose();
    // Cancel the location update subscription when the widget is disposed
    // _locationSubscription.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    _locationSubscription = Location.instance.onLocationChanged.listen(
      (LocationData locationData) {
        setState(() {
          _latitude = locationData.latitude!;
          _longitude = locationData.longitude!;
        });
        // Update Firestore with the new location
        _updateLocationInFirestore(
          widget.email,
          widget.role,
          _latitude,
          _longitude,
          _isSharingLocation,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Officer Location Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //profile image upload here
            ElevatedButton(
              onPressed: () async {
                _takePictureAndUpload();
              },
              child: const Text('Take a picture'),
            ),
            //           _image != null
            //               ? Image.asset(
            //    _image!.path, // Accessing the path property of the File object
            //   width: 100, // Adjust the width and height as needed
            //   height: 100,
            // )
            // : const SizedBox(),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            // TextField(
            //   controller: _pinController,
            //   keyboardType: TextInputType.number,
            //   maxLength: 4,
            //   decoration: InputDecoration(
            //     labelText: 'Enter PIN (4 digits)',
            //   ),
            // ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  LocationData locationData =
                      await Location.instance.getLocation();
                  setState(() {
                    _latitude = locationData.latitude!;
                    _longitude = locationData.longitude!;
                    _isSharingLocation = true;
                  });
                  _updateLocationInFirestore(widget.email, widget.role,
                      _latitude, _longitude, _isSharingLocation);
                } catch (e) {
                  print('Error getting current location: $e');
                }
              },
              child: const Text('Visited'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _locationSubscription.cancel();
                setState(() {
                  _latitude = 0.0;
                  _longitude = 0.0;
                  _isSharingLocation = false;
                });
                _updateLocationInFirestore(widget.email, widget.role, _latitude,
                    _longitude, _isSharingLocation);
              },
              child: const Text('Stop Sharing Live Location'),
            ),
            const SizedBox(height: 20),
            _isSharingLocation ? _buildLocationText() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> _savePin(String pin) async {
    // Encrypt the PIN before storing it in Firestore
    var bytes = utf8.encode(pin); // Convert pin to bytes
    var encryptedPin = sha256.convert(bytes).toString(); // Encrypt the pin

    // Store the encrypted PIN in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email)
        .set({'pin': encryptedPin}, SetOptions(merge: true));

    print('PIN saved successfully!');
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
      print('Error updating location in Firestore: $error');
    });
  }

  Widget _buildLocationText() {
    return Text(
      'Latitude: $_latitude, Longitude: $_longitude',
      style: const TextStyle(fontSize: 18),
    );
  }

  Future<void> _takePictureAndUpload() async {
    permission_handler.PermissionStatus cameraPermissionStatus =
        await permission_handler.Permission.camera.request();
    if (cameraPermissionStatus == permission_handler.PermissionStatus.granted) {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profilePhoto/${DateTime.now().millisecondsSinceEpoch}.jpg');

        UploadTask uploadTask = ref.putFile(imageFile);

        uploadTask.whenComplete(() async {
          String downloadURL = await ref.getDownloadURL();
          setState(() {
            _profileUrl = downloadURL;
          });
          _updateProfilePhotoUrl();
        });

        print('Image uploaded to Firebase Storage.');
      } else {
        print('No image taken.');
      }
    } else {
      print('Camera permission not granted.');
    }
  }

  Future<void> _updateProfilePhotoUrl() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.email)
        .where('role', isEqualTo: widget.role)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          FirebaseFirestore.instance.collection('users').doc(doc.id).update({
            'profile_photo_url': _profileUrl,
          }).then((value) =>
              print('Profile photo URL updated for user: ${widget.email}'));
        }
      } else {
        print(
            'No user found with email: ${widget.email} and role: ${widget.role}');
      }
    });
  }
}
