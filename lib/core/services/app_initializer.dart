import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';
import '../../modules/auth/presentation/views/login_view.dart';
import '../../modules/dashboard/presentation/views/dashboard_view.dart';

class AppInitializer {
  static Future<String> init() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await dotenv.load(fileName: ".env");

    // Auth Check
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(StorageKeys.accessToken);
    final initialRoute = (token != null && token.isNotEmpty)
        ? DashboardView.route
        : LoginView.route;

    FlutterNativeSplash.remove();
    return initialRoute;
  }
}
