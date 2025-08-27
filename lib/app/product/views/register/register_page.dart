import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/auth_controller.dart';
import 'package:todolist/app/product/views/login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  String _sanitizeEmail(String s) =>
      s.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '').trim();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthController.to.resetError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageTitle(),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmailField(),
                      _buildPasswordField(),
                      _buildConfirmPasswordField(),
                      Obx(() {
                        if (AuthController.to.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (AuthController.to.errorMessage.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              AuthController.to.errorMessage.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      _buildRegisterButton(),
                    ],
                  ),
                ),
                _buildHaveAnAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle() => Text(
    'Register',
    style: TextStyle(
      color: Colors.white.withOpacity(0.87),
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          "Email",
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: 'Lato',
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
            FilteringTextInputFormatter.deny(RegExp(r'[\u200B-\u200D\uFEFF]')),
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
          validator: (value) {
            final v = _sanitizeEmail(value ?? '');
            if (v.isEmpty) return 'Please enter your email';
            if (!GetUtils.isEmail(v))
              return 'Please enter a valid email address';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Password",
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: 'Lato',
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
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
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Please enter your password';
            if (value.length < 6)
              return 'Password must be at least 6 characters';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Confirm Password",
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: 'Lato',
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          style: TextStyle(
            color: Colors.white.withOpacity(0.87),
            fontFamily: 'Lato',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: "Re-enter your password",
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
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Please confirm your password';
            if (value != _passwordController.text)
              return 'Passwords do not match';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: _onRegisterPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8687E7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          disabledBackgroundColor: const Color(0xFF8687E7).withOpacity(0.5),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Lato",
          ),
        ),
      ),
    );
  }

  Widget _buildHaveAnAccount() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: const TextStyle(
            color: Color(0xFF979797),
            fontSize: 12,
            fontFamily: "Lato",
          ),
          children: [
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white.withOpacity(0.87),
                fontSize: 12,
                fontFamily: "Lato",
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.off(() => LoginPage()),
            ),
          ],
        ),
      ),
    );
  }

  void _onRegisterPressed() {
    if (AuthController.to.isLoading.value) return; // chống bấm trùng
    if (_formKey.currentState?.validate() ?? false) {
      final email = _sanitizeEmail(_emailController.text);
      final pass = _passwordController.text;
      AuthController.to.register(email, pass);
      // Điều hướng sẽ do listener authState ở Login hoặc do controller thực hiện.
    }
  }
}
