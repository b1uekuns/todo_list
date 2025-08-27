import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class OnboardingController extends GetxController {
  var isOnboardingSeen = false.obs;
  var currentPage = 0.obs;
  final storage = GetStorage('todo_box');

  static OnboardingController get to => Get.find<OnboardingController>();

  @override
  void onInit() {
    super.onInit();
    checkOnboardingStatus();
  }

  void checkOnboardingStatus() {
    isOnboardingSeen.value = storage.read('isOnboardingSeen') ?? false;
  }

  void setOnboardingSeen() {
    storage.write('isOnboardingSeen', true);
    isOnboardingSeen.value = true;
  }

  void nextPage(PageController pageController) {
    if (currentPage.value < 2) {
      pageController.jumpToPage(currentPage.value + 1);
      currentPage.value++;
    }
  }

  void previousPage(PageController pageController) {
    if (currentPage.value > 0) {
      pageController.jumpToPage(currentPage.value - 1);
      currentPage.value--;
    }
  }

  void goToWelcomePage({bool isFirstTimeInstallApp = true}) {
    Get.toNamed('/welcome', arguments: true);
  }
}
