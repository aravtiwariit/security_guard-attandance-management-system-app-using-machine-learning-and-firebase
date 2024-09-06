import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ReportClientPage extends StatefulWidget {
  @override
  _ReportClientPageState createState() => _ReportClientPageState();
}



class _ReportClientPageState extends State<ReportClientPage> {
   final TextEditingController _clientCategoryController = TextEditingController();
  final TextEditingController _clientVerticalController = TextEditingController();
   String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBranch;
  String? _selectedFieldArea;
  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts=[];
  List<String> _branches=[];
  List<String> _fieldarea=[];
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
  Future<void> _fetchDistricts(String country, String state) async {
  QuerySnapshot districtsSnapshot = await FirebaseFirestore.instance
      .collection('districts')
      .where('country', isEqualTo: country)
      .where('state', isEqualTo: state)
      .get();
  setState(() {
    _districts = districtsSnapshot.docs
        .map((doc) => doc['name'] as String)
        .toList();
    _selectedDistrict = null; // Reset selected district when districts change
  });
}
Future<void> _fetchBranch(String country, String state,String district) async {
  QuerySnapshot branchesSnapshot = await FirebaseFirestore.instance
      .collection('branches')
      .where('Country Name', isEqualTo: country)
      .where('State Name', isEqualTo: state)
      .where('District Name',isEqualTo: district)
      .get();
  setState(() {
    _branches = branchesSnapshot.docs
        .map((doc) => doc['Branch Name'] as String)
        .toList();
    _selectedBranch = null; // Reset selected district when districts change
  });
}

Future<void> _fetchFieldArea(String branch) async {
  QuerySnapshot fieldAreaSnapshot = await FirebaseFirestore.instance
      .collection('field_areas')
      .where('Branch Name',isEqualTo: branch)
      .get();
  setState(() {
    _fieldarea = fieldAreaSnapshot.docs
        .map((doc) => doc['Field Area Name'] as String)
        .toList();
    _selectedFieldArea= null; // Reset selected district when districts change
  });
}



  

  // Function to fetch client data from Firestore
  Future<void> _showClientDetails() async {
    String clientCategory=_clientCategoryController.text.trim();
    String clientVertical=_clientVerticalController.text.trim();
    int i=1;
    // Construct query based on selected options
    Query query = FirebaseFirestore.instance.collection('clients');

    if (_selectedCountry != null) {
      query = query.where('Country', isEqualTo: _selectedCountry);
    }
    if (_selectedState != null) {
      query = query.where('State', isEqualTo: _selectedState);
    }
    if (_selectedDistrict != null) {
      query = query.where('District', isEqualTo: _selectedDistrict);
    }
    if (_selectedBranch != null) {
      query = query.where('Branch', isEqualTo: _selectedBranch);
    }
    if (_selectedFieldArea != null) {
      query = query.where('Area', isEqualTo: _selectedFieldArea);
    }
    if (clientCategory.isEmpty==false){
      query=query.where('Client Category',isEqualTo: clientCategory);

    }
    if (clientVertical.isEmpty==false){
      query=query.where('Client Vertical',isEqualTo: clientVertical);
    }

    // Fetch client data from Firestore
    QuerySnapshot clientSnapshot = await query.get();

    // Extract client data from the query result
    List<Map<String, dynamic>> clientData = clientSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // Display the fetched client data in a dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Client Details'),
    //       content: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.min,
    //         children: clientData.map((client,i) {
    //           return ListTile(
                 
    //             title: Text('${i}Client Name: ${client['Client Name']}'),
    //             subtitle: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
                   
    //                 Text('Current Status: ${client['Current Status']}'),
    //                 Text('Email: ${client['E-Mail']}'),
    //                 // Add more client details as needed
    //               ],
    //             ),
    //           );
    //         }).toList(),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.pop(context); // Close the dialog
    //           },
    //           child: Text('Close'),
    //         ),
    //       ],
    //     );
    //   },
    // );

    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Client Details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(clientData.length, (i) {
          var client = clientData[i];
          return ListTile(
            title: Text('${i + 1}. Client Name: ${client['Client Name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Status: ${client['Current Status']}'),
                Text('Email: ${client['E-Mail']}'),
                // Add more client details as needed
              ],
            ),
          );
        }),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  },
);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Client'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                                  child:DropdownButtonFormField<String>(
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
                    ),

                  
                  SizedBox(height: 20),
                  
                     Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child:DropdownButtonFormField<String>(
                                                        value: _selectedState,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            _selectedState = newValue;
                                                            _fetchDistricts(_selectedCountry!,newValue!);
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
                    ),



                  SizedBox(height: 20),
                  // TextFormField(
                  //   controller: _districtNameController,
                  //   decoration: InputDecoration(labelText: 'District Name'),
                  // ),
                   Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child:DropdownButtonFormField<String>(
                                                        value: _selectedDistrict,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            _selectedDistrict = newValue;
                                                            _fetchBranch(_selectedCountry!,_selectedState!,newValue!);
                                                          });
                                                        },
                                                        items: _districts.map((district) {
                                                          return DropdownMenuItem(
                                                            value: district,
                                                            child: Text(district),
                                                          );
                                                        }).toList(),
                                                        hint: Text('Select District'),
                                                      ),
                    ),

                 
                  

                  SizedBox(height: 10),

            // Branch
             Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child:DropdownButtonFormField<String>(
                                                        value: _selectedBranch,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            _selectedBranch = newValue;
                                                            _fetchFieldArea(newValue!);
                                                          });
                                                        },
                                                        items: _branches.map((branch) {
                                                          return DropdownMenuItem(
                                                            value: branch,
                                                            child: Text(branch),
                                                          );
                                                        }).toList(),
                                                        hint: Text('Select Branch'),
                                                      ),
                    ),

            SizedBox(height: 10),

            // Field Area
             Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                  ),
                                  child:DropdownButtonFormField<String>(
                                                        value: _selectedFieldArea,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            _selectedFieldArea = newValue;
                                                            
                                                          });
                                                        },
                                                        items: _fieldarea.map((field) {
                                                          return DropdownMenuItem(
                                                            value: field,
                                                            child: Text(field),
                                                          );
                                                        }).toList(),
                                                        hint: Text('Select Field Area'),
                                                      ),
                    ),

            SizedBox(height: 10),

            // Client Category
            TextFormField(
               controller: _clientCategoryController,
              decoration: InputDecoration(labelText: 'Client Category'),
            ),
            SizedBox(height: 10),

            // Client Vertical
            TextFormField(
               controller: _clientVerticalController,
              decoration: InputDecoration(labelText: 'Client Vertical'),
            ),
            SizedBox(height: 20),

            // Show button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showClientDetails,
                child: Text(
                  'Show',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            )
            
                          ],
          ),

          
        ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportClientPage(),
  ));
}
