// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:sea_attendance/components/custom_button.dart';

class FaceController extends GetxController {
  Rx<FaceCameraController> controller = FaceCameraController(
    autoCapture: false,
    defaultCameraLens: CameraLens.front,
    onCapture: (File? image) async {
      // await textToSpeak("Chụp ảnh thành công");
    },
    onFaceDetected: (Face? face) {
      //Do something
      if (face != null) {
        // textToSpeak(' Phát hiện khuôn mặt');
      }
    },
  ).obs;
  RxBool detected = false.obs;
  Rx<File> image = File('').obs;
  RxBool loading = false.obs;

  // @override
  // void onInit() {
  //   controller.value = FaceCameraController(
  //     autoCapture: false, // tắt auto, mình sẽ điều khiển thủ công
  //     defaultCameraLens: CameraLens.front,
  //     onCapture: (File? file) async {
  //       if (file != null) {
  //         await textToSpeak("Chụp ảnh thành công");
  //       }
  //     },
  //     onFaceDetected: (Face? face) async {
  //       if (face != null) {
  //         await textToSpeak(' Phát hiện khuôn mặt');
  //       } else {
  //         detected.value = false; // reset khi không thấy mặt nữa
  //       }
  //     },
  //   );

  //   super.onInit();
  // }

  Future<void> textToSpeak(String text) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('vi-VN'); // hỗ trợ "vi-VN", "en-US", ...
    await flutterTts.setPitch(1); // 0.5 - 2.0
    await flutterTts.setSpeechRate(0.5); // 0.0 - 1.0
    await flutterTts.setVolume(1.0); // 0.0 - 1.0
    await flutterTts.speak(text);
  }

  Future<Map<String, dynamic>> takePhoto(File file) async {
    bool flag = false;
    String message = '';

    loading.value = true;
    Uri uri = Uri.parse('http://172.16.105.189:8000/attendance/detect');
    final request = http.MultipartRequest("POST", uri);

    // request.fields['s_identification_id'] = 'SC021000670';

    Uint8List fileBytes = await file.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', // tên field trong API
        fileBytes, // dữ liệu bytes
        filename: file.path.split('/').last, // tên file gửi kèm
      ),
    );
    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
    });

    final response = await request.send();
    final resBody = await http.Response.fromStream(response);
    print('============================');

    if (resBody.statusCode == 200) {
      print("data: ${resBody.body}");

      await textToSpeak("Chấm công thành công");
      flag = true;
      message = "Chấm công thành công";
    } else {
      // print("Upload lỗi: ${response.statusCode} ${resBody.body}");
      await textToSpeak("Chấm công thất bại, vui lòng thử lại");
      flag = false;
      message = "Chấm công thất bại, vui lòng thử lại";
    }
    print('============================');
    if (!flag) {
      final formKey = GlobalKey<FormState>();
      TextEditingController nameController = TextEditingController();
      await Get.dialog(
        AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Đăng ký khuôn mặt'),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.back();
                      // Get.toNamed('/register');
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
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      margin: EdgeInsets.only(right: 16),
                      onClicked: () async {
                        if (formKey.currentState!.validate()) {
                          Get.back();
                          registerFace(file, nameController.text);

                          Get.back();
                          // Get.toNamed('/register');
                        }
                      },
                    ),
                    CustomButton(
                      title: 'Hủy',
                      bgColor: Colors.red,
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      onClicked: () async {
                        Get.back();
                        Get.back();
                        // Get.toNamed('/register');
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

    loading.value = false;
    return {'success': flag, 'message': message};
  }

  Future<Map<String, dynamic>> registerFace(
    File file,
    String sIdentificationId,
  ) async {
    bool flag = false;
    String message = '';

    loading.value = true;
    detected.value = true;
    Uri uri = Uri.parse('http://172.16.105.189:8000/users/register');
    final request = http.MultipartRequest("POST", uri);

    request.fields['s_identification_id'] = sIdentificationId;

    Uint8List fileBytes = await file.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes(
        'images', // tên field trong API
        fileBytes, // dữ liệu bytes
        filename: file.path.split('/').last, // tên file gửi kèm
      ),
    );
    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
    });

    final response = await request.send();
    final resBody = await http.Response.fromStream(response);
    print('============================');

    if (resBody.statusCode == 200) {
      print("data: ${resBody.body}");

      await textToSpeak("Đăng ký khuôn mặt thành công");
      flag = true;
      message = "Đăng ký khuôn mặt thành công";
    } else {
      print("Upload lỗi: ${response.statusCode} ${resBody.body}");
      await textToSpeak("Đăng ký khuôn mặt thất bại, vui lòng thử lại");
      flag = false;
      message = "Đăng ký khuôn mặt thất bại, vui lòng thử lại";
    }
    loading.value = false;
    return {'success': flag, 'message': message};
  }
}
