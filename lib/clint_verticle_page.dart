import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientVerticalPage extends StatefulWidget {
  @override
  _ClientVerticalPageState createState() => _ClientVerticalPageState();
}

class _ClientVerticalPageState extends State<ClientVerticalPage> {
  final TextEditingController _clientVerticalController =
      TextEditingController();

  List<DocumentSnapshot> _clientVerticals = [];

  @override
  void initState() {
    super.initState();
    _fetchClientVerticals();
  }

  Future<void> _fetchClientVerticals() async {
    QuerySnapshot clientVerticalsSnapshot =
        await FirebaseFirestore.instance.collection('client_verticals').get();
    setState(() {
      _clientVerticals = clientVerticalsSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Vertical'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _clientVerticalController,
              decoration: InputDecoration(labelText: 'Client Vertical'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveClientVertical,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Client Vertical List:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _clientVerticals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Client Vertical: ${_clientVerticals[index]['Client Vertical']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _editClientVertical(_clientVerticals[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _deleteClientVertical(_clientVerticals[index].id),
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

  void _saveClientVertical() {
    String clientVertical = _clientVerticalController.text.trim();

    if (clientVertical.isNotEmpty) {
      FirebaseFirestore.instance.collection('client_verticals').add({
        'Client Vertical': clientVertical,
      }).then((value) {
        _fetchClientVerticals();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Client vertical saved successfully.'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save client vertical: $error'),
          backgroundColor: Colors.red,
        ));
      });
      _clientVerticalController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the client vertical.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editClientVertical(DocumentSnapshot clientVertical) {
    _clientVerticalController.text = clientVertical['Client Vertical'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Client Vertical'),
          content: TextFormField(
            controller: _clientVerticalController,
            decoration: InputDecoration(labelText: 'Client Vertical'),
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
                _updateClientVertical(clientVertical.id);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteClientVertical(String clientVerticalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Client Vertical'),
          content:
              Text('Are you sure you want to delete this client vertical?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('client_verticals')
                    .doc(clientVerticalId)
                    .delete();
                _fetchClientVerticals(); // Refresh the client vertical list after deletion
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

  void _updateClientVertical(String clientVerticalId) {
    String clientVertical = _clientVerticalController.text.trim();

    FirebaseFirestore.instance
        .collection('client_verticals')
        .doc(clientVerticalId)
        .update({
      'Client Vertical': clientVertical,
    }).then((value) {
      _fetchClientVerticals(); // Refresh the client vertical list after updating
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Client vertical updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update client vertical: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  void dispose() {
    _clientVerticalController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: ClientVerticalPage(),
  ));
}
