import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'add_switch.dart';

class SwitchCard extends StatefulWidget {
  final String name;
  final String url;
  final Key? key;
  final int id;
  SwitchCard(
      {required this.name, required this.url, required this.id, this.key});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  Timer? timer;
  bool isOn = false;
  bool isConnected = false;
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
    try {
      http.Response response =
          await http.get(Uri.parse("${widget.url}/cm?cmnd=Power"));
      isConnected = true;
      dynamic jsonResponse = jsonDecode(response.body);
      setState(() {
        isOn = jsonResponse['POWER'] == 'ON';
      });
    } catch (e) {
      isConnected = false;
      print(e);
      isOn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputForm(id: widget.id),
            ));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isOn ? Colors.green : Colors.white,
                child: IconButton(
                    onPressed: isConnected
                        ? () {
                            http.get(Uri.parse(
                                "${widget.url}/cm?cmnd=Power%20TOGGLE"));
                            checkIsOn();
                          }
                        : null,
                    icon: Icon(
                      isConnected
                          ? Icons.power_settings_new
                          : Icons.power_off_outlined,
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
