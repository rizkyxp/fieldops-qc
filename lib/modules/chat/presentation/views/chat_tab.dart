import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/chat_card.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Chats
    final List<Map<String, dynamic>> chats = [
      {
        "title": "Safety Inspection Area B",
        "message": "Did you check the wiring?",
        "time": "10:30 AM",
        "unread": 2,
        "image": "https://picsum.photos/seed/construction_project/100/100",
      },
      {
        "title": "Area B - Maintenance",
        "message": "Parts arrived for the generator.",
        "time": "Yesterday",
        "unread": 0,
        "image": "https://picsum.photos/seed/siteB/100/100",
      },
      {
        "title": "Warehouse A Renovation",
        "message": "Project completed, final report sent.",
        "time": "Mon",
        "unread": 0,
        "image": "https://picsum.photos/seed/warehouse/100/100",
      },
      {
        "title": "Site C - Excavation",
        "message": "Rain delay, standby.",
        "time": "Sun",
        "unread": 5,
        "image": "https://picsum.photos/seed/siteC/100/100",
      },
      {
        "title": "Old Site Survey",
        "message": "Archived docs available in the drive.",
        "time": "Last Week",
        "unread": 0,
        "image": "https://picsum.photos/seed/oldsite/100/100",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Messages",
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
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatCard(
            title: chat['title'],
            lastMessage: chat['message'],
            time: chat['time'],
            unreadCount: chat['unread'],
            imageUrl: chat['image'],
            onTap: () {
              Get.snackbar("Chat", "Open chat for ${chat['title']}");
            },
          );
        },
      ),
    );
  }
}
