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
  final companyNameController = TextEditingController(); // For Signup
  final confirmPasswordController = TextEditingController(); // For Signup

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Login Function
  Future<void> login() async {
    // ... (existing login code)
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

  // Signup Function
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final companyName = companyNameController.text.trim();
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address",
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        "Weak Password",
        "Password must be at least 8 characters long",
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Password Mismatch",
        "Passwords do not match",
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    await call(
      action: () => _repository.register(
        companyName: companyName,
        name: name,
        email: email,
        password: password,
      ),
      onSuccess: (data) {
        debugPrint("Signup Success: ${data.success}, Message: ${data.message}");
        if (data.success) {
          Get.snackbar(
            "Success",
            data.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          // Wait briefly to ensure snackbar is seen/registered before navigating
          Future.delayed(const Duration(milliseconds: 500));
          Get.offAllNamed(LoginView.route);
        } else {
          debugPrint("Signup Failed: Success is false");
          Get.snackbar(
            "Error",
            data.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      },
      onError: (e) {
        debugPrint("Signup Error: $e");
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      },
    );

    isLoading.value = false;
  }

  // Logout Function
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _repository.logout();
    } catch (e) {
      debugPrint("Logout API error: $e");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.accessToken);
    isLoading.value = false;

    Get.offAllNamed(LoginView.route);
  }
}
