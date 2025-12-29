import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/task_card.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> tasks = [
      {
        "title": "Safety Inspection Area A",
        "subtitle": "Check all safety equipment and protocols.",
        "priority": "High Priority",
        "color": AppColors.error,
        "project": "Safety Inspection Area B",
        "floor": "Main Hall - Level 1",
      },
      {
        "title": "Review Daily Reports",
        "subtitle": "Analyze pending reports from Site B.",
        "priority": "Medium Priority",
        "color": Colors.orange,
        "project": "Area B - Maintenance",
        "floor": "Generator Room",
      },
      {
        "title": "Update Material Log",
        "subtitle": "Verify inventory stock for next week.",
        "priority": "Low Priority",
        "color": Colors.blue,
        "project": "Warehouse A Renovation",
        "floor": "Storage Area B",
      },
      {
        "title": "Site C Walkthrough",
        "subtitle": "Weekly general inspection with client.",
        "priority": "High Priority",
        "color": AppColors.error,
        "project": "Site C - Excavation",
        "floor": "Perimeter Fencing",
      },
      {
        "title": "Equipment Check",
        "subtitle": "Routine maintenance check for heavy machinery.",
        "priority": "Medium Priority",
        "color": Colors.orange,
        "project": "Area B - Maintenance",
        "floor": "Workshop",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            title: task['title'],
            subtitle: task['subtitle'],
            priority: task['priority'],
            priorityColor: task['color'],
            projectName: task['project'],
            floorPlan: task['floor'],
            onTap: () {},
          );
        },
      ),
    );
  }
}
