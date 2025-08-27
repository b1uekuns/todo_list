import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/bottomnav_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Chỉ register BottomNavController cho MainScreen
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
