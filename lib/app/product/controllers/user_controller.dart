import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist/app/product/controllers/auth_controller.dart';
import 'package:todolist/app/product/controllers/theme_controller.dart';

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();

  final _storage = GetStorage('todo_box');

  final userName = 'User'.obs;
  final userEmail = ''.obs;

  bool get isDarkMode => Get.find<ThemeController>().isDarkMode;
  RxBool get isDarkModeObs => Get.find<ThemeController>().isDarkModeObs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadThemeMode();
  }

  void _loadUserData() {
    try {
      final authController = Get.find<AuthController>();
      if (authController.user.value != null) {
        userEmail.value = authController.user.value?.email ?? '';
        userName.value = authController.user.value?.displayName ?? 'User';
      }
    } catch (e) {
      userName.value = 'User';
      userEmail.value = '';
    }
  }

  void _loadThemeMode() {}

  void toggleDarkMode() {
    final themeController = Get.find<ThemeController>();
    themeController.toggleTheme();
  }

  Future<void> logout() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: $e');
    }
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void updateUserName(String name) {
    userName.value = name;
    _storage.write('userName', name);
    update();
  }

  void reloadUserData() {
    _loadUserData();
    update();
  }
}
