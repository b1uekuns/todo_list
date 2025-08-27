import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final _storage = GetStorage('todo_box');
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  RxBool get isDarkModeObs => _isDarkMode;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    _isDarkMode.value = _storage.read('isDarkMode') ?? false;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.write('isDarkMode', _isDarkMode.value);
  }

  ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardTheme: CardThemeData(color: Colors.white, elevation: 2),
  );

  ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(color: Color(0xFF1E1E1E), elevation: 2),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(color: Colors.white70),
    colorScheme: ColorScheme.dark(
      primary: Colors.orange,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
  );
}
