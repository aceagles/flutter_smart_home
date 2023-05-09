import 'package:flutter/material.dart';
import 'package:flutter_smart_home/data.dart';
import 'package:flutter_smart_home/switch_card.dart';
import 'add_switch.dart';

class SwitchList extends StatefulWidget {
  SwitchList({super.key});

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
    print("Building");
    return Scaffold(
      appBar: AppBar(
        title: Text("Switches"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SwitchEntry>>(
        stream: database?.watchSwitches,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final switchList = snapshot.data!;

          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = switchList.removeAt(oldIndex);
                print(switchList);
                switchList.insert(newIndex, item);
                print(switchList);
                for (int i = 0; i < switchList.length; i++) {
                  print(switchList[i].id);
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
