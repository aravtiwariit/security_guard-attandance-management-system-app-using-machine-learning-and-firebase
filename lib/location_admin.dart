import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_login_page.dart';
import 'emp_list.dart';

class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  MapWidget({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
        automaticallyImplyLeading:
            true, // This adds a back button automatically
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
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 17, // Set a high zoom level, such as 20
          maxZoom: 20,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: 80,
                height: 80,
                child: Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminLocationPage extends StatefulWidget {
  @override
  _AdminLocationPageState createState() => _AdminLocationPageState();
}

class _AdminLocationPageState extends State<AdminLocationPage> {
  late Stream<List<Map<String, dynamic>>> _areaOfficersStream;

  @override
  void initState() {
    super.initState();
    _areaOfficersStream = streamAreaOfficers();
  }

  Stream<List<Map<String, dynamic>>> streamAreaOfficers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Area Officer')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return {
                'name': doc['name'],
                'email': doc['email'],
                'latitude': doc['latitude'],
                'longitude': doc['longitude'],
              };
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Location Page'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _areaOfficersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> officers = snapshot.data!;
            return ListView.builder(
              itemCount: officers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(officers[index]['name']),
                  subtitle: Text(
                    'Latitude: ${officers[index]['latitude']}, Longitude: ${officers[index]['longitude']}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      double latitude =
                          double.parse(officers[index]['latitude']);
                      double longitude =
                          double.parse(officers[index]['longitude']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapWidget(
                            latitude: latitude,
                            longitude: longitude,
                          ),
                        ),
                      );
                    },
                    child: Text('Show on Map'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
