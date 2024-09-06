import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientServicesPage extends StatefulWidget {
  @override
  _ClientServicesPageState createState() => _ClientServicesPageState();
}

class _ClientServicesPageState extends State<ClientServicesPage> {
  final TextEditingController _clientServicesController =
      TextEditingController();
  List<DocumentSnapshot> _clientServices = [];

  @override
  void initState() {
    super.initState();
    _fetchClientServices();
  }

  Future<void> _fetchClientServices() async {
    QuerySnapshot clientServicesSnapshot =
        await FirebaseFirestore.instance.collection('client_services').get();
    setState(() {
      _clientServices = clientServicesSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Services'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _clientServicesController,
              decoration: InputDecoration(labelText: 'Client Services'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveClientService,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Client Services List:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _clientServices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Client Service: ${_clientServices[index]['Client Services']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _editClientService(_clientServices[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _deleteClientService(_clientServices[index].id),
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

  void _saveClientService() {
    String clientService = _clientServicesController.text.trim();
    if (clientService.isNotEmpty) {
      FirebaseFirestore.instance.collection('client_services').add({
        'Client Services': clientService,
      }).then((value) {
        _fetchClientServices();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Client Service saved successfully.'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save Client Service: $error'),
          backgroundColor: Colors.red,
        ));
      });
      _clientServicesController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the client service.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editClientService(DocumentSnapshot clientService) {
    String currentClientService = clientService['Client Services'];
    _clientServicesController.text = currentClientService;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Client Service'),
          content: TextFormField(
            controller: _clientServicesController,
            decoration: InputDecoration(labelText: 'Client Services'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateClientService(clientService.id);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteClientService(String clientServiceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Client Service'),
          content: Text('Are you sure you want to delete this client service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('client_services')
                    .doc(clientServiceId)
                    .delete();
                _fetchClientServices(); // Refresh the client services list after deletion
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updateClientService(String clientServiceId) {
    String updatedClientService = _clientServicesController.text.trim();

    FirebaseFirestore.instance
        .collection('client_services')
        .doc(clientServiceId)
        .update({
      'Client Services': updatedClientService,
    }).then((value) {
      _fetchClientServices(); // Refresh the client services list after updating
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Client Service updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update Client Service: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: ClientServicesPage(),
  ));
}
