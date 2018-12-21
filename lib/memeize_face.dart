import 'dart:io';
import 'dart:math';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;

const _memeFaces = [
  "img_awesome_smile.png",
  "img_forever_alone.png",
  "img_hide_the_pain.png",
  "img_me_gusta_face.png",
  "img_okay_face.png",
  "img_yao_ming.png",
  "img_doge_face.png"
];

class MemeizeFaceWidget extends StatelessWidget {
  final File imageFile;

  const MemeizeFaceWidget({Key key, @required this.imageFile})
      : assert(imageFile != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _detectFace(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            color: Colors.black,
            child: Center(
              child: _buildFaceDetectionStack(
                  snapshot.data, MediaQuery.of(context).size),
            ),
          );
        });
  }

  Stack _buildFaceDetectionStack(
      _FaceDetectionResult detection, Size screenSize) {
    var image = detection.rawImage;
    var imageAspectRatio = image.width / image.height;
    var widthRatio = screenSize.width / image.width;
    var heightRatio = (screenSize.height * imageAspectRatio) / image.height;
    List<Widget> children = [Image.file(imageFile)];

    detection.faces.forEach((face) {
      var faceRectangle = face.boundingBox;
      var child = Positioned.fromRect(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.white),
            child: Image.asset(_randomMemeFaceAssetPath()),
          ),
          rect: Rect.fromLTRB(
              faceRectangle.left.toDouble() * widthRatio,
              faceRectangle.top.toDouble() * heightRatio,
              faceRectangle.right.toDouble() * widthRatio,
              faceRectangle.bottom.toDouble() * heightRatio));
      children.add(child);
    });

    return Stack(children: children);
  }

  Future<_FaceDetectionResult> _detectFace() async {
    var faceDetector = FirebaseVision.instance
        .faceDetector(FaceDetectorOptions(mode: FaceDetectorMode.fast));
    var faces = await faceDetector
        .detectInImage(FirebaseVisionImage.fromFile(imageFile));
    var imageBytes = await imageFile.readAsBytes();
    var rawImage = await decodeImageFromList(imageBytes);
    return _FaceDetectionResult(faces, rawImage);
  }

  String _randomMemeFaceAssetPath() {
    return "graphics/${_memeFaces[Random().nextInt(_memeFaces.length)]}";
  }
}

class _FaceDetectionResult {
  final List<Face> faces;
  final ui.Image rawImage;

  _FaceDetectionResult(this.faces, this.rawImage)
      : assert(faces != null),
        assert(rawImage != null);
}
