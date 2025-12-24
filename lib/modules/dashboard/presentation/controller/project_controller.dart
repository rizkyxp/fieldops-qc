import 'package:get/get.dart';

class ProjectController extends GetxController {
  // Observable list of projects
  var projects = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with Mock Data
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
        "address": "123 Safety St, Area B",
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
        "address": "456 Maintenance Rd, Area B",
      },
      {
        "title": "Site C - Excavation",
        "image": "https://picsum.photos/seed/siteC/400/200",
        "progress": 0.15,
        "personnel": "12 Personnel",
        "supervisor": "https://i.pravatar.cc/150?u=3",
        "status": "in_progress",
        "startDate": DateTime.now().subtract(const Duration(days: 2)),
        "endDate": DateTime.now().add(const Duration(days: 40)),
        "address": "789 Excavation Ln, Site C",
      },
      {
        "title": "Warehouse A Renovation",
        "image": "https://picsum.photos/seed/warehouse/400/200",
        "progress": 1.0,
        "personnel": "Completed",
        "supervisor": "https://i.pravatar.cc/150?u=4",
        "status": "completed",
        "startDate": DateTime.now().subtract(const Duration(days: 60)),
        "endDate": DateTime.now().subtract(const Duration(days: 10)),
        "address": "101 Warehouse Blvd, Zone A",
      },
      {
        "title": "Parking Lot Paving",
        "image": "https://picsum.photos/seed/paving/400/200",
        "progress": 1.0,
        "personnel": "Completed",
        "supervisor": "https://i.pravatar.cc/150?u=5",
        "status": "completed",
        "startDate": DateTime.now().subtract(const Duration(days: 40)),
        "endDate": DateTime.now().subtract(const Duration(days: 5)),
        "address": "202 Paving Way, Lot P",
      },
      {
        "title": "Old Site Survey",
        "image": "https://picsum.photos/seed/oldsite/400/200",
        "progress": 1.0,
        "personnel": "Archived",
        "supervisor": "https://i.pravatar.cc/150?u=6",
        "status": "archived",
        "startDate": DateTime.now().subtract(const Duration(days: 100)),
        "endDate": DateTime.now().subtract(const Duration(days: 80)),
        "address": "303 Old Site Rd, Sector 7",
      },
    ]);
  }

  void addProject(Map<String, dynamic> project) {
    // Force status to in_progress for new projects
    project['status'] = 'in_progress';
    // Ensure personnel string format if not provided
    if (!project.containsKey('personnel')) {
      int count = (project['assignedMembers'] as List?)?.length ?? 0;
      project['personnel'] = "$count Personnel";
    }
    // Default progress
    project['progress'] = 0.0;

    // Add to beginning of list
    projects.insert(0, project);
  }

  List<Map<String, dynamic>> getProjectsByStatus(String status) {
    return projects.where((p) => p['status'] == status).toList();
  }
}
