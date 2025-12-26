import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../controllers/project_controller.dart';

class CreateProjectView extends StatefulWidget {
  const CreateProjectView({super.key});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  final ProjectController _projectController = Get.put(ProjectController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _assignedMembers = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Mock Members Data
  final List<Map<String, dynamic>> _availableMembers = [
    {"name": "Rizky Firmansyah", "avatar": "https://i.pravatar.cc/150?u=1"},
    {"name": "Andi Saputra", "avatar": "https://i.pravatar.cc/150?u=2"},
    {"name": "Budi Santoso", "avatar": "https://i.pravatar.cc/150?u=3"},
    {"name": "Siti Aminah", "avatar": "https://i.pravatar.cc/150?u=4"},
    {"name": "Joko Anwar", "avatar": "https://i.pravatar.cc/150?u=5"},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text("Take Photo", style: GoogleFonts.poppins()),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: Text(
                  "Choose from Gallery",
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Date Validation
      if (_startDate == null || _endDate == null) {
        Get.snackbar(
          "Error",
          "Please select start and end dates",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        Get.snackbar(
          "Error",
          "End date must be after start date",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
        return;
      }

      // Create Project
      final newProject = {
        "title": _nameController.text,
        "address": _addressController.text,
        "startDate": _startDate,
        "endDate": _endDate,
        "assignedMembers": _assignedMembers,
        "image": _selectedImage != null
            ? _selectedImage!.path
            : "https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/800/600",
        "supervisor": "https://i.pravatar.cc/150?u=99", // Current user mock
      };

      _projectController.addProject(newProject);

      Get.back();
      Get.snackbar(
        "Success",
        "Project created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Create New Project",
          style: GoogleFonts.poppins(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Project Photo Picker
              Center(
                child: GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.tertiary.withValues(alpha: 0.3),
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_rounded,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Upload Project Photo",
                                style: GoogleFonts.poppins(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // ... rest of the file

              // 2. Project Name
              _buildTextField(
                controller: _nameController,
                label: "Project Name",
                hint: "Enter project name",
                icon: Icons.business_center_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter project name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Address
              _buildTextField(
                controller: _addressController,
                label: "Address",
                hint: "Enter project address",
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Dates
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: "Start Date",
                      selectedDate: _startDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => _startDate = date);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePicker(
                      label: "End Date",
                      selectedDate: _endDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              _startDate ?? DateTime.now(), // Limit start
                          firstDate: _startDate ?? DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => _endDate = date);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 5. Assign Members
              Text(
                "Assign Members",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._assignedMembers.map((name) {
                      final member = _availableMembers.firstWhere(
                        (m) => m['name'] == name,
                        orElse: () => {"name": "?", "avatar": ""},
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                member['avatar'] ?? "",
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _assignedMembers.remove(name);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () => _showMemberSelectionSheet(),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Icon(Icons.add, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 6. Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Create Project",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                      : "Select Date",
                  style: GoogleFonts.poppins(
                    color: selectedDate != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMemberSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Member",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._availableMembers.map((member) {
                final isSelected = _assignedMembers.contains(member['name']);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member['avatar'] ?? ""),
                  ),
                  title: Text(
                    member['name'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _assignedMembers.remove(member['name']);
                      } else {
                        _assignedMembers.add(member['name']);
                      }
                    });
                    Get.back();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
