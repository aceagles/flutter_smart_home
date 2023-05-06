import 'package:flutter/material.dart';
import 'package:flutter_smart_home/data.dart';
import 'package:drift/drift.dart' as dft;
import 'package:flutter_smart_home/switch_list.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  MyDatabase? database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await DatabaseProvider.instance.database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Switch"),
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
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(labelText: "URL"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Center(
                      child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            final urlT = _urlController.text;
                            print(await database?.addSwitch(SwitchesCompanion(
                              name: dft.Value(_nameController.text),
                              url: dft.Value(_urlController.text),
                            )));
                            print("Added");
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          },
                          child: Text("Add")),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await database?.deleteAllSwitches();
                          },
                          child: Text("Clear")),
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
