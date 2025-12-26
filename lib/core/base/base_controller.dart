import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../theme/app_colors.dart';

class BaseController extends GetxController {
  /// Executes an async action (API or Local) with optional global loading and error handling.
  ///
  /// [action] The async function to execute.
  /// [useLoading] If true, shows a global loading dialog. Defaults to false.
  /// [useError] If true, shows a global error snackbar on failure. Defaults to true.
  /// [onSuccess] Optional callback executed on success.
  /// [onError] Optional callback executed on error.
  Future<T?> call<T>({
    required Future<T> Function() action,
    bool useLoading = false,
    bool useError = true,
    Function(T data)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    if (useLoading) {
      _showLoading();
    }

    try {
      final result = await action();
      if (useLoading) {
        _hideLoading();
      }
      if (onSuccess != null) {
        onSuccess(result);
      }
      return result;
    } catch (e) {
      if (useLoading) {
        _hideLoading();
      }

      if (onError != null) {
        onError(e);
      }

      if (useError) {
        _showErrorMessage(e);
      }

      return null;
    }
  }

  void _showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _hideLoading() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _showErrorMessage(dynamic error) {
    String message = "An unexpected error occurred.";
    String title = "Error";

    if (error is DioException) {
      if (error.response != null) {
        title = "Error ${error.response?.statusCode ?? ''}";
      }

      if (error.response?.data is Map) {
        final data = error.response?.data as Map;
        if (data['error'] != null) {
          message = data['error'];
        } else if (data['message'] != null) {
          message = data['message'];
        }
      } else if (error.message != null) {
        message = error.message!;
      }
    } else if (error is Exception) {
      message = error.toString().replaceAll("Exception: ", "");
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
    );
  }
}
