// lib/screens/emergency_report_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/emergency_service.dart';
import '../models/emergency_report_model.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/symptom_alert_card.dart';

class EmergencyReportScreen extends StatefulWidget {
  const EmergencyReportScreen({super.key});

  @override
  State<EmergencyReportScreen> createState() => _EmergencyReportScreenState();
}

class _EmergencyReportScreenState extends State<EmergencyReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _emergencyService = EmergencyService();

  String? _emergencyType;
  String? _detectedAddress;
  double? _lat, _lng;
  bool _loadingLocation = false;
  bool _loading = false;
  final List<File> _selectedFiles = [];
  bool _submitted = false;

  static const _emergencyTypes = [
    'Accident',
    'Heart Problem',
    'Breathing Difficulty',
    'Fever',
    'Surgery',
    'Trauma',
    'Pregnancy',
    'Poisoning',
    'Others',
  ];

  static const _criticalSymptoms = [
    'Chest Pain',
    'Breathing Difficulty',
    'Severe Injury',
    'Heavy Bleeding',
    'High Fever',
    'Unconscious',
    'Low Oxygen Level',
  ];

  Future<void> _detectLocation() async {
    setState(() => _loadingLocation = true);
    final pos = await _emergencyService.getCurrentPosition();
    if (pos != null) {
      _lat = pos.latitude;
      _lng = pos.longitude;
      _detectedAddress =
          await _emergencyService.getAddressFromCoords(_lat!, _lng!);
    }
    setState(() => _loadingLocation = false);
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files.map((f) => File(f.path!)));
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_emergencyType == null) {
      Get.snackbar('Missing', 'Please select emergency type',
          backgroundColor: AppColors.warning, colorText: Colors.white);
      return;
    }
    if (_lat == null) {
      Get.snackbar('Location Required', 'Please detect your location',
          backgroundColor: AppColors.warning, colorText: Colors.white);
      return;
    }

    setState(() => _loading = true);
    final auth = Get.find<AuthService>();
    final uid = auth.firebaseUser.value!.uid;

    // Upload files
    final urls = <String>[];
    for (final file in _selectedFiles) {
      final url = await _emergencyService.uploadFile(file, uid);
      urls.add(url);
    }

    final report = EmergencyReport(
      userId: uid,
      emergencyType: _emergencyType!,
      description: _descCtrl.text.trim(),
      latitude: _lat!,
      longitude: _lng!,
      address: _detectedAddress ?? '',
      uploadedFileUrls: urls,
      createdAt: DateTime.now(),
    );

    await _emergencyService.submitReport(report);
    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSuccess();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Report'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.fiber_manual_record,
                    color: AppColors.accent, size: 10),
                SizedBox(width: 4),
                Text('LIVE',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Critical symptom card
                SymptomAlertCard(symptoms: _criticalSymptoms),
                const SizedBox(height: 24),

                _sectionLabel('Emergency Type *'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _emergencyType,
                  hint: const Text('Select type'),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.emergency_outlined),
                  ),
                  items: _emergencyTypes.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Row(
                        children: [
                          Icon(_getTypeIcon(t),
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(t),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _emergencyType = v),
                ),

                // Show text box for "Others"
                if (_emergencyType == 'Others') ...[
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Specify emergency type',
                    prefixIcon: Icons.edit_outlined,
                    controller: TextEditingController(),
                  ),
                ],

                const SizedBox(height: 20),
                _sectionLabel('Describe Injury / Disease *'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _descCtrl,
                  label: 'Describe in detail...',
                  maxLines: 4,
                  validator: (v) =>
                      v!.isEmpty ? 'Please describe the condition' : null,
                ),

                const SizedBox(height: 20),
                _sectionLabel('Location'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _detectLocation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _detectedAddress != null
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _detectedAddress != null
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _detectedAddress != null
                              ? Icons.location_on
                              : Icons.my_location,
                          color: _detectedAddress != null
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _loadingLocation
                              ? const Text('Detecting location...',
                                  style:
                                      TextStyle(color: AppColors.textSecondary))
                              : Text(
                                  _detectedAddress ?? 'Tap to detect location',
                                  style: TextStyle(
                                    color: _detectedAddress != null
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                        if (_loadingLocation)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _sectionLabel('Upload Documents (Optional)'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickFiles,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.border,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.upload_file_outlined,
                            size: 36, color: AppColors.textSecondary),
                        const SizedBox(height: 8),
                        const Text('Upload Prescription, Referral, Report',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('${_selectedFiles.length} file(s) selected',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                // Selected file chips
                if (_selectedFiles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _selectedFiles
                        .map((f) => Chip(
                              label: Text(f.path.split('/').last,
                                  style: const TextStyle(fontSize: 11)),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () =>
                                  setState(() => _selectedFiles.remove(f)),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 32),
                CustomButton(
                  label: 'Submit Emergency Report',
                  loading: _loading,
                  color: AppColors.accent,
                  icon: Icons.send_rounded,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    size: 60, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              const Text('Report Submitted!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Text(
                'Your emergency report has been received. Hospitals near you will be notified.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Submit Another Report',
                onPressed: () => setState(() => _submitted = false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      );

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Accident':
        return Icons.car_crash_outlined;
      case 'Heart Problem':
        return Icons.favorite_outline;
      case 'Breathing Difficulty':
        return Icons.air_outlined;
      case 'Fever':
        return Icons.thermostat_outlined;
      case 'Surgery':
        return Icons.medical_services_outlined;
      case 'Trauma':
        return Icons.healing_outlined;
      case 'Pregnancy':
        return Icons.pregnant_woman_outlined;
      case 'Poisoning':
        return Icons.warning_amber_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
