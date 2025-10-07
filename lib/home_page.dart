import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sea_attendance/controllers/main_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(mainController.titles[mainController.numPage.value]),
            // leading: Builder(
            //   builder: (context) {
            //     return IconButton(
            //       icon: const Icon(Icons.menu),
            //       onPressed: () {
            //         mainController.openDrawer.value = true;
            //         Scaffold.of(context).openDrawer();
            //       },
            //     );
            //   },
            // ),
          ),
          body: mainController.openDrawer.value
              ? Container()
              : mainController.pages[mainController.numPage.value],
          onDrawerChanged: (isOpened) {
            // print('Drawer is now: $isOpened');
            // mainController.openDrawer.value = false;
            mainController.openDrawer.value = !mainController.openDrawer.value;
          },
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Chấm công'),
                  onTap: () {
                    mainController.numPage.value = 0;
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.app_registration),
                  title: const Text('Đăng ký khuôn mặt'),
                  onTap: () {
                    mainController.numPage.value = 1;
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
