import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/controllers/camera_controller.dart';
import 'package:sea_attendance/utils/loading_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    FaceController faceController = Get.find<FaceController>();

    return Obx(() {
      return faceController.loading.value
          ? LoadingPage()
          : Scaffold(
              appBar: AppBar(title: const Text('ĐĂNG KÝ KHUÔN MẶT')),
              body: SmartFaceCamera(
                // controller: faceController.controller.value,
                controller: FaceCameraController(
                  autoCapture: true, // tắt auto, mình sẽ điều khiển thủ công
                  defaultCameraLens: CameraLens.front,
                  onCapture: (File? file) async {
                    if (file != null) {
                      // await faceController.textToSpeak("Chụp ảnh thành công");
                      // print(file.path);
                      // await Get.dialog(
                      //   AlertDialog(
                      //     title: const Text('Ảnh chụp'),
                      //     content: Image.file(
                      //       file,
                      //       width: 200,
                      //       height: 200,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // );
                      await faceController.takePhoto(file);
                      // await faceController.detectAttendance(file);
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
