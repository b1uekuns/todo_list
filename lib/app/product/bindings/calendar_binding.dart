import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/calendar_controller.dart';
import 'package:todolist/app/product/controllers/todo_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(() => TodoController());
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
