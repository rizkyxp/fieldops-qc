import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../project/presentation/views/widgets/project_card.dart';
import 'reflect_detail_view.dart';

class ReflectTab extends StatefulWidget {
  const ReflectTab({super.key});

  @override
  State<ReflectTab> createState() => _ReflectTabState();
}

class _ReflectTabState extends State<ReflectTab> {
  // Default to List View as requested
  bool _isGridView = false;

  // Mock Data for "In Progress" projects
  final List<Map<String, dynamic>> projects = [
    {
      "title": "Safety Inspection Area B",
      "image": "https://picsum.photos/seed/construction_project/800/600",
      "progress": 0.75,
      "personnel": "3 Personnel",
      "supervisor": "https://i.pravatar.cc/150?u=1",
    },
    {
      "title": "Area B - Maintenance",
      "image": "https://picsum.photos/seed/siteB/400/200",
      "progress": 0.40,
      "personnel": "8 Personnel",
      "supervisor": "https://i.pravatar.cc/150?u=2",
    },
    {
      "title": "Site C - Excavation",
      "image": "https://picsum.photos/seed/siteC/400/200",
      "progress": 0.15,
      "personnel": "12 Personnel",
      "supervisor": "https://i.pravatar.cc/150?u=3",
    },
    {
      "title": "Foundation Work Phase 1",
      "image": "https://picsum.photos/seed/foundation/400/200",
      "progress": 0.60,
      "personnel": "15 Personnel",
      "supervisor": "https://i.pravatar.cc/150?u=7",
    },
    {
      "title": "Electrical Grid Setup",
      "image": "https://picsum.photos/seed/electrical/400/200",
      "progress": 0.25,
      "personnel": "5 Personnel",
      "supervisor": "https://i.pravatar.cc/150?u=8",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Reflect",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(
              _isGridView ? Icons.list_alt_rounded : Icons.grid_view_rounded,
              color: AppColors.textPrimary,
            ),
            tooltip: _isGridView
                ? "Switch to List View"
                : "Switch to Grid View",
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _buildProjectItem(context, index, isGrid: true);
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildProjectListItem(context, index);
      },
    );
  }

  Widget _buildProjectListItem(BuildContext context, int index) {
    final project = projects[index];
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ReflectDetailView(
            projectTitle: project['title'],
            progress: project['progress'],
            personnelCount: project['personnel'],
            imageUrl: project['image'],
          ),
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
            // Project Image
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  project['image'],
                  width: 80,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      project['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Supervisor & Personnel Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundImage: NetworkImage(project['supervisor']),
                          onBackgroundImageError: (_, _) {},
                        ),
                        const SizedBox(width: 6),
                        Text(
                          project['personnel'],
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Progress Bar
                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: project['progress'],
                              backgroundColor: AppColors.tertiary.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.secondary,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(project['progress'] * 100).toInt()}%",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow Icon
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(
    BuildContext context,
    int index, {
    required bool isGrid,
  }) {
    final project = projects[index];
    return ProjectCard(
      title: project['title'],
      imageUrl: project['image'],
      progress: project['progress'],
      personnel: project['personnel'],
      supervisorImageUrl: project['supervisor'],
      width: double.infinity,
      onTap: () {
        Get.to(
          () => ReflectDetailView(
            projectTitle: project['title'],
            progress: project['progress'],
            personnelCount: project['personnel'],
            imageUrl: project['image'],
          ),
        );
      },
    );
  }
}
