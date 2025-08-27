import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/bottomnav_controller.dart';
import 'package:todolist/app/product/controllers/calendar_controller.dart';
import 'package:todolist/app/product/controllers/user_controller.dart';
import 'package:todolist/app/product/controllers/todo_controller.dart';
import 'package:todolist/app/product/views/home/home_tab.dart';
import 'package:todolist/app/product/views/alert/alert_tab.dart';
import 'package:todolist/app/product/views/calendar/calendar_tab.dart';
import 'package:todolist/app/product/views/user/user_tab.dart';
import 'package:todolist/app/routes/app_pages.dart';

class MainScreen extends GetView<BottomNavController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return HomeTab();
          case 1:
            // Lazy load controllers cho Calendar tab
            Get.lazyPut(() => TodoController());
            Get.lazyPut(() => CalendarController());
            return CalendarTab();
          case 2:
            return AlertTab();
          case 3:
            // Lazy load controllers cho User tab
            Get.lazyPut(() => UserController());
            return UserTab();
          default:
            return HomeTab();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                color: controller.currentIndex.value == 0
                    ? Colors.orange
                    : Colors.grey,
                onPressed: () => controller.changeTab(0),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: controller.currentIndex.value == 1
                    ? Colors.orange
                    : Colors.grey,
                onPressed: () => controller.changeTab(1),
              ),
              SizedBox(width: 40), // chừa chỗ cho nút +
              IconButton(
                icon: Icon(Icons.add_alert_rounded),
                color: controller.currentIndex.value == 2
                    ? Colors.orange
                    : Colors.grey,
                onPressed: () => controller.changeTab(2),
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: controller.currentIndex.value == 3
                    ? Colors.orange
                    : Colors.grey,
                onPressed: () => controller.changeTab(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 32),
        onPressed: () {
          Get.toNamed(Routes.createTask);
        },
      ),
    );
  }
}
