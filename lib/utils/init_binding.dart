import 'package:get/get.dart';
import 'package:sea_attendance/controllers/camera_controller.dart';

class InitalBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<YourController>(() => YourController());
    Get.put(FaceController());
  }
}
