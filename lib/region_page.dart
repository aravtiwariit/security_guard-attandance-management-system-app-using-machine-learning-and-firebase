// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegionPage extends StatefulWidget {
  const RegionPage({super.key});

  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  String? _selectedZone;
  final TextEditingController _regionNameController = TextEditingController();

  List<String> _zones = [];
  List<DocumentSnapshot> _regions = [];

  @override
  void initState() {
    super.initState();
    _fetchZones();
    _fetchRegions();
  }

  Future<void> _fetchZones() async {
    QuerySnapshot zonesSnapshot =
        await FirebaseFirestore.instance.collection('zones').get();
    setState(() {
      _zones = zonesSnapshot.docs
          .map((doc) => doc.get('Zone Name') as String)
          .toList();
    });
  }

  Future<void> _fetchRegions() async {
    QuerySnapshot regionsSnapshot =
        await FirebaseFirestore.instance.collection('regions').get();
    setState(() {
      _regions = regionsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Region'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedZone,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedZone = newValue;
                });
              },
              items: _zones.map((zone) {
                return DropdownMenuItem(
                  value: zone,
                  child: Text(zone),
                );
              }).toList(),
              hint: const Text('Select Zone'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _regionNameController,
              decoration: const InputDecoration(labelText: 'Region Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRegion,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Regions List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _regions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Region Name: ${_regions[index]['Region Name']}'),
                  subtitle: Text('Zone: ${_regions[index]['Zone']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editRegion(_regions[index], _zones),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRegion(_regions[index].id),
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

  void _saveRegion() {
    String regionName = _regionNameController.text.trim();

    if (_selectedZone != null && regionName.isNotEmpty) {
      FirebaseFirestore.instance.collection('regions').add({
        'Zone': _selectedZone,
        'Region Name': regionName,
      }).then((value) {
        _fetchRegions();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Region saved successfully.'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save region: $error'),
          backgroundColor: Colors.red,
        ));
      });
      _regionNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a zone and enter the region name.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editRegion(DocumentSnapshot region, List<String> zones) {
    _regionNameController.text = region['Region Name'];
    _selectedZone = region['Zone'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Region'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedZone,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedZone = newValue;
                  });
                },
                items: zones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(zone),
                  );
                }).toList(),
                hint: const Text('Select Zone'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _regionNameController,
                decoration: const InputDecoration(labelText: 'Region Name'),
              ),
            ],
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
                _updateRegion(region.id);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRegion(String regionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Region'),
          content: const Text('Are you sure you want to delete this region?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('regions')
                    .doc(regionId)
                    .delete();
                _fetchRegions(); // Refresh the region list after deletion
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

  void _updateRegion(String regionId) {
    String regionName = _regionNameController.text.trim();

    FirebaseFirestore.instance.collection('regions').doc(regionId).update({
      'Zone': _selectedZone,
      'Region Name': regionName,
    }).then((value) {
      _fetchRegions(); // Refresh the region list after updating
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Region updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update region: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  void dispose() {
    _regionNameController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: RegionPage(),
  ));
}
