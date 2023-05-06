// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_smart_home/switch_list.dart';
import 'data.dart';
import 'add_switch.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {"/": (context) => SwitchList(), "/new": (context) => InputForm()},
  ));
}
