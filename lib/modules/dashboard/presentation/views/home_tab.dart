import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../project/presentation/views/project_overview_view.dart';
import '../../../project/presentation/views/all_projects_view.dart';
import '../../../project/presentation/views/widgets/project_card.dart';
import '../../../task/presentation/views/widgets/task_card.dart';
import '../../../activity/presentation/views/widgets/recent_activity_item.dart';
import '../../../activity/presentation/views/recent_activity_view.dart';
import '../../../../core/theme/app_colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning,",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        "Rizky Firmansyah",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<DashboardController>().changeTabIndex(4);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Stats Cards Scrollable
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatCard(
                      "Tasks Pending",
                      "12",
                      Icons.assignment_outlined,
                      Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      "Team Active",
                      "5",
                      Icons.group_outlined,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      "Efficiency",
                      "94%",
                      Icons.trending_up,
                      Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Tasks",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<DashboardController>().changeTabIndex(0);
                    },
                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 230,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        TaskCard(
                          title: "Inspect Machinery",
                          subtitle: "Due Today, 5:00 PM",
                          priority: "High",
                          priorityColor: Colors.redAccent,
                          projectName: "Area B - Maintenance",
                          floorPlan: "Generator Room",
                          onTap: () {},
                        ),
                        TaskCard(
                          title: "Safety Report",
                          subtitle: "Due Tomorrow",
                          priority: "Medium",
                          priorityColor: Colors.orangeAccent,
                          projectName: "Safety Inspection Area B",
                          floorPlan: "Main Hall - Level 1",
                          onTap: () {},
                        ),
                        TaskCard(
                          title: "Team Meeting",
                          subtitle: "Fri, 10:00 AM",
                          priority: "Normal",
                          priorityColor: Colors.blueAccent,
                          projectName: "Site C - Excavation",
                          floorPlan: "Meeting Room A",
                          onTap: () {},
                        ),
                      ],
                    ),

                    // Previous Arrow (Back)
                    if (_currentPage > 0)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _prevPage,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(
                                  alpha: 0.5,
                                ), // More transparent
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 16,
                                color: AppColors.primary.withValues(
                                  alpha: 0.7,
                                ), // Semi-transparent icon
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Next Arrow
                    if (_currentPage < _totalPages - 1)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _nextPage,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(
                                  alpha: 0.5,
                                ), // More transparent
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: AppColors.primary.withValues(
                                  alpha: 0.7,
                                ), // Semi-transparent icon
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ongoing Projects",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const AllProjectsView()),
                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProjectCard(
                      title: "Safety Inspection Area B",
                      imageUrl:
                          "https://picsum.photos/seed/construction_project/800/600",
                      progress: 0.75,
                      personnel: "3 Personnel",
                      supervisorImageUrl: "https://i.pravatar.cc/150?u=1",
                      onTap: () => Get.to(
                        () => const ProjectOverviewView(
                          projectTitle: "Safety Inspection Area B",
                          progress: 0.75,
                          personnelCount: "3 Personnel",
                          imageUrl:
                              "https://picsum.photos/seed/construction_project/800/600",
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ProjectCard(
                      title: "Area B - Maintenance",
                      imageUrl: "https://picsum.photos/seed/siteB/400/200",
                      progress: 0.4,
                      personnel: "8 Personnel",
                      supervisorImageUrl: "https://i.pravatar.cc/150?u=2",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Activity",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const RecentActivityView()),
                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // List Mock
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8), // Tighter spacing
                itemBuilder: (context, index) {
                  final users = [
                    "Rizky Firmansyah",
                    "Andi Saputra",
                    "Budi Santoso",
                    "Siti Aminah",
                  ];
                  final actions = [
                    "Quality Check #10$index",
                    "Safety Inspection Area B",
                    "Team Briefing",
                    "Maintenance Report",
                  ];
                  return RecentActivityItem(
                    userName: users[index % users.length],
                    action: actions[index % actions.length],
                    time: "${index + 2}m ago",
                    isSuccess: index % 3 != 0,
                    onTap: () => _showActivityDetail(
                      context,
                      users[index % users.length],
                      actions[index % actions.length],
                      "${index + 2}m ago",
                      index % 3 != 0,
                    ),
                  );
                },
              ),

              // Spacing for Bottom Navbar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showActivityDetail(
    BuildContext context,
    String userName,
    String action,
    String time,
    bool isSuccess,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSuccess
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    color: isSuccess ? Colors.green : Colors.orange,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Activity",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                action,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Detailed description of this activity would appear here. This is a placeholder for the activity details.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Close",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
