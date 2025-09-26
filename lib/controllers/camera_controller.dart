import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:get/get_connect/http/src/http/io/file_decoder_io.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> takePhoto(File file) async {
    loading.value = true;
    Get.back();
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
      print("Status code: ${resBody.body}");

      await textToSpeak("Chấm công thành công");
    } else {
      print("Upload lỗi: ${response.statusCode} ${resBody.body}");
      await textToSpeak("Chấm công thất bại, vui lòng thử lại");
    }
    print('============================');
    // final dio = Dio();
    // final formData = FormData.fromMap({
    //   // 's_identification_id': 'SC025001535',
    //   'image': await MultipartFile.fromFile(
    //     file.path,
    //     // filename: file.path.split('/').last,
    //   ),
    // });
    // final response = await dio.post(
    //   'http://172.16.105.189:8000/attendance/detect',
    //   data: formData,
    //   options: Options(headers: {'Accept': 'application/json'}),
    //   onSendProgress: (sent, total) {
    //     print("progress: ${(sent / total * 100).toStringAsFixed(0)}%");
    //   },
    // );
    // if (response.statusCode == 200) {
    //   await textToSpeak("Chấm công thành công");
    //   print(response.data);
    // } else {
    //   await textToSpeak("Chấm công thất bại, vui lòng thử lại");
    // }
    // print("================================");

    loading.value = false;
    // Get.back();
    return true;
  }

  Future<void> detectAttendance(File file) async {
    Get.back();
    final uri = Uri.parse('http://172.16.105.189:8000/attendance/detect');
    final request = http.MultipartRequest("POST", uri);

    // request.fields['s_identification_id'] = 'SC018000172';
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    final response = await request.send();
    final resBody = await http.Response.fromStream(response);

    if (resBody.statusCode == 200) {
      final data = jsonDecode(resBody.body);

      // print("Matched: ${data['matched']}");
      // print("User: ${data['user']}");
      // print("Score: ${data['score']}");
      // print("Time: ${data['at']}");

      // Ví dụ: thông báo bằng SnackBar
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Chấm công thành công: ${data['user']['name']}")),
      // );
    } else {
      print("Upload lỗi: ${resBody.statusCode} ${resBody.body}");
    }
  }
}
