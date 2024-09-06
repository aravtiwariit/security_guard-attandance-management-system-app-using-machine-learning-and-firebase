import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Location Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _isSharing = false;
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isSharing
                ? Text('Sharing live location...')
                : Text('Not sharing live location.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isSharing = !_isSharing;
                  if (_isSharing) {
                    _startSharingLocation();
                  } else {
                    _stopSharingLocation();
                  }
                });
              },
              child: _isSharing ? Text('Stop Sharing') : Text('Start Sharing'),
            ),
          ],
        ),
      ),
    );
  }

  void _startSharingLocation() {
    // Request permission to access location
    Geolocator.requestPermission().then((permission) {
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Start listening to the position stream
        _positionStreamSubscription =
            Geolocator.getPositionStream().listen((Position position) {
          // Upload location to Firebase Firestore
          _uploadLocationToFirebase(position);
        });
        setState(() {
          _isSharing = true;
        });
      } else {
        // Handle permission denied
        print('Location permission denied');
      }
    }).catchError((error) {
      // Handle error getting permission
      print('Error getting location permission: $error');
    });
  }

  void _stopSharingLocation() {
    // Cancel position stream subscription
    _positionStreamSubscription.cancel();
    setState(() {
      _isSharing = false;
    });
  }

  void _uploadLocationToFirebase(Position position) {
    // Upload location data to Firebase Firestore
    FirebaseFirestore.instance.collection('locations').add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print('Location uploaded to Firebase');
    }).catchError((error) {
      print('Failed to upload location: $error');
    });
  }
}
