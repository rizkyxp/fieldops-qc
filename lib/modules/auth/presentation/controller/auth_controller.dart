import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
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

  // Mock Login Function
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
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    isLoading.value = false;

    Get.snackbar(
      "Success",
      "Logged in successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
    // Navigate to Home
    Get.offAllNamed('/dashboard');
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
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    isLoading.value = false;

    Get.offAllNamed('/login');
  }
}
