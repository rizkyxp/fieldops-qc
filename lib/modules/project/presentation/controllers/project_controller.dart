import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../data/models/add_member_request_model.dart';
import '../../data/models/create_project_request_model.dart';
import '../../data/models/project_response_model.dart';
import '../../data/models/team_member_response_model.dart';
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

  // Current active project detail
  final Rx<ProjectResponseModel?> currentProject = Rx<ProjectResponseModel?>(
    null,
  );

  Future<void> fetchProjectDetail(int id) async {
    // Clear previous data or keep it for optimistic update if desired
    // currentProject.value = null;

    // We can also set a local loading state if needed, but we'll use the main one for now or a separate one
    isLoading.value = true;
    await call(
      action: () => _repository.getProjectDetail(id),
      onSuccess: (data) {
        currentProject.value = data;
      },
      onError: (error) {
        Get.snackbar(
          "Error",
          "Failed to load project details: ${error.toString()}",
        );
      },
    );
    isLoading.value = false;
  }

  // Available users for selection
  final RxList<TeamMemberResponseModel> availableUsers =
      <TeamMemberResponseModel>[].obs;

  Future<void> fetchUsers() async {
    try {
      final users = await _repository.getUsers();
      availableUsers.assignAll(users);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: ${e.toString()}");
    }
  }

  Future<void> addMember(int projectId, AddMemberRequestModel request) async {
    await call(
      action: () => _repository.addMember(projectId, request),
      onSuccess: (_) {
        Get.back(); // Close modal
        Get.snackbar(
          "Success",
          "Team member added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        // Refresh project details
        fetchProjectDetail(projectId);
      },
    );
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
