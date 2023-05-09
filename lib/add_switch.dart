import 'package:flutter/material.dart';
import 'package:flutter_smart_home/data.dart';
import 'package:drift/drift.dart' as dft;

class InputForm extends StatefulWidget {
  final int? id;
  const InputForm({super.key, this.id});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  MyDatabase? database;
  bool isUpdating = false;
  late SwitchEntry updatingSwitch;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await DatabaseProvider.instance.database;

    //Check if an id was provided by the previous view. if so populate the form and set to edit mode.
    if (widget.id != null) {
      int _id = widget.id!;
      updatingSwitch = await database!.getSwitch(_id);
      _nameController.text = updatingSwitch.name;
      _urlController.text = updatingSwitch.url;
      setState(() {
        isUpdating = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Switch"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _urlController,
                    decoration: const InputDecoration(labelText: "URL"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Center(
                      child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            // if we're updating then replace an entry with the new values.
                            // persist the id and the position but take the others form the form
                            if (isUpdating) {
                              database?.updateSwitch(SwitchEntry(
                                  id: updatingSwitch.id,
                                  name: _nameController.text,
                                  url: _urlController.text,
                                  position: updatingSwitch.position));
                            }
                            // if adding new then add a name and controller text and let position
                            // and ID be dealt with by the database
                            else {
                              await database?.addSwitch(SwitchesCompanion(
                                name: dft.Value(_nameController.text),
                                url: dft.Value(_urlController.text),
                              ));
                            }
                            // Go back home after editing.
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          },
                          child: Text(isUpdating ? "Update" : "Add")),
                      const SizedBox(
                        height: 16,
                      ),
                      if (isUpdating)
                        ElevatedButton(
                            onPressed: () async {
                              await database?.deleteSwitch(updatingSwitch.id);
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/'));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text("Delete")),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
