import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Country {
  final String name;

  Country({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: CountryPage(),
  ));
}

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  TextEditingController _countryController = TextEditingController();
  List<Country> _countries = [];

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  void _getCountries() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      _countries =
          querySnapshot.docs.map((doc) => Country(name: doc['name'])).toList();
    });
  }

  void _addCountry() async {
    Country newCountry = Country(name: _countryController.text);
    await FirebaseFirestore.instance
        .collection('countries')
        .add(newCountry.toMap());

    _countryController.clear();
    _getCountries();
  }

  void _editCountry(String docId) {
    // Implement edit functionality
  }

  void _deleteCountry(String docId) {
    // Implement delete functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country Name'),
              ),
              ElevatedButton(
                onPressed: _addCountry,
                child: Text('Save'),
              ),
              SizedBox(height: 20),
              Text(
                'Countries List:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _countries.length,
                itemBuilder: (BuildContext context, int index) {
                  var country = _countries[index];
                  return ListTile(
                    title: Text(country.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editCountry(country.name),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteCountry(country.name),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
