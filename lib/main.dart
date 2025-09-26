// ignore_for_file: depend_on_referenced_packages

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/attendance_page.dart';
import 'package:sea_attendance/home_page.dart';
import 'package:sea_attendance/register_page.dart';
import 'package:sea_attendance/utils/init_binding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // late List<CameraDescription> cameras;
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [Locale('vi'), Locale('en'), Locale('fr')],
      locale: const Locale('vi'),
      initialRoute: "/",
      initialBinding: InitalBinding(),
      getPages: [
        // GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/attendance', page: () => const AttendancePage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        // GetPage(
        //   name: '/all_vocabulary',
        //   page: () => const AllVocabularyScreen(),
        // ),
        // GetPage(name: '/vocabulary', page: () => const VocabularyScreen()),
        // GetPage(name: '/register', page: () => const RegisterScreen()),
        // GetPage(name: '/exercise', page: () => ExerciseScreen()),
        // GetPage(name: '/exercise_detail', page: () => ExerciseDetailScreen()),
        // GetPage(
        //   name: '/exercise_detail_all',
        //   page: () => ExerciseDetailAllScreen(),
        // ),
        // GetPage(name: '/statistic', page: () => StatisticScreen()),
      ],
    );
  }
}
