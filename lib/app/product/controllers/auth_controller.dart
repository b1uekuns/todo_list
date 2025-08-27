import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';

enum AuthAction { none, login, register, google, facebook, resetPassword }

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = GetStorage('todo_box');

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final lastAction = AuthAction.none.obs;
  final Rxn<User> user = Rxn<User>();
  late Worker _authWorker;

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    _authWorker = ever(user, _handleAuthChanged);
    super.onInit();
  }

  @override
  void onClose() {
    _authWorker.dispose();
    super.onClose();
  }

  void _handleAuthChanged(User? user) {
    if (user != null) {
      storage.write('current_user_id', user.uid);
    } else {
      storage.remove('current_user_id');
    }
  }

  void _setError(Object e, AuthAction action, {String title = 'Auth'}) {
    lastAction.value = action;
    final msg = e is FirebaseAuthException
        ? (e.message?.trim().isNotEmpty == true ? e.message! : e.code)
        : e.toString();
    errorMessage.value = '[$title] $msg';
  }

  void resetError() {
    errorMessage.value = '';
    lastAction.value = AuthAction.none;
  }

  Future<void> register(String email, String password) async {
    isLoading.value = true;
    lastAction.value = AuthAction.register;
    errorMessage.value = '';
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = cred.user;
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _setError(e, AuthAction.register, title: 'register');
    } catch (e) {
      _setError(e, AuthAction.register, title: 'register');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    lastAction.value = AuthAction.login;
    errorMessage.value = '';
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = cred.user;
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _setError(e, AuthAction.login, title: 'login');
    } catch (e) {
      _setError(e, AuthAction.login, title: 'login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _auth.signOut();

      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        //
      }

      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {
        //
      }

      user.value = null;

      Get.offAllNamed('/welcome');
    } catch (e) {
      //
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendResetEmail(String email) async {
    isLoading.value = true;
    lastAction.value = AuthAction.resetPassword;
    errorMessage.value = '';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e, AuthAction.resetPassword, title: 'reset-password');
      return false;
    } catch (e) {
      _setError(e, AuthAction.resetPassword, title: 'reset-password');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    lastAction.value = AuthAction.google;
    errorMessage.value = '';
    try {
      final gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return;
      }
      final gAuth = await gUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await _auth.signInWithCredential(cred);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _setError(e, AuthAction.google, title: 'google');
    } catch (e) {
      _setError(e, AuthAction.google, title: 'google');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithFacebook() async {
    isLoading.value = true;
    lastAction.value = AuthAction.facebook;
    errorMessage.value = '';
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw Exception(result.message ?? 'Facebook sign-in error');
      }
      final token =
          (result.accessToken!.toJson()['token'] ??
                  result.accessToken!.toJson()['tokenString'])
              as String;
      final cred = FacebookAuthProvider.credential(token);
      await _auth.signInWithCredential(cred);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _setError(e, AuthAction.facebook, title: 'facebook');
    } catch (e) {
      _setError(e, AuthAction.facebook, title: 'facebook');
    } finally {
      isLoading.value = false;
    }
  }
}
