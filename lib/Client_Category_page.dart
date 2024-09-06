import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientCategoryPage extends StatefulWidget {
  @override
  _ClientCategoryPageState createState() => _ClientCategoryPageState();
}

class _ClientCategoryPageState extends State<ClientCategoryPage> {
  TextEditingController _categoryController = TextEditingController();
  List<String> _categoriesList = [];

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    String category = _categoryController.text;
    if (category.isNotEmpty) {
      FirebaseFirestore.instance.collection('categories').add({
        'name': category,
      });
      setState(() {
        _categoriesList.add(category);
        _categoryController.clear();
      });
    }
  }

  void _editCategory(int index, String categoryId) {
    _categoryController.text = _categoriesList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Client Category'),
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
                String newCategory = _categoryController.text;
                FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoryId)
                    .update({
                  'name': newCategory,
                });
                setState(() {
                  _categoriesList[index] = newCategory;
                  _categoryController.clear();
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

  void _deleteCategory(int index, String categoryId) {
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .delete();
    setState(() {
      _categoriesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Client Category'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCategory,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final categories = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      String categoryId = category.id;
                      String categoryName = category['name'];
                      return ListTile(
                        title: Text(categoryName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editCategory(index, categoryId),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteCategory(index, categoryId),
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
    home: ClientCategoryPage(),
  ));
}
