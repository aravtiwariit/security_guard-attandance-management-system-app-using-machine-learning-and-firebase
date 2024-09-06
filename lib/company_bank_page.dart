import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyBanksPage extends StatefulWidget {
  @override
  _CompanyBanksPageState createState() => _CompanyBanksPageState();
}

class _CompanyBanksPageState extends State<CompanyBanksPage> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();

  List<DocumentSnapshot> _banks = [];

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  Future<void> _fetchBanks() async {
    QuerySnapshot banksSnapshot =
        await FirebaseFirestore.instance.collection('company_banks').get();
    setState(() {
      _banks = banksSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Banks'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _bankNameController,
              decoration: InputDecoration(labelText: 'Bank Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _branchController,
              decoration: InputDecoration(labelText: 'Branch'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _accountNoController,
              decoration: InputDecoration(labelText: 'Account No.'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _ifscCodeController,
              decoration: InputDecoration(labelText: 'IFSC Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBank,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Text(
              'Company Banks List:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _banks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Bank Name: ${_banks[index]['Bank Name']}'),
                  subtitle: Text('Branch: ${_banks[index]['Branch']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editBank(_banks[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteBank(_banks[index].id),
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

  void _saveBank() {
    String bankName = _bankNameController.text.trim();
    String branch = _branchController.text.trim();
    String address = _addressController.text.trim();
    String accountNo = _accountNoController.text.trim();
    String ifscCode = _ifscCodeController.text.trim();

    if (bankName.isNotEmpty &&
        branch.isNotEmpty &&
        address.isNotEmpty &&
        accountNo.isNotEmpty &&
        ifscCode.isNotEmpty) {
      FirebaseFirestore.instance.collection('company_banks').add({
        'Bank Name': bankName,
        'Branch': branch,
        'Address': address,
        'Account No.': accountNo,
        'IFSC Code': ifscCode,
      }).then((value) {
        _fetchBanks();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bank details saved successfully.'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save bank details: $error'),
          backgroundColor: Colors.red,
        ));
      });
      _bankNameController.clear();
      _branchController.clear();
      _addressController.clear();
      _accountNoController.clear();
      _ifscCodeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editBank(DocumentSnapshot bank) {
    _bankNameController.text = bank['Bank Name'];
    _branchController.text = bank['Branch'];
    _addressController.text = bank['Address'];
    _accountNoController.text = bank['Account No.'];
    _ifscCodeController.text = bank['IFSC Code'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Bank Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(labelText: 'Bank Name'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _branchController,
                  decoration: InputDecoration(labelText: 'Branch'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _accountNoController,
                  decoration: InputDecoration(labelText: 'Account No.'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _ifscCodeController,
                  decoration: InputDecoration(labelText: 'IFSC Code'),
                ),
              ],
            ),
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
                _updateBank(bank.id);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBank(String bankId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Bank'),
          content: Text('Are you sure you want to delete this bank?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('company_banks')
                    .doc(bankId)
                    .delete();
                _fetchBanks(); // Refresh the bank list after deletion
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

  void _updateBank(String bankId) {
    String bankName = _bankNameController.text.trim();
    String branch = _branchController.text.trim();
    String address = _addressController.text.trim();
    String accountNo = _accountNoController.text.trim();
    String ifscCode = _ifscCodeController.text.trim();

    FirebaseFirestore.instance.collection('company_banks').doc(bankId).update({
      'Bank Name': bankName,
      'Branch': branch,
      'Address': address,
      'Account No.': accountNo,
      'IFSC Code': ifscCode,
    }).then((value) {
      _fetchBanks(); // Refresh the bank list after updating
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bank details updated successfully.'),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update bank details: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: CompanyBanksPage(),
  ));
}
