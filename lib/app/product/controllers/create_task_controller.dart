import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/todo_controller.dart';

class CreateTaskController extends GetxController {
  static CreateTaskController get to => Get.find<CreateTaskController>();

  final TodoController todoController = Get.find<TodoController>();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final detailsController = TextEditingController();

  final selectedDate = Rxn<DateTime>();
  final selectedCategory = ''.obs;

  final categories = <String>[
    'Design',
    'Development',
    'Coding',
    'Meeting',
    'Office Time',
  ].obs;

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    detailsController.dispose();
    super.onClose();
  }

  void selectDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = selectedCategory.value == category ? '' : category;
  }

  void createTask() async {
    final title = titleController.text.trim();
    final description = detailsController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter task title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    try {
      todoController.add(
        title,
        description: description,
        dueDate: selectedDate.value,
        showSnackbar: false,
      );

      Get.snackbar(
        'Thành công',
        'Tạo task thành công!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      _clearForm();

      await Future.delayed(Duration(seconds: 2));

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tạo task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  void _clearForm() {
    titleController.clear();
    dateController.clear();
    detailsController.clear();
    selectedDate.value = null;
    selectedCategory.value = '';
  }
}
