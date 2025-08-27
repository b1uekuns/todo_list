import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/create_task_controller.dart';
import 'package:todolist/app/product/controllers/todo_controller.dart';

class CreateTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(() => TodoController());
    Get.lazyPut<CreateTaskController>(() => CreateTaskController());
  }
}
