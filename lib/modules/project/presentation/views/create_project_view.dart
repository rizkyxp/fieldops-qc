import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/create_project_request_model.dart';
import '../controllers/project_controller.dart';

class CreateProjectView extends StatefulWidget {
  const CreateProjectView({super.key});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  final ProjectController _projectController = Get.find<ProjectController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // Store User IDs
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Show modal to choose between camera and gallery
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
                title: const Text("Take Photo"),
                onTap: () async {
                  Get.back();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Get.back();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
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
      final newProject = CreateProjectRequestModel(
        name: _nameController.text,
        description: _addressController.text,
        startDate: _startDate!.toIso8601String(),
        endDate: _endDate!.toIso8601String(),
      );

      _projectController.createProject(newProject);

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

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    // Determine the earliest allowed date (firstDate)
    // If selecting Start Date: earliest is today (now).
    // If selecting End Date: earliest is the Start Date (if set) or today.
    final DateTime firstDate = isStart ? now : (_startDate ?? now);

    // Ensure firstDate is not in the past relative to now (if that's desired behavior),
    // but showDatePicker usually handles "from now" fine. However, strict logic:
    // If firstDate is before now, it might cause issues if we strictly want future dates.
    // For safety, let's keep firstDate as is but ensure we don't pick before it.

    // Calculate initialDate
    // If we have a previously selected value, use it.
    // If not, default to firstDate (THIS IS KEY: Default to firstDate, NOT DateTime.now()).
    // If we default to DateTime.now() while firstDate is in the future (e.g. Start Date = Dec 31),
    // then initialDate (Dec 29) < firstDate (Dec 31) => Crash.
    DateTime initialDate = (isStart ? _startDate : _endDate) ?? firstDate;

    // Safety check: specific case where user selected a date, then changed constraint (e.g. moved Start Date ahead of old End Date)
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // If start date is after end date, clear end date or auto-update
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = null; // Clear invalid end date, force user to re-select
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Create New Project",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                        style: BorderStyle.solid,
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
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Upload Project Cover",
                                style: TextStyle(
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

              // Project Name
              _buildLabel("Project Name"),
              TextFormField(
                controller: _nameController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                decoration: _buildInputDecoration(
                  hint: "Enter project name",
                  icon: Icons.business_center_outlined,
                ),
              ),
              const SizedBox(height: 20),

              // Description
              _buildLabel("Description"),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                decoration: _buildInputDecoration(
                  hint: "Enter project description",
                  icon: Icons.description_outlined,
                ),
              ),
              const SizedBox(height: 20),

              // Date Range
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Start Date"),
                        GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _startDate != null
                                    ? DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(_startDate!)
                                    : "",
                              ),
                              decoration: _buildInputDecoration(
                                hint: "Select Date",
                                icon: Icons.calendar_today_outlined,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("End Date"),
                        GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _endDate != null
                                    ? DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(_endDate!)
                                    : "",
                              ),
                              decoration: _buildInputDecoration(
                                hint: "Select Date",
                                icon: Icons.event_outlined,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Assign Members Removed as per user request
              const SizedBox(height: 32),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: _projectController.isLoading.value
                        ? null
                        : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    child: _projectController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Create Project",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
