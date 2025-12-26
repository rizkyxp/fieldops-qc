import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'project_detail_view.dart';
import '../../../reflect/presentation/views/reflect_detail_view.dart';

class ProjectOverviewView extends StatelessWidget {
  final String projectTitle;
  final double progress;
  final String personnelCount;
  final String imageUrl;

  const ProjectOverviewView({
    super.key,
    required this.projectTitle,
    required this.progress,
    required this.personnelCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar("Chat", "Team Chat Feature Coming Soon");
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Sliver App Bar with Image
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                projectTitle,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Section
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ReflectDetailView(
                          projectTitle: projectTitle,
                          progress: progress,
                          personnelCount: personnelCount,
                          imageUrl: imageUrl,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Progress",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: AppColors.tertiary.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${(progress * 100).toInt()}% Completed",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              "Deadline: Dec 31, 2025",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Personnel Section
                  Text(
                    "Team Members ($personnelCount)",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildMemberAvatar("Rizky F.", Colors.blue),
                        const SizedBox(width: 12),
                        _buildMemberAvatar("Andi S.", Colors.orange),
                        const SizedBox(width: 12),
                        _buildMemberAvatar("Budi K.", Colors.green),
                        const SizedBox(width: 12),
                        _buildMemberAvatar("Siti A.", Colors.purple),
                        const SizedBox(width: 12),
                        _buildAddMemberButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Inspection Section (The "List Denah")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Inspection",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            // Mock Add Action
                            Get.snackbar(
                              "Info",
                              "Add Inspection Feature Coming Soon",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Floor Plan List
                  _buildFloorPlanCard(
                    context,
                    id: "fp_001",
                    title: "Ground Floor Area",
                    progress: 0.85,
                    imageAsset:
                        "assets/WhatsApp Image 2025-12-22 at 14.18.20.jpeg",
                  ),
                  const SizedBox(height: 16),
                  _buildFloorPlanCard(
                    context,
                    id: "fp_002",
                    title: "Level 1 - Office",
                    progress: 0.45,
                    imageAsset:
                        "assets/WhatsApp Image 2025-12-22 at 14.18.20.jpeg", // Using same placeholder for now
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(String name, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(
            name[0],
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name.split(' ')[0], // First name
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddMemberButton() {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.add, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          "Add",
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFloorPlanCard(
    BuildContext context, {
    required String id,
    required String title,
    required double progress,
    required String imageAsset,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProjectDetailView(id: id, title: title, imagePath: imageAsset),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                imageAsset,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppColors.tertiary.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primary.withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
