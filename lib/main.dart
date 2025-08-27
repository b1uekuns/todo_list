import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist/app/product/controllers/auth_controller.dart';
import 'package:todolist/app/product/controllers/theme_controller.dart';
import 'package:todolist/firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init('todo_box');

  Get.put(AuthController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo List',
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.isDarkModeObs.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: Routes.splash,
        getPages: AppPages.routes,
      ),
    );
  }
}
