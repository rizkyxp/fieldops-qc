import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../data/repositories/auth_repository.dart';
// Correct import paths for Views
import '../../../dashboard/presentation/views/dashboard_view.dart';
import '../views/login_view.dart';

class AuthController extends BaseController {
  final AuthRepository _repository = AuthRepository();

  // Observables for text fields to enable validation or reactive UI updates if needed
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // For Signup
  final confirmPasswordController = TextEditingController(); // For Signup

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login Function
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    await call(
      action: () => _repository.login(
        email: emailController.text,
        password: passwordController.text,
      ),
      onSuccess: (data) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.accessToken, data.token);

        Get.snackbar(
          "Success",
          "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        // Navigate to Home using static route
        Get.offAllNamed(DashboardView.route);
      },
    );

    isLoading.value = false;
  }

  // Mock Signup Function
  Future<void> signup() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    isLoading.value = false;

    Get.snackbar(
      "Success",
      "Account created successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
    // Navigate or Go back to Login
    Get.back();
  }

  // Logout Function
  Future<void> logout() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.accessToken);
    isLoading.value = false;

    Get.offAllNamed(LoginView.route);
  }
}
