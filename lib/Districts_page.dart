import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DistrictPage extends StatefulWidget {
  @override
  _DistrictPageState createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  final TextEditingController _districtNameController = TextEditingController();
  final TextEditingController _districtCodeController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  List<String> _countries = [];
  List<String> _states = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    QuerySnapshot countriesSnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          countriesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _fetchStates(String country) async {
    QuerySnapshot statesSnapshot = await FirebaseFirestore.instance
        .collection('states')
        .where('Country Name', isEqualTo: country)
        .get();
    setState(() {
      _states = statesSnapshot.docs
          .map((doc) => doc['State Name'] as String)
          .toList();
      _selectedState = null; // Reset selected state when states change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add District'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue;
                  _fetchStates(
                      newValue!); // Fetch states for the selected country
                });
              },
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              hint: Text('Select Country'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedState,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedState = newValue;
                });
              },
              items: _states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              hint: Text('Select State'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _districtNameController,
              decoration: InputDecoration(labelText: 'District Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _districtCodeController,
              decoration: InputDecoration(labelText: 'District Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDistrict,
              child: Text('Save'),
            ),

             Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('districts').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return Card(
                        elevation: 4, // Add elevation for a shadow effect
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin for spacing between cards
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Round the corners of the card
                        ),
                        child: ListTile(
                          // Display data from Firestore...
                          title: Text('District Name: ${data['name']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('District Code: ${data['code']}'),
                              Text('State Name: ${data['state']}'),
                              Text('Country Name: ${data['country']}'),         
                    
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editData(document.id, data),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteData(document.id),
                              ),
                            ],
                          ),
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

  // void _saveDistrict() {
  //   String districtName = _districtNameController.text.trim();
  //   String districtCode = _districtCodeController.text.trim();
    
  //     FirebaseFirestore.instance.collection('districts').add({
  //       'country': _selectedCountry,
  //       'state': _selectedState,
  //       'name': districtName,
  //       'code': districtCode,
  //     });
  //     _districtNameController.clear();
  //     _districtCodeController.clear();
    
  // }
  void _saveDistrict() {
  String districtName = _districtNameController.text.trim();
  String districtCode = _districtCodeController.text.trim();

  // Check if the district already exists
  FirebaseFirestore.instance.collection('districts')
    .where('name', isEqualTo: districtName)
    .where('country', isEqualTo: _selectedCountry)
    .where('state', isEqualTo: _selectedState)
    .get()
    .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        // District does not exist, add it
        FirebaseFirestore.instance.collection('districts').add({
          'country': _selectedCountry,
          'state': _selectedState,
          'name': districtName,
          'code': districtCode,
        }).then((_) {
          // Clear text fields after successful addition
          _districtNameController.clear();
          _districtCodeController.clear();
        }).catchError((error) => print("Failed to add district: $error"));
      } else {
        // District already exists, handle duplicate error
        print("District already exists");
        // You can show an error message or handle as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Duplicate Entry'),
              content: Text('The district already exists in the database.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) => print("Error checking for existing district: $error"));
}


 void _editData(String docId, Map<String, dynamic> currentData) {
  _districtNameController.text = currentData['name'];
  _districtCodeController.text = currentData['code'];
  _selectedCountry = currentData['country'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<void>(
        future: _fetchStates(_selectedCountry!), // Wait for fetching states
        builder: (context, snapshot) {
          return AlertDialog(
            title: Text('Edit Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountry = newValue;
                      print('Selected Country: $_selectedCountry');
                      _fetchStates(_selectedCountry!); // Fetch states for the selected country
                      print(_states);
                    });
                  },
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  hint: Text('Select Country'),
                ),
                //for state
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedState = newValue;
                    });
                  },
                  items: _states.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  hint: Text('Select State'),
                ),
                TextFormField(
                  controller: _districtNameController,
                  decoration: InputDecoration(labelText: 'District name'),
                ),
                TextFormField(
                  controller: _districtCodeController,
                  decoration: InputDecoration(labelText: 'District Code'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Update the document in Firestore
                  FirebaseFirestore.instance.collection('districts').doc(docId).update({
                    'country': _selectedCountry,
                    'state': _selectedState,
                    'name': _districtNameController.text,
                    'code': _districtCodeController.text,
                  }).then((value) {
                    print("State Updated");
                    // Clear text field values
                    _districtCodeController.clear();
                    _districtNameController.clear();
                    setState(() {
                      _selectedCountry = null;
                      _selectedState = null;
                    });
                    // Close the dialog
                    Navigator.pop(context);
                  }).catchError((error) {
                    print("Failed to update state: $error");
                  });
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

  void _deleteData(String docId) {
    // Delete the document from Firestore
    FirebaseFirestore.instance.collection('districts').doc(docId).delete().then((value) {
      print("State Deleted");
    }).catchError((error) {
      print("Failed to delete state: $error");
    });
  }
}


void main() {
  runApp(MaterialApp(
    home: DistrictPage(),
  ));
}
