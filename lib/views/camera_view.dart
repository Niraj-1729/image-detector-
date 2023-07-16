import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_detection_app/Controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.amber.shade100,
              ),
              child: GetBuilder<ScanController>(
                  init: ScanController(),
                  builder: (controller) {
                    return controller.isCameraInitialized.value
                        ? CameraPreview(controller.cameraController)
                        : const Center(
                            child: Text("Loading Preview..."),
                          );
                  }),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 130,
            color: Colors.blue,
            // child: const Text("Niraj"),
          ),
        ],
      ),
    );
  }
}
