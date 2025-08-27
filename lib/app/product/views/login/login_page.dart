import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.toNamed('/welcome'),
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // Helper: loại bỏ zero-width + trim
  String _sanitizeEmail(String s) =>
      s.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '').trim();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    ever(AuthController.to.user, (user) {
      if (user != null && mounted) {
        Get.offAllNamed('/home');
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthController.to.resetError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitle(),
            _buildFormLogin(),
            _buildOrSplitDivider(),
            _buildSocialLogin(),
            _buildHaveNotAccount(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white.withOpacity(0.87),
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lato',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFormLogin() {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildEmailField(),
            _buildPasswordField(),
            _buildForgotPasswordField(),
            Obx(() {
              if (AuthController.to.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(),
                );
              }
              if (AuthController.to.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AuthController.to.errorMessage.value,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: TextStyle(
              color: Colors.white.withOpacity(0.87),
              fontFamily: 'Lato',
              fontSize: 16,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')), // cấm space
                FilteringTextInputFormatter.deny(
                  RegExp(r'[\u200B-\u200D\uFEFF]'),
                ), // cấm zero-width
              ],
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontFamily: 'Lato',
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Enter your email",
                hintStyle: const TextStyle(
                  color: Color(0xFF535353),
                  fontFamily: 'Lato',
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF979797)),
                ),
                fillColor: const Color(0xFF1D1D1D),
                filled: true,
              ),
              validator: (String? value) {
                final v = _sanitizeEmail(value ?? '');
                if (v.isEmpty) return 'Please enter your email';
                if (!GetUtils.isEmail(v)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.only(top: 16)),
        Text(
          "Password",
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: 'Lato',
            fontSize: 16,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: TextFormField(
            controller: _passwordController,
            style: TextStyle(
              color: Colors.white.withOpacity(0.87),
              fontFamily: 'Lato',
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: const TextStyle(
                color: Color(0xFF535353),
                fontFamily: 'Lato',
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF979797)),
              ),
              fillColor: const Color(0xFF1D1D1D),
              filled: true,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            obscureText: true,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordField() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _openForgotSheet,
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: 'Lato',
            fontSize: 10,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _openForgotSheet() {
    final emailSheetCtrl = TextEditingController(
      text: _sanitizeEmail(_emailController.text),
    );
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: const Color(0xFF1D1D1D),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailSheetCtrl,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                FilteringTextInputFormatter.deny(
                  RegExp(r'[\u200B-\u200D\uFEFF]'),
                ),
              ],
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF232323),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isSnackbarOpen) {
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    final email = _sanitizeEmail(emailSheetCtrl.text);
                    if (!GetUtils.isEmail(email)) {
                      Get.snackbar(
                        'Lỗi',
                        'Vui lòng nhập một địa chỉ email hợp lệ.',
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.all(16),
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    AuthController.to.sendResetEmail(email).then((ok) {
                      if (ok) {
                        emailSheetCtrl.clear();
                        Get.snackbar(
                          'Thành công',
                          'Đã gửi email đặt lại mật khẩu.',
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(16),
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 131, 133, 222),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: _onHandleLoginSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8687E7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          disabledBackgroundColor: const Color(0xFF8687E7).withOpacity(0.5),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Lato",
          ),
        ),
      ),
    );
  }

  Widget _buildOrSplitDivider() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFF979797))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'or',
              style: TextStyle(
                color: Color(0xFF979797),
                fontSize: 16,
                fontFamily: "Lato",
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: const Color(0xFF979797))),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(children: [_buildGoogleButton(), _buildFacebookButton()]);
  }

  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: () => AuthController.to.loginWithGoogle(),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(width: 1, color: Color(0xFF8875FF)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              'Login with Google',
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontSize: 16,
                fontFamily: "Lato",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookButton() {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(top: 20),
      child: OutlinedButton(
        onPressed: () => AuthController.to.loginWithFacebook(),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(width: 1, color: Color(0xFF8875FF)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/facebook.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              'Login with Facebook',
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontSize: 16,
                fontFamily: "Lato",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHaveNotAccount() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: 'Don’t have an account?',
          style: const TextStyle(
            color: Color(0xFF979797),
            fontSize: 12,
            fontFamily: "Lato",
          ),
          children: [
            TextSpan(
              text: ' Register',
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontSize: 12,
                fontFamily: "Lato",
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.toNamed('/register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onHandleLoginSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _sanitizeEmail(_emailController.text);
      final pass = _passwordController.text;
      await AuthController.to.login(email, pass);
    }
  }
}
