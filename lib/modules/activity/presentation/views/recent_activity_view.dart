import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/recent_activity_item.dart';

class RecentActivityView extends StatelessWidget {
  const RecentActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> activities = [
      {
        "user": "Rizky Firmansyah",
        "action": "Quality Check #100",
        "time": "2m ago",
        "success": true,
        "detail":
            "Verified structural integrity of Column A-3. All measurements within tolerance.",
      },
      {
        "user": "Andi Saputra",
        "action": "Safety Inspection Area B",
        "time": "15m ago",
        "success": false,
        "detail":
            "Found loose wiring in Panel Box 2. Flagged for immediate maintenance.",
      },
      {
        "user": "Budi Santoso",
        "action": "Team Briefing",
        "time": "1h ago",
        "success": true,
        "detail":
            "Conducted morning briefing with the excavation team. Discussed safety protocols.",
      },
      {
        "user": "Siti Aminah",
        "action": "Maintenance Report",
        "time": "2h ago",
        "success": true,
        "detail": "Submitted monthly maintenance log for Generator Unit 4.",
      },
      {
        "user": "Rizky Firmansyah",
        "action": "Material Request Approved",
        "time": "3h ago",
        "success": true,
        "detail": "Approval granted for 50 bags of cement type B.",
      },
      {
        "user": "Joko Anwar",
        "action": "Site Visit",
        "time": "Yesterday",
        "success": true,
        "detail": "Client visit to inspect progress on Floor 2.",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Recent Activity",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return RecentActivityItem(
            userName: activity['user'],
            action: activity['action'],
            time: activity['time'],
            isSuccess: activity['success'],
            onTap: () => _showActivityDetail(context, activity),
          );
        },
      ),
    );
  }

  void _showActivityDetail(
    BuildContext context,
    Map<String, dynamic> activity,
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
                          activity['user'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          activity['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    activity['success']
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    color: activity['success'] ? Colors.green : Colors.orange,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Activity",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activity['action'],
                style: const TextStyle(
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
                  activity['detail'],
                  style: const TextStyle(
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
                    style: const TextStyle(
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
