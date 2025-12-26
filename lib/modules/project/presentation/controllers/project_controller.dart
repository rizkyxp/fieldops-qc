import 'package:get/get.dart';

class ProjectController extends GetxController {
  // Observable list of projects
  final RxList<Map<String, dynamic>> projects = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load mock data
    projects.addAll([
      {
        "title": "Safety Inspection Area B",
        "image": "https://picsum.photos/seed/construction_project/800/600",
        "progress": 0.75,
        "personnel": "3 Personnel",
        "supervisor": "https://i.pravatar.cc/150?u=1",
        "status": "in_progress",
        "startDate": DateTime.now().subtract(const Duration(days: 10)),
        "endDate": DateTime.now().add(const Duration(days: 20)),
      },
      {
        "title": "Area B - Maintenance",
        "image": "https://picsum.photos/seed/siteB/400/200",
        "progress": 0.40,
        "personnel": "8 Personnel",
        "supervisor": "https://i.pravatar.cc/150?u=2",
        "status": "in_progress",
        "startDate": DateTime.now().subtract(const Duration(days: 5)),
        "endDate": DateTime.now().add(const Duration(days: 25)),
      },
      {
        "title": "Warehouse A Renovation",
        "image": "https://picsum.photos/seed/warehouse/400/200",
        "progress": 1.0,
        "personnel": "5 Personnel",
        "supervisor": "https://i.pravatar.cc/150?u=3",
        "status": "completed",
        "startDate": DateTime.now().subtract(const Duration(days: 40)),
        "endDate": DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        "title": "Old Site Survey",
        "image": "https://picsum.photos/seed/oldsite/400/200",
        "progress": 1.0,
        "personnel": "2 Personnel",
        "supervisor": "https://i.pravatar.cc/150?u=4",
        "status": "archived",
        "startDate": DateTime.now().subtract(const Duration(days: 100)),
        "endDate": DateTime.now().subtract(const Duration(days: 80)),
      },
    ]);
  }

  void addProject(Map<String, dynamic> project) {
    // Add status if missing, default to in_progress
    if (!project.containsKey("status")) {
      project["status"] = "in_progress";
    }
    // Add default progress and personnel if missing for new projects
    if (!project.containsKey("progress")) {
      project["progress"] = 0.0;
    }
    if (!project.containsKey("personnel")) {
      project["personnel"] =
          "${(project['assignedMembers'] as List).length} Personnel";
    }

    projects.insert(0, project);
  }

  List<Map<String, dynamic>> getProjectsByStatus(String status) {
    return projects.where((p) => p['status'] == status).toList();
  }
}
