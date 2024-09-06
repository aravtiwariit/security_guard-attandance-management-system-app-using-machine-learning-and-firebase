// ignore_for_file: use_super_parameters, prefer_const_constructors_in_immutables, avoid_print, prefer_const_declarations, unused_field, avoid_init_to_null, library_private_types_in_public_api

import 'dart:async';

import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService(); // Initialize FlutterBackgroundService
  runApp(MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Background Service',
      initialNotificationContent: 'Running in background',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      autoStart: true,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // Start background location updates
  await BackgroundLocation.setAndroidNotification(
    title: 'Background service is running',
    message: 'Background location in progress',
    icon: '@mipmap/ic_launcher',
  );
  await BackgroundLocation.startLocationService(distanceFilter: 20);

  // Periodically fetch location updates
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    BackgroundLocation.getLocationUpdates((location) {
      updateLocationInFirestore(
        'test@example.com',
        'user',
        location.latitude.toString(),
        location.longitude.toString(),
        true,
      );
    });
  });
}

void updateLocationInFirestore(String email, String role, String latitude,
    String longitude, bool? sharing) {
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
        });
      }
    }
  }).catchError((error) {
    print('Error updating location in Firestore: $error');
  });
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationScreen(email: 'test@example.com', role: 'user'),
    );
  }
}

class LocationScreen extends StatefulWidget {
  final String email;
  final String role;

  LocationScreen({Key? key, required this.email, required this.role})
      : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _latitude = 'waiting...';
  String _longitude = 'waiting...';
  String _time = 'waiting...';
  bool? _serviceRunning = null;
  File? _image;
  String? _profileUrl;
  late FlutterBackgroundService _flutterBackgroundService;

  @override
  void initState() {
    super.initState();
    _flutterBackgroundService =
        FlutterBackgroundService(); // Initialize FlutterBackgroundService instance
    _startBackgroundLocationUpdates();
  }

  void _startBackgroundLocationUpdates() async {
    await BackgroundLocation.setAndroidNotification(
      title: 'Background service is running',
      message: 'Background location in progress',
      icon: '@mipmap/ic_launcher',
    );
    await BackgroundLocation.startLocationService(distanceFilter: 20);
    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        _latitude = location.latitude.toString();
        _longitude = location.longitude.toString();
        _time = DateTime.fromMillisecondsSinceEpoch(
          location.time!.toInt(),
        ).toString();
      });
      _updateLocationInFirestore(
        widget.email,
        widget.role,
        _latitude,
        _longitude,
        _serviceRunning,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Visited Information and photo upload'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  if (await _flutterBackgroundService.isRunning()) {
                    _flutterBackgroundService.invoke('setAsForeground');
                  } else {
                    _flutterBackgroundService.startService();
                  }
                },
                child: const Text('Toggle Background Service'),
              ),
              ElevatedButton(
                onPressed: () {
                  BackgroundLocation.stopLocationService();
                },
                child: const Text('Stop Location Updates'),
              ),
              ElevatedButton(
                onPressed: () {
                  BackgroundLocation.isServiceRunning().then((value) {
                    setState(() {
                      _serviceRunning = value;
                    });
                  });
                },
                child: const Text('Check Service Running'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _takePictureAndUpload();
                },
                child: const Text('Take a picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateLocationInFirestore(String email, String role, String latitude,
      String longitude, bool? sharing) {
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

  Future<void> _takePictureAndUpload() async {
    permission_handler.PermissionStatus cameraPermissionStatus =
        await permission_handler.Permission.camera.request();
    if (cameraPermissionStatus == permission_handler.PermissionStatus.granted) {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String timestampWatermark = DateTime.now().toString();
        imageFile = await _addWatermark(imageFile, timestampWatermark);

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
      } else {
        print('No image taken.');
      }
    } else {
      print('Camera permission not granted.');
    }
  }

  Future<File> _addWatermark(File imageFile, String watermarkText) async {
    final ui.Image image =
        await decodeImageFromList(imageFile.readAsBytesSync());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      textBaseline: TextBaseline.alphabetic, // Set the baseline here
    );

    final textSpan = TextSpan(
      text: watermarkText,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offsetX = 20.0;
    final offsetY = 20.0;

    textPainter.paint(
      canvas,
      Offset(offsetX, image.height.toDouble() - textPainter.height - offsetY),
    );

    final picture = recorder.endRecording();
    final watermarkedImage = await picture.toImage(image.width, image.height);
    final byteData =
        await watermarkedImage.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final watermarkedFile = File('${imageFile.path}_watermarked.jpg');
    await watermarkedFile.writeAsBytes(pngBytes);

    return watermarkedFile;
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
            'profile_photo_url': FieldValue.arrayUnion([_profileUrl]),
          }).then((value) =>
              print('Profile photo URL updated for user: ${widget.email}'));
        }
      } else {
        print(
            'No user found with email: ${widget.email} and role: ${widget.role}');
      }
    });
  }

  @override
  void dispose() {
    // No need to dispose _flutterBackgroundService as it doesn't have a dispose method
    super.dispose();
  }
}
