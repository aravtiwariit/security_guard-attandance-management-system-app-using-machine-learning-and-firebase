import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ZonePageState createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  final TextEditingController _zoneNameController = TextEditingController();
  List<DocumentSnapshot> _zones = [];

  @override
  void initState() {
    super.initState();
    _fetchZones();
  }

  Future<void> _fetchZones() async {
    try {
      QuerySnapshot zonesSnapshot =
          await FirebaseFirestore.instance.collection('zones').get();
      setState(() {
        _zones = zonesSnapshot.docs;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching zones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Zone'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _zoneNameController,
              decoration: const InputDecoration(labelText: 'Zone Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveZone,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Zones List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _zones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Zone Name: ${_zones[index]['Zone Name']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editZone(_zones[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteZone(_zones[index].id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveZone() {
    String zoneName = _zoneNameController.text.trim();
    if (zoneName.isNotEmpty) {
      FirebaseFirestore.instance.collection('zones').add({
        'Zone Name': zoneName,
      });
      _zoneNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter the zone name.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editZone(DocumentSnapshot zone) {
    String zoneName = zone['Zone Name'];
    _zoneNameController.text = zoneName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Zone'),
          content: TextFormField(
            controller: _zoneNameController,
            decoration: const InputDecoration(labelText: 'Zone Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateZone(zone.id, _zoneNameController.text);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteZone(String zoneId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Zone'),
          content: const Text('Are you sure you want to delete this zone?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('zones')
                    .doc(zoneId)
                    .delete();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateZone(String zoneId, String newName) {
    FirebaseFirestore.instance.collection('zones').doc(zoneId).update({
      'Zone Name': newName,
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: ZonePage(),
  ));
}
