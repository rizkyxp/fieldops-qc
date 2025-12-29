import 'package:fieldops_qc/modules/project/presentation/controllers/project_controller.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ProjectController>(() => ProjectController());
  }
}
