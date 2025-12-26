import 'package:get/get.dart';
import '../modules/auth/presentation/bindings/auth_binding.dart';
import '../modules/auth/presentation/views/login_view.dart';
import '../modules/dashboard/presentation/bindings/dashboard_binding.dart';
import '../modules/dashboard/presentation/views/dashboard_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: LoginView.route,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: DashboardView.route,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
