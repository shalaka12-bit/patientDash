import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';

class EmergencyReportScreen extends StatefulWidget {
  const EmergencyReportScreen({super.key});

  @override
  State<EmergencyReportScreen> createState() => _EmergencyReportScreenState();
}

class _EmergencyReportScreenState extends State<EmergencyReportScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedEmergencyType = 'Accident';
  String _customEmergencyType = '';

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _otherTypeController = TextEditingController();

  String _detectedLocation = '';

  bool _isDetectingLocation = false;
  bool _isSubmitting = false;
  bool _showSymptoms = false;

  List<String> _uploadedFiles = [];

  final List<String> _emergencyTypes = [
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

  @override
  void dispose() {
    _descriptionController.dispose();
    _otherTypeController.dispose();
    super.dispose();
  }

  // Upload file
  void _pickFile() {
    setState(() {
      _uploadedFiles.add(
        'medical_report_${_uploadedFiles.length + 1}.pdf',
      );
    });
  }

  // Detect location
  Future<void> _detectLocation() async {
    setState(() {
      _isDetectingLocation = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _detectedLocation = 'Andheri West, Mumbai, Maharashtra';
        _isDetectingLocation = false;
      });
    }
  }

  // Submit report
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEmergencyType == 'Others') {
      _customEmergencyType = _otherTypeController.text.trim();

      if (_customEmergencyType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please specify emergency type',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      _customEmergencyType = _selectedEmergencyType;
    }

    if (_detectedLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please detect your location first',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _showSymptoms = true;
      });

      _showSuccessDialog();
    }
  }

  // Success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text(
          "Emergency report submitted successfully.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Symptom chip
  Widget _symptomChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Emergency Report"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency Type",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: _selectedEmergencyType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _emergencyTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEmergencyType = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                if (_selectedEmergencyType == "Others")
                  TextFormField(
                    controller: _otherTypeController,
                    decoration: const InputDecoration(
                      labelText: "Specify Emergency Type",
                      border: OutlineInputBorder(),
                    ),
                  ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Describe Injury / Disease",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter description";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text(
                    "Upload Medical Report",
                  ),
                ),

                const SizedBox(height: 10),

                if (_uploadedFiles.isNotEmpty)
                  Text(
                    "Uploaded Files: ${_uploadedFiles.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _isDetectingLocation ? null : _detectLocation,
                  icon: const Icon(
                    Icons.location_on,
                  ),
                  label: Text(
                    _isDetectingLocation ? "Detecting..." : "Detect Location",
                  ),
                ),

                const SizedBox(height: 10),

                if (_detectedLocation.isNotEmpty)
                  Text(
                    "Location: $_detectedLocation",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                // Current Symptoms Section
                if (_showSymptoms) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Current Symptoms",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _symptomChip("Chest Pain"),
                      _symptomChip("Breathing Difficulty"),
                      _symptomChip("Heavy Bleeding"),
                      _symptomChip("High Fever"),
                      _symptomChip("Unconscious"),
                      _symptomChip("Low Oxygen"),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: Text(
                      _isSubmitting ? "Submitting..." : "Submit Report",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
