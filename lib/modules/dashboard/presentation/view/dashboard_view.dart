import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/dashboard_controller.dart';
import 'home_tab.dart';
import '../../../task/presentation/view/tasks_tab.dart';
import '../../../chat/presentation/view/chat_tab.dart';
import '../../../reflect/presentation/view/reflect_tab.dart';

import 'profile_tab.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Content
          Obx(
            () => IndexedStack(
              index: controller.tabIndex.value,
              children: const [
                TasksTab(),
                ChatTab(),
                HomeTab(),
                ReflectTab(),
                ProfileTab(),
              ],
            ),
          ),

          // Custom Bottom Navigation
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.task_alt_outlined, "Tasks"),
                  _buildNavItem(1, Icons.chat_bubble_outline, "Chats"),
                  _buildHomeItem(2),
                  _buildNavItem(3, Icons.auto_graph_outlined, "Reflect"),
                  _buildNavItem(4, Icons.person_outline, "Profile"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Obx(() {
      final isSelected = controller.tabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeTabIndex(index),
        child: Container(
          color: Colors.transparent, // Hitbox
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 26,
              ),
              if (isSelected)
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHomeItem(int index) {
    return Obx(() {
      final isSelected = controller.tabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeTabIndex(index),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            shape: BoxShape.circle,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.home_rounded,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            size: 28,
          ),
        ),
      );
    });
  }
}
