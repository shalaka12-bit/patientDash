// lib/screens/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/hospital_model.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';

class AppointmentScreen extends StatefulWidget {
  final HospitalModel hospital;
  const AppointmentScreen({super.key, required this.hospital});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool _loading = false;
  bool _submitted = false;

  Future<void> _sendRequest() async {
    setState(() => _loading = true);
    final auth = Get.find<AuthService>();
    final user = auth.userModel.value;

    await FirebaseFirestore.instance.collection('appointments').add({
      'userId': auth.firebaseUser.value!.uid,
      'patientName': user?.fullName ?? '',
      'patientMobile': user?.mobileNumber ?? '',
      'hospitalId': widget.hospital.id,
      'hospitalName': widget.hospital.name,
      'status': 'pending', // admin can: Accept, Reject, Admit, Discharge
      'createdAt': Timestamp.now(),
    });

    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _submitted
            ? _buildSuccess()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital card summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_hospital,
                            color: AppColors.primary, size: 36),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.hospital.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              Text(widget.hospital.address,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13)),
                              Text(
                                  '${widget.hospital.distanceKm?.toStringAsFixed(1)} km away',
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your appointment request will be sent to this hospital. The admin will Accept, Admit, Discharge, or Reject it.',
                    style: TextStyle(
                        color: AppColors.textSecondary, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppColors.warning, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Result will appear in your Admission Status tab.',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.warning),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    label: 'Send Appointment Request',
                    loading: _loading,
                    icon: Icons.send_rounded,
                    onPressed: _sendRequest,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSuccess() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 80, color: AppColors.success),
            const SizedBox(height: 20),
            const Text('Request Sent!',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Hospital admin has been notified.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Back to Hospitals'),
            ),
          ],
        ),
      );
}
