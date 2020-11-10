import 'package:flutter/material.dart';
import 'package:mask_detection/pages/home.dart';

void main() {

  runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home' : (context) => Home(),
      }
  ));
}
