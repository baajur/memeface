import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memeface/memeize_face.dart';
import 'package:memeface/take_picture.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _imageFile != null ? MemeizeFaceWidget(imageFile: _imageFile) :
        TakePictureWidget(onPictureTaken: (file) {
          setState(() {
            _showSnackbar("Succesfully saved picture!");
            _imageFile = file;
          });
        }),
    );
  }

  void _showSnackbar(String message) {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
