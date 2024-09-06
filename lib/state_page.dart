import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatePage extends StatefulWidget {
  @override
  _StatePageState createState() => _StatePageState();
}



class _StatePageState extends State<StatePage> {
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateNameController = TextEditingController();
  TextEditingController _gstStateCodeController = TextEditingController();
  TextEditingController _companyGstinController = TextEditingController();
  TextEditingController _companyAddressController = TextEditingController();
  //  ??hold countries
   List<String> _countries = [];
    String? _selectedCountry;
    @override
        void initState() {
              super.initState();
              // Fetch countries from Firestore when the widget is initialized
              _fetchCountries();
        }

        // Function to fetch countries from Firestore
        Future<void> _fetchCountries() async {
                  try {
                    // Query Firestore collection to get countries
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('countries').get();
                    // Extract country names from documents and add them to the list
                    List<String> countries = [];
                    querySnapshot.docs.forEach((doc) {
                      countries.add(doc['name']);
                    });
                    // Update the state with the fetched countries
                    setState(() {
                      _countries = countries;
                    });
                  } catch (error) {
                    print("Failed to fetch countries: $error");
                  }
        }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('State Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // TextFormFields for input data...
            //  DropdownButtonFormField<String>(
            //   value: _selectedCountry, // selected country value
            //   onChanged: (newValue) {
            //     setState(() {
            //       _selectedCountry = newValue!;
            //     });
            //   },
            //   items: _countries.map((country) {
            //     return DropdownMenuItem(
            //       value: country,
            //       child: Text(country),
            //     );
            //   }).toList(),
            //   decoration: InputDecoration(labelText: 'Country Name'),
            // ),
            
            SizedBox(height: 10),
            //client Name fiels
            Center(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedCountry,
          onChanged: (newValue) {
            setState(() {
              _selectedCountry = newValue!;
            });
          },
          items: _countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(
                country,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Country Name',
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: TextFormField(
          controller: _stateNameController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: 'State Name',
          ),
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: TextFormField(
          controller: _gstStateCodeController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: 'GST State Code',
          ),
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: TextFormField(
          controller: _companyGstinController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: 'Company GSTIN',
          ),
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: TextFormField(
          controller: _companyAddressController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: 'Company Address',
          ),
        ),
      ),

       SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Data List:',
              style: TextStyle(fontSize: 18),
            ),
    ],
  ),

  
),

           
            SizedBox(height: 10),
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('states').snapshots(),
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
                          title: Text('State Name: ${data['State Name']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Country Name: ${data['Country Name']}'),
                              Text('GST State Code: ${data['GST State Code']}'),
                              Text('Company GSTIN: ${data['Company GSTIN']}'),
                              Text('Company Address: ${data['Company Address']}'),
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
      ),
    );
  }

  Future<void> _saveData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('states')
          .where('Country Name', isEqualTo: _selectedCountry)
          .where('State Name', isEqualTo: _stateNameController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('states').add({
          'Country Name': _selectedCountry,
          'State Name': _stateNameController.text,
          'GST State Code': _gstStateCodeController.text,
          'Company GSTIN': _companyGstinController.text,
          'Company Address': _companyAddressController.text,
        }).then((value) {
          print("State Added");
          _countryController.clear();
          _stateNameController.clear();
          _gstStateCodeController.clear();
          _companyGstinController.clear();
          _companyAddressController.clear();
          setState(() {
            _selectedCountry = null;
          });
        }).catchError((error) {
          print("Failed to add state: $error");
        });
      } else {
        print("State already exists");
        // Show an alert dialog to inform the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Duplicate Entry'),
              content: Text('The state already exists in the database.'),
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
    } catch (error) {
      print("Failed to check for duplicates: $error");
    }
  }
  void _editData(String docId, Map<String, dynamic> currentData) {
    _countryController.text = currentData['Country Name'];
    _stateNameController.text = currentData['State Name'];
    _gstStateCodeController.text = currentData['GST State Code'];
    _companyGstinController.text = currentData['Company GSTIN'];
    _companyAddressController.text = currentData['Company Address'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country Name'),
              ),
              TextFormField(
                controller: _stateNameController,
                decoration: InputDecoration(labelText: 'State Name'),
              ),
              TextFormField(
                controller: _gstStateCodeController,
                decoration: InputDecoration(labelText: 'GST State Code'),
              ),
              TextFormField(
                controller: _companyGstinController,
                decoration: InputDecoration(labelText: 'Company GSTIN'),
              ),
              TextFormField(
                controller: _companyAddressController,
                decoration: InputDecoration(labelText: 'Company Address'),
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
                FirebaseFirestore.instance.collection('states').doc(docId).update({
                  'Country Name': _countryController.text,
                  'State Name': _stateNameController.text,
                  'GST State Code': _gstStateCodeController.text,
                  'Company GSTIN': _companyGstinController.text,
                  'Company Address': _companyAddressController.text,
                }).then((value) {
                  print("State Updated");
                  // Clear text field values
                  _countryController.clear();
                  _stateNameController.clear();
                  _gstStateCodeController.clear();
                  _companyGstinController.clear();
                  _companyAddressController.clear();
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
  }

  void _deleteData(String docId) {
    // Delete the document from Firestore
    FirebaseFirestore.instance.collection('states').doc(docId).delete().then((value) {
      print("State Deleted");
    }).catchError((error) {
      print("Failed to delete state: $error");
    });
  }
}







