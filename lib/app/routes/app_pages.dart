import 'package:get/get.dart';
import 'package:todolist/app/product/bindings/main_binding.dart';
import 'package:todolist/app/product/bindings/onboarding_binding.dart';
import 'package:todolist/app/product/bindings/create_task_binding.dart';
import 'package:todolist/app/product/bindings/calendar_binding.dart';
import 'package:todolist/app/product/bindings/user_binding.dart';
import 'package:todolist/app/product/views/create_task/create_task.dart';
import 'package:todolist/app/product/views/main/main_screen.dart';
import 'package:todolist/app/product/views/splash/splash.dart';
import 'package:todolist/app/product/views/welcome/welcome_page.dart';
import 'package:todolist/app/product/views/onboarding/onboarding_page_view.dart';
import 'package:todolist/app/product/views/login/login_page.dart';
import 'package:todolist/app/product/views/register/register_page.dart';
import 'package:todolist/app/product/views/calendar/calendar_tab.dart';
import 'package:todolist/app/product/views/user/user_tab.dart';

part 'app_routes.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: Routes.welcome, page: () => WelcomePage()),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingPageView(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.register, page: () => RegisterPage()),
    GetPage(
      name: Routes.home,
      page: () => MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(name: Routes.splash, page: () => SplashPage()),

    GetPage(
      name: Routes.createTask,
      page: () => CreateTask(),
      binding: CreateTaskBinding(),
    ),

    GetPage(
      name: Routes.calendar,
      page: () => CalendarTab(),
      binding: CalendarBinding(),
    ),

    GetPage(name: Routes.user, page: () => UserTab(), binding: UserBinding()),
  ];
}
