import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/project_card.dart';
import 'project_overview_view.dart';
import 'create_project_view.dart';
import '../controllers/project_controller.dart';

class AllProjectsView extends StatelessWidget {
  const AllProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Find Controller (injected via DashboardBinding)
    final ProjectController controller = Get.find<ProjectController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
          title: const Text(
            "All Projects",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: "In Progress"),
              Tab(text: "Completed"),
              Tab(text: "Archived"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const CreateProjectView());
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: TabBarView(
          children: [
            _buildProjectList(controller, "in_progress"),
            _buildProjectList(controller, "completed"),
            _buildProjectList(controller, "archived"),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(ProjectController controller, String status) {
    return Obx(() {
      final projects = controller.getProjectsByStatus(status);

      if (projects.isEmpty) {
        return Center(
          child: Text(
            "No projects found",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75, // Adjust for card height
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          // Determine status? or just show all
          return ProjectCard(
            title: project.name ?? "Untitled Project",
            imageUrl: project.imageUrl,
            progress: (project.progress ?? 0) / 100.0,
            personnel: "${project.teamMembers?.length ?? 0} Personnel",
            supervisorImageUrl:
                "https://i.pravatar.cc/150?u=${project.id}", // Placeholder
            width: double.infinity, // Fill grid cell
            onTap: () => Get.to(
              () => ProjectOverviewView(
                projectId: project.id!,
                initialData: project,
              ),
            ),
          );
        },
      );
    });
  }
}
