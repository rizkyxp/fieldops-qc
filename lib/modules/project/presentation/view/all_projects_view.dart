import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/project_card.dart';
import 'project_overview_view.dart';
import 'create_project_view.dart';
import '../controller/project_controller.dart';

class AllProjectsView extends StatelessWidget {
  const AllProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final ProjectController controller = Get.put(ProjectController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
          title: Text(
            "All Projects",
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            tabs: const [
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
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
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
          return ProjectCard(
            title: project['title'],
            imageUrl: project['image'],
            progress: project['progress'],
            personnel: project['personnel'],
            supervisorImageUrl: project['supervisor'],
            width: double.infinity, // Fill grid cell
            onTap: () {
              // Navigate to overview only for active projects for now, or all if robust
              Get.to(
                () => ProjectOverviewView(
                  projectTitle: project['title'],
                  progress: project['progress'],
                  personnelCount: project['personnel'],
                  imageUrl: project['image'],
                ),
              );
            },
          );
        },
      );
    });
  }
}
