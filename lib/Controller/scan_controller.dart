import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite/tflite.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFlite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  // late CameraImage cameraImage;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras(); /////////

      cameraController = CameraController(cameras[0], ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.bgra8888);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            ObjectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Permission denied");
    }
  }

  initTFlite() async {
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/label.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  ObjectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );
    if (detector != null) {
      log("Result is $detector");
    }
  }
}
