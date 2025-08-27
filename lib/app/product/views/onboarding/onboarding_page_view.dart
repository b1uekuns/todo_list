import 'package:flutter/material.dart';
import 'package:todolist/app/product/views/onboarding/onboarding_child_page.dart';
import 'package:todolist/app/core/utils/enums/onboarding_page_position.dart';
import 'package:todolist/app/product/controllers/onboarding_controller.dart';

class OnboardingPageView extends StatelessWidget {
  OnboardingPageView({super.key});
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          OnboardingChildPage(
            onboardingPagePosition: OnboardingPagePosition.page1,
            nextOnPressed: () {
              OnboardingController.to.nextPage(pageController);
            },
            backOnPressed: () {
              OnboardingController.to.previousPage(pageController);
            },
            skipOnPressed: () {
              OnboardingController.to.setOnboardingSeen();
              OnboardingController.to.goToWelcomePage(
                isFirstTimeInstallApp: true,
              );
            },
          ),
          OnboardingChildPage(
            onboardingPagePosition: OnboardingPagePosition.page2,
            nextOnPressed: () {
              OnboardingController.to.nextPage(pageController);
            },
            backOnPressed: () {
              OnboardingController.to.previousPage(pageController);
            },
            skipOnPressed: () {
              OnboardingController.to.setOnboardingSeen();
              OnboardingController.to.goToWelcomePage(
                isFirstTimeInstallApp: true,
              );
            },
          ),
          OnboardingChildPage(
            onboardingPagePosition: OnboardingPagePosition.page3,
            nextOnPressed: () {
              OnboardingController.to.setOnboardingSeen();
              OnboardingController.to.goToWelcomePage();
            },
            backOnPressed: () {
              OnboardingController.to.previousPage(pageController);
            },
            skipOnPressed: () {
              OnboardingController.to.setOnboardingSeen();
              OnboardingController.to.goToWelcomePage(
                isFirstTimeInstallApp: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
