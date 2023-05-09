import 'package:flutter/material.dart';
import 'package:flutter_smart_home/data.dart';
import 'package:flutter_smart_home/switch_card.dart';
import 'add_switch.dart';

class SwitchList extends StatefulWidget {
  const SwitchList({super.key});

  @override
  State<SwitchList> createState() => _SwitchListState();
}

class _SwitchListState extends State<SwitchList> {
  MyDatabase? database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await DatabaseProvider.instance.database;
    // trigger rebuild once the database has loaded
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Switches"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SwitchEntry>>(
        stream: database?.watchSwitches,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final switchList = snapshot.data!;

          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                //Reorder the rows now based on new indexes. when going low to high the newIndex is +1 too much for some reason.
                if (newIndex > oldIndex) newIndex -= 1;
                final item = switchList.removeAt(oldIndex);
                switchList.insert(newIndex, item);
                for (int i = 0; i < switchList.length; i++) {
                  database?.setPosition(switchList[i].id, i);
                }
              });
            },
            children: <Widget>[
              for (int i = 0; i < switchList.length; i++)
                SwitchCard(
                    name: switchList[i].name,
                    url: switchList[i].url,
                    id: switchList[i].id,
                    key: UniqueKey()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputForm(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
