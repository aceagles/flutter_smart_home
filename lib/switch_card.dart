import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SwitchCard extends StatefulWidget {
  final String name;
  final String url;
  SwitchCard({required this.name, required this.url});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  Timer? timer;
  bool isOn = false;
  @override
  void initState() {
    super.initState();
    checkIsOn();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkIsOn());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkIsOn() async {
    http.Response response =
        await http.get(Uri.parse("${widget.url}/cm?cmnd=Power"));
    dynamic jsonResponse = jsonDecode(response.body);
    setState(() {
      isOn = jsonResponse['POWER'] == 'ON';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isOn ? Colors.green : Colors.white,
                child: IconButton(
                    onPressed: () {
                      http.get(
                          Uri.parse("${widget.url}/cm?cmnd=Power%20TOGGLE"));
                      checkIsOn();
                    },
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
