import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  TextEditingController _bankNameController = TextEditingController();
  List<String> _banksList = [];

  @override
  void dispose() {
    _bankNameController.dispose();
    super.dispose();
  }

  void _saveBank() {
    String bankName = _bankNameController.text.trim();
    if (bankName.isNotEmpty) {
      FirebaseFirestore.instance.collection('banks').add({
        'name': bankName,
      });
      setState(() {
        _banksList.add(bankName);
        _bankNameController.clear();
      });
    }
  }

  void _editBank(int index, String bankId) {
    _bankNameController.text = _banksList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Bank'),
          content: TextField(
            controller: _bankNameController,
            decoration: InputDecoration(labelText: 'Bank Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newBankName = _bankNameController.text.trim();
                FirebaseFirestore.instance
                    .collection('banks')
                    .doc(bankId)
                    .update({
                  'name': newBankName,
                });
                setState(() {
                  _banksList[index] = newBankName;
                  _bankNameController.clear();
                  Navigator.of(context).pop();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBank(int index, String bankId) {
    FirebaseFirestore.instance.collection('banks').doc(bankId).delete();
    setState(() {
      _banksList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Employee Bank'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _bankNameController,
              decoration: InputDecoration(labelText: 'Bank Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBank,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('banks').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final banks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: banks.length,
                    itemBuilder: (context, index) {
                      final bank = banks[index];
                      String bankId = bank.id;
                      String bankName = bank['name'];
                      return ListTile(
                        title: Text(bankName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editBank(index, bankId),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteBank(index, bankId),
                            ),
                          ],
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
}

void main() {
  runApp(MaterialApp(
    home: BankPage(),
  ));
}
