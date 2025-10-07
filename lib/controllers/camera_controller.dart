// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:sea_attendance/components/custom_button.dart';
import 'package:sea_attendance/config.dart';

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

  Future<void> textToSpeak(String text) async {
    FlutterTts flutterTts = FlutterTts();
    // await flutterTts.setEngine("com.google.android.tts");
    // final engines = await flutterTts.getEngines;
    // print("Engines: $engines");
    final langs = await flutterTts.getLanguages;
    // print("Supported languages: $langs");

    // await flutterTts.setLanguage('vi-VN');
    if (langs.contains("vi-VN")) {
      await flutterTts.setLanguage("vi-VN");
    } else {
      // fallback nếu không có tiếng Việt
      await flutterTts.setLanguage("en-US"); // hoặc eng-default
    }
    await flutterTts.setPitch(1); // 0.5 - 2.0
    await flutterTts.setSpeechRate(1); // 0.0 - 1.0
    await flutterTts.setVolume(1.0); // 0.0 - 1.0
    await flutterTts.speak(text);
  }

  Future<void> takePhoto(BuildContext context, File file) async {
    bool flag = false;

    loading.value = true;
    Uri uri = Uri.parse('${Config.url}/attendance/detect');
    final request = http.MultipartRequest("POST", uri);

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

    if (resBody.statusCode == 200) {
      final data = jsonDecode(resBody.body);
      print('=====================================');
      print(data);
      if (data['user'] != null) {
        flag = true;
        // showAlert("Chấm công thành công", file);
        showCustomAlert(
          context,
          'Xin chào, ${data['user']['name']}. Chấm công thành công',
          file,
        );
        await textToSpeak(
          "Xin chào, ${data['user']['name']}. Chấm công thành công",
        );
        // await Future.delayed(const Duration(seconds: 2));
      } else {
        flag = false;
      }
    } else {
      await textToSpeak("Chấm công thất bại, vui lòng thử lại");
      flag = false;
    }
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
    // await Future.delayed(const Duration(seconds: 5));
    loading.value = false;
  }

  Future<void> registerFace(File file, String sIdentificationId) async {
    loading.value = true;
    detected.value = true;
    Uri uri = Uri.parse('${Config.url}/users/register');
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

    if (resBody.statusCode == 200) {
      await textToSpeak("Đăng ký khuôn mặt thành công");
    } else {
      await textToSpeak("Đăng ký khuôn mặt thất bại, vui lòng thử lại");
    }
    loading.value = false;
  }

  void showAlert(String message, File file) {
    Get.snackbar(
      "Thành công", // Tiêu đề
      "Tệp đã được tải lên", // Nội dung
      icon: Image.file(
        file,
        height: Get.width * 0.4,
        width: Get.width * 0.3,
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.white,
      colorText: Colors.black,
      duration: const Duration(seconds: 5), // ⏱ Hiển thị trong 5 giây
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
    // Get.snackbar(title, message)
    // final snackBar = SnackBar(
    //   content: Column(
    //     children: [
    //       Image.file(file, height: 100),
    //       Text(message),
    //       Text('Thông báo sẽ tự ẩn sau 5 giây'),
    //     ],
    //   ),
    //   duration: const Duration(seconds: 5), // ⏱ hiển thị trong 5 giây
    //   behavior: SnackBarBehavior.floating, // nổi lên (đẹp hơn)
    // );

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showCustomAlert(BuildContext context, String message, File file) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 100,
        left: 20,
        right: 20,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.file(
                  file,
                  height: Get.width * 0.4,
                  width: Get.width * 0.3,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(message, style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }
}
