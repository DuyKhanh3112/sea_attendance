import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/components/custom_button.dart';
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
                  autoCapture: true,
                  defaultCameraLens: CameraLens.front,
                  onCapture: (File? file) async {
                    if (file != null) {
                      final formKey = GlobalKey<FormState>();
                      TextEditingController nameController =
                          TextEditingController();
                      await Get.dialog(
                        AlertDialog(
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Đăng ký khuôn mặt'),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      Get.back();
                                      Get.toNamed('/register');
                                    },
                                    child: const Icon(Icons.close, size: 20),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                          content: Form(
                            key: formKey,
                            child: SizedBox(
                              width: Get.width,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  labelText: 'Mã SC',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mã SC';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          actions: [
                            Column(
                              children: [
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                      title: ' Đăng ký',
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      margin: EdgeInsets.only(right: 16),
                                      onClicked: () async {
                                        if (formKey.currentState!.validate()) {
                                          Get.back();
                                          await faceController.registerFace(
                                            file,
                                            nameController.text,
                                          );

                                          Get.back();
                                          // Get.toNamed('/register');
                                        }
                                      },
                                    ),
                                    CustomButton(
                                      title: 'Hủy',
                                      bgColor: Colors.red,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      onClicked: () async {
                                        Get.back();
                                        Get.back();
                                        Get.toNamed('/register');
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
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
