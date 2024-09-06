import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShiftPageState createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  final TextEditingController _shiftNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  List<DocumentSnapshot> _shifts = [];

  @override
  void initState() {
    super.initState();
    _fetchShifts();
  }

  Future<void> _fetchShifts() async {
    try {
      QuerySnapshot shiftsSnapshot =
          await FirebaseFirestore.instance.collection('shifts').get();
      setState(() {
        _shifts = shiftsSnapshot.docs;
      });
    } catch (e) {
      print('Error fetching shifts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shift'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _shiftNameController,
              decoration: const InputDecoration(labelText: 'Shift Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _startTimeController,
              decoration: const InputDecoration(labelText: 'Start Time'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _endTimeController,
              decoration: const InputDecoration(labelText: 'End Time'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _hoursController,
              decoration: const InputDecoration(labelText: 'Hours'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveShift,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Shifts List:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _shifts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Shift Name: ${_shifts[index]['Shift Name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Time: ${_shifts[index]['Start Time']}'),
                      Text('End Time: ${_shifts[index]['End Time']}'),
                      Text('Hours: ${_shifts[index]['Hours']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editShift(_shifts[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteShift(_shifts[index].id),
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

  void _saveShift() {
    String shiftName = _shiftNameController.text.trim();
    String startTime = _startTimeController.text.trim();
    String endTime = _endTimeController.text.trim();
    String hours = _hoursController.text.trim();

    if (shiftName.isNotEmpty &&
        startTime.isNotEmpty &&
        endTime.isNotEmpty &&
        hours.isNotEmpty) {
      FirebaseFirestore.instance.collection('shifts').add({
        'Shift Name': shiftName,
        'Start Time': startTime,
        'End Time': endTime,
        'Hours': hours,
      });
      _shiftNameController.clear();
      _startTimeController.clear();
      _endTimeController.clear();
      _hoursController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editShift(DocumentSnapshot shift) {
    String shiftName = shift['Shift Name'];
    String startTime = shift['Start Time'];
    String endTime = shift['End Time'];
    String hours = shift['Hours'];

    _shiftNameController.text = shiftName;
    _startTimeController.text = startTime;
    _endTimeController.text = endTime;
    _hoursController.text = hours;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Shift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _shiftNameController,
                decoration: const InputDecoration(labelText: 'Shift Name'),
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(labelText: 'Start Time'),
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(labelText: 'End Time'),
              ),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(labelText: 'Hours'),
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
                _updateShift(shift.id);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteShift(String shiftId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Shift'),
          content: const Text('Are you sure you want to delete this shift?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('shifts')
                    .doc(shiftId)
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

  void _updateShift(String shiftId) {
    String shiftName = _shiftNameController.text.trim();
    String startTime = _startTimeController.text.trim();
    String endTime = _endTimeController.text.trim();
    String hours = _hoursController.text.trim();

    if (shiftName.isNotEmpty &&
        startTime.isNotEmpty &&
        endTime.isNotEmpty &&
        hours.isNotEmpty) {
      FirebaseFirestore.instance.collection('shifts').doc(shiftId).update({
        'Shift Name': shiftName,
        'Start Time': startTime,
        'End Time': endTime,
        'Hours': hours,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: ShiftPage(),
  ));
}
