# Memeface

A **Flutter** project that combines the power of the `camera` and `firebase_ml_vision` plugins to overlap faces in selfies with random meme faces. :trollface:

<p align="center">
  <img src="Before&#32;memeization.png" width="300"/>
  <img src="After&#32;memeization.png" width="300"/> 
</p>

## Important classes

* `TakePictureWidget` handles the selfie taking and presents its `File` afterwards. It leverages most of its work to the `CameraController`.
* `MemeizeFaceWidget` takes a `File` containing an image and hands it to the `FirebaseVision` face detector to do its job. That job yields a `List<Face>` that are used to overlap `Image` elements on top of them.

## Userful links

* [Flutter Camera Plugin](https://pub.dartlang.org/packages/camera)
* [Flutter ML Vision Plugin](https://pub.dartlang.org/packages/firebase_ml_vision) - Make sure to check [this guide](https://firebase.google.com/docs/flutter/setup) when seting up Firebase in a Flutter project.
* [Official Flutter Page](https://flutter.io/docs)