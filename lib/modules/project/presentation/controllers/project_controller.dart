import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../data/models/create_project_request_model.dart';
import '../../data/models/project_response_model.dart';
import '../../data/repositories/project_repository.dart';

class ProjectController extends BaseController {
  final ProjectRepository _repository = ProjectRepository();

  // Observable list of projects
  final RxList<ProjectResponseModel> projects = <ProjectResponseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    isLoading.value = true;
    await call(
      action: () => _repository.getProjects(),
      onSuccess: (data) {
        projects.assignAll(data);
      },
      useLoading: false, // Don't show global loading dialog
    );
    isLoading.value = false;
  }

  Future<void> createProject(CreateProjectRequestModel projectData) async {
    isLoading.value = true;
    await call(
      action: () => _repository.createProject(projectData),
      onSuccess: (data) {
        Get.snackbar(
          "Success",
          "Project Created Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        projects.insert(0, data);
        Get.back();
      },
    );
    isLoading.value = false;
  }

  List<ProjectResponseModel> getProjectsByStatus(String status) {
    if (status == 'all') return projects;

    // Temporary: "semua project masih satu dulu saja di in progress semua"
    if (status == 'in_progress') {
      return projects;
    }

    // Register dependency to avoid "Improper use of GetX" error, even if we return empty
    if (projects.isEmpty) {
      // access property to register listener
      debugPrint("accessed");
    }

    return [];
  }
}
