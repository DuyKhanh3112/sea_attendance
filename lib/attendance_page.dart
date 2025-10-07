import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/controllers/camera_controller.dart';
import 'package:sea_attendance/controllers/main_controller.dart';
import 'package:sea_attendance/utils/loading_page.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    FaceController faceController = Get.find<FaceController>();

    return Obx(() {
      return faceController.loading.value
          ? LoadingPage()
          : Scaffold(
              // appBar: AppBar(title: const Text('CHẤM CÔNG')),
              body: SmartFaceCamera(
                // controller: faceController.controller.value,
                controller: FaceCameraController(
                  autoCapture: true, // tắt auto, mình sẽ điều khiển thủ công
                  defaultCameraLens: CameraLens.front,
                  onCapture: (File? file) async {
                    if (file != null &&
                        !faceController.detected.value &&
                        !Get.find<MainController>().openDrawer.value) {
                      // Map<String, dynamic> res =
                      await faceController.takePhoto(context, file);

                      await Future.delayed(const Duration(seconds: 5));
                      faceController.detected.value = false;
                    }
                  },
                ),
                message: 'Vui lòng đưa khuôn mặt vào khung hình',
                // showControls: false,
                showCaptureControl: false,
                showCameraLensControl: true,
                showFlashControl: false,
              ),
            );
    });
  }
}
