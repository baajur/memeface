import 'package:flutter/material.dart';
import 'package:memeface/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildApp();
  }

  Widget buildApp() {
    return new MaterialApp(
      title: "Meme Face",
      home: Home(),
    );
  }
}