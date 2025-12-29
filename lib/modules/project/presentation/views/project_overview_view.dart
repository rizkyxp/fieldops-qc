import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/project_response_model.dart';
import '../../data/models/add_member_request_model.dart';
import '../controllers/project_controller.dart';
import 'project_detail_view.dart';
import 'project_members_view.dart';
import '../../../reflect/presentation/views/reflect_detail_view.dart';

class ProjectOverviewView extends StatefulWidget {
  final int projectId;
  final ProjectResponseModel? initialData;

  const ProjectOverviewView({
    super.key,
    required this.projectId,
    this.initialData,
  });

  @override
  State<ProjectOverviewView> createState() => _ProjectOverviewViewState();
}

class _ProjectOverviewViewState extends State<ProjectOverviewView> {
  final ProjectController _controller = Get.find<ProjectController>();

  @override
  void initState() {
    super.initState();
    // If we have initial data, render it immediately
    if (widget.initialData != null) {
      _controller.currentProject.value = widget.initialData;
    }
    // Fetch fresh data
    _controller.fetchProjectDetail(widget.projectId);
  }

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
      body: Obx(() {
        final project = _controller.currentProject.value;

        if (_controller.isLoading.value && project == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (project == null) {
          return const Center(child: Text("Project not found"));
        }

        // Data Mapping
        final projectTitle = project.name ?? "Untitled Project";
        final progress = (project.progress ?? 0) / 100.0;
        final personnelCount = "${project.teamMembers?.length ?? 0}";
        final imageUrl = project.imageUrl;
        final teamMembers = project.teamMembers ?? [];

        return CustomScrollView(
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
                  style: TextStyle(
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
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[900],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image_rounded,
                                      color: Colors.white24,
                                      size: 48,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.file(
                              File(imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[900],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image_rounded,
                                      color: Colors.white24,
                                      size: 48,
                                    ),
                                  ),
                                );
                              },
                            )
                    else
                      Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: Colors.white24,
                            size: 48,
                          ),
                        ),
                      ),
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
                            style: const TextStyle(
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
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${_formatDate(project.startDate)} - ${_formatDate(project.endDate)}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Personnel Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Team Members ($personnelCount)",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => ProjectMembersView(members: teamMembers),
                            );
                          },
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...teamMembers.map(
                            (m) => Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: _buildMemberAvatar(
                                m.fullName ?? "Unknown",
                                Colors.blue,
                              ),
                            ),
                          ),
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
                          style: const TextStyle(
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

                    // Floor Plan List - Mocked for now as it's not in ProjectResponseModel yet
                    // Ideally we should add floorPlans to the response model or fetch separately
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
        );
      }),
    );
  }

  Widget _buildMemberAvatar(String name, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(
            name.isNotEmpty ? name[0] : "?",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name.split(' ')[0], // First name
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAddMemberButton() {
    return GestureDetector(
      onTap: () => _showAddMemberModal(context),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.add, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            "Add",
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberModal(BuildContext context) {
    // 1. Trigger user fetch
    _controller.fetchUsers();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 600, // Fixed height or use dynamic
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Team Member",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar (Optional Visual placeholder)
              TextField(
                decoration: InputDecoration(
                  hintText: "Search user...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              // User List
              Expanded(
                child: Obx(() {
                  if (_controller.availableUsers.isEmpty) {
                    // Check if it's because of loading or empty data
                    // Since fetchUsers doesn't strictly set isLoading, we can check empty
                    // But waiting for initial fetch might show "No users found" briefly
                    return const Center(
                      child: Text("No users found or loading..."),
                    );
                  }

                  return ListView.separated(
                    itemCount: _controller.availableUsers.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final user = _controller.availableUsers[index];
                      // Determine if already added (optional)
                      final isAlreadyAdded =
                          _controller.currentProject.value?.teamMembers?.any(
                            (m) => m.id == user.id,
                          ) ??
                          false;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            (user.fullName ?? "?")[0].toUpperCase(),
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                        title: Text(
                          user.fullName ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(user.role?.name ?? "No Role"),
                        trailing: isAlreadyAdded
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : OutlinedButton(
                                onPressed: () {
                                  if (user.id == null) return;

                                  // Call Add Member API
                                  final request = AddMemberRequestModel(
                                    email: user.email ?? "",
                                    userId: user.id!,
                                  );

                                  _controller.addMember(
                                    _controller.currentProject.value!.id!,
                                    request,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Add"),
                              ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
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
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
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
                    style: const TextStyle(
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
                        style: const TextStyle(
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

  String _formatDate(String? dateString) {
    if (dateString == null) return "-";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return dateString.split('T')[0]; // Fallback
    }
  }
}
