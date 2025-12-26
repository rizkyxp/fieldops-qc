import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/presentation/binding/auth_binding.dart';
import 'modules/auth/presentation/view/login_view.dart';
import 'modules/dashboard/presentation/binding/dashboard_binding.dart';
import 'modules/dashboard/presentation/view/dashboard_view.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FieldOps QC',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialBinding:
          AuthBinding(), // Bind global dependencies or initial page binding
      home: const LoginView(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardView(),
          binding: DashboardBinding(),
        ),
      ],
    );
  }
}
