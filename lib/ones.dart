import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_helper.dart';

class Ones extends StatefulWidget {
  const Ones({super.key});

  @override
  State<Ones> createState() => _OnesState();
}

class _OnesState extends State<Ones> {
  // initisal satate
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Create List
  List<Map<String, dynamic>> _allData = [];
  // Create Function For REFRSH
  // bool variable for refresh
  bool _isLoading = true;
  void _refreshData() async {
    final dataR = await SqlHelper.getAllData();
    setState(() {
      _allData = dataR;
      _isLoading = false;
    });
  }

  // : 1 call function
  Future<void> _addData() async {
    await SqlHelper.createNote(
      _titleController.text,
      _noteController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The Note Is Created Successfully'),
      ),
    );
    _refreshData();
  }

  // 2: Create Function For Update
  Future<void> _updateData(int id) async {
    await SqlHelper.updateData(
      id,
      _titleController.text,
      _noteController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The Note Is Updated Successfully'),
      ),
    );
    _refreshData();
  }

  // 3: Delete
  Future<void> _deleteData(int idd) async {
    await SqlHelper.deleteData(idd);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The Note Is Deleted Successfully'),
      ),
    );
    _refreshData();
  }

  // create controller for inputs title & note
  // 1 title controller
  TextEditingController _titleController = TextEditingController();
  // 2 note controller
  TextEditingController _noteController = TextEditingController();
  bool isLoading = false;
  // Keys
  // 1 Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Bottom Sheet Function ()
  void bottomSheet(int? id) async {
    if (id != null) {
      final exisData = _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = exisData['title'];
      _noteController.text = exisData['note'];
    }
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 18,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // title input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                    16,
                  ))),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'The title is required';
                  }

                  // Check if the value is a valid email address

                  return null;
                },
              ),
              // sized box
              SizedBox(
                height: 12,
              ),
              // note input
              TextFormField(
                maxLines: 5,
                controller: _noteController,
                decoration: InputDecoration(
                  focusColor: Colors.amberAccent,
                  hintText: 'The Note',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                      16,
                    )),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'The note is required';
                  }

                  // Check if the value is a valid email address

                  return null;
                },
              ),
              // sized box
              SizedBox(
                height: 12,
              ),
              // add button
              Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      if (id == null) {
                        await _addData();
                      } else {
                        await _updateData(id);
                      }
                      _titleController.clear();
                      _noteController.clear();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 42, vertical: 10),
                    child: Text(
                      id == null ? 'Add' : 'Edit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Colors.amberAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () {
          bottomSheet(null);
        },
        child: Icon(Icons.add),
      ),
      // appBar
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
        title: Text(
          'Khaled Note App',
        ),
      ),
      // body
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(4),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    _allData[index]['title'],
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    _allData[index]['note'],
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // update ICON
                      IconButton(
                        color: Colors.amber,
                        onPressed: () {
                          bottomSheet(_allData[index]['id']);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      // delete ICON
                      IconButton(
                        color: Colors.red,
                        onPressed: () {
                          _deleteData(_allData[index]['id']);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: _allData.length,
            ),
    );
  }
}
