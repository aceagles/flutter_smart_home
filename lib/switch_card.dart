import 'package:flutter/material.dart';

class SwitchCard extends StatefulWidget {
  final String name;
  final String url;
  SwitchCard({required this.name, required this.url});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped");
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.power_settings_new,
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(left: 8.0), child: Text(widget.name))
            ],
          ),
        ),
      ),
    );
  }
}
