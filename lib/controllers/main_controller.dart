import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/attendance_page.dart';
import 'package:sea_attendance/register_page.dart';

class MainController extends GetxController {
  RxInt numPage = 0.obs;
  List<Widget> pages = [AttendancePage(), RegisterPage()];
  List<String> titles = ['CHẤM CÔNG', 'ĐĂNG KÝ KHUÔN MẶT'];
  RxBool openDrawer = false.obs;
}
