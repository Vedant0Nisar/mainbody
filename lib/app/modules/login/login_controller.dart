import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  final usernameController = TextEditingController(text: 'admin');
  final passwordController = TextEditingController(text: 'admin123');

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // _checkLoginStatus(); // Commented out to ensure Login is always shown during testing
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter username and password',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authRepository.login(
        usernameController.text,
        passwordController.text,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar(
          'Error',
          'Invalid credentials',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
