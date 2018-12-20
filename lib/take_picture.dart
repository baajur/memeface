import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureWidget extends StatelessWidget {
  final Future<CameraController> _cameraControllerReady =
      Future<CameraController>(() async {
        List<CameraDescription> descriptions = await availableCameras();
        var frontCamera = descriptions
            .firstWhere((it) => it.lensDirection == CameraLensDirection.front);
        var cameraController =
          CameraController(frontCamera, ResolutionPreset.high);
        await cameraController.initialize();
        return cameraController;
      });
  final Function(File) onPictureTaken;

  TakePictureWidget({Key key, @required this.onPictureTaken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cameraControllerReady,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return _FullscreenCameraPreview(
              cameraController: snapshot.data, onPictureTaken: onPictureTaken);
        });
  }
}

class _FullscreenCameraPreview extends StatefulWidget {
  final Function(File) onPictureTaken;
  final CameraController cameraController;

  const _FullscreenCameraPreview(
      {Key key, @required this.cameraController, @required this.onPictureTaken})
      : super(key: key);


  @override
  _FullscreenCameraPreviewState createState() => _FullscreenCameraPreviewState();
}

class _FullscreenCameraPreviewState extends State<_FullscreenCameraPreview> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double cameraAspectRatio = widget.cameraController.value.aspectRatio;
    Size previewSize = Size(screenHeight * cameraAspectRatio, screenHeight);

    return Stack(
      children: [
        OverflowBox(
          child: CameraPreview(widget.cameraController),
          minHeight: previewSize.height,
          maxHeight: previewSize.height,
          minWidth: previewSize.width,
          maxWidth: previewSize.width,
        ),
        Align(
          alignment: Alignment(0, 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                    widget.cameraController.value.isTakingPicture
                        ? "Hold on, taking picture"
                        : "Tap to memeize picture",
                    style: TextStyle(color: Colors.white)),
              ),
              GestureDetector(
                onTap: widget.cameraController.value.isTakingPicture
                    ? null
                    : _takePicture,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.white, width: 2.0),
                          bottom: BorderSide(color: Colors.white, width: 2.0),
                          right: BorderSide(color: Colors.white, width: 2.0),
                          left: BorderSide(color: Colors.white, width: 2.0)),
                      shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _takePicture() async {
    Directory tempDirectory = await getTemporaryDirectory();
    var picturePath = "${tempDirectory.path}/${_timestamp()}.jpg";

    try {
      await widget.cameraController.takePicture(picturePath);
    } catch (e) {
      print("Error saving picture!");
      return;
    }

    print("Saved picture to $picturePath");
    widget.onPictureTaken(File(picturePath));
  }

  String _timestamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    widget.cameraController?.dispose();
    super.dispose();
  }
}