import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _checkAppState();
    });
  }

  Future<void> _checkAppState() async {
    final isCompleted = await _isOnboardingCompleted();

    if (!isCompleted) {
      Get.offAllNamed('/onboarding');
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/welcome');
    }
  }

  Future<bool> _isOnboardingCompleted() async {
    final storage = GetStorage('todo_box');
    final result = storage.read('isOnboardingSeen');
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(child: _buildBodyPage()),
    );
  }

  Widget _buildBodyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildIconSplash(), _buildTextSplash()],
      ),
    );
  }

  Widget _buildIconSplash() {
    return Image.asset(
      'assets/images/splash_icon.png',
      width: 95,
      height: 80,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTextSplash() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: const Text(
        'Todo List',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
