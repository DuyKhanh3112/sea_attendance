import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/components/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Sea Attendance')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                title: 'CHẤM CÔNG',
                onClicked: () async {
                  // await FaceCamera.initialize();
                  Get.toNamed('/attendance');
                },
              ),
              CustomButton(
                title: 'ĐĂNG KÝ KHUÔN MẶT',
                onClicked: () async {
                  Get.toNamed('/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
