// lib/screens/admission_status_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/emergency_service.dart';
import '../models/emergency_report_model.dart';
import '../utils/app_theme.dart';

class AdmissionStatusScreen extends StatelessWidget {
  const AdmissionStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    final service = EmergencyService();

    return Scaffold(
      appBar: AppBar(title: const Text('Admission Status')),
      body: StreamBuilder<List<EmergencyReport>>(
        stream: service.getPatientReports(auth.firebaseUser.value!.uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('No reports submitted yet',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snap.data!.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _StatusCard(report: snap.data![i]),
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final EmergencyReport report;
  const _StatusCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(report.status);
    final fmt = DateFormat('dd MMM yyyy, hh:mm a');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(report.emergencyType,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusInfo['color'].withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusInfo['icon'],
                          size: 12, color: statusInfo['color']),
                      const SizedBox(width: 4),
                      Text(statusInfo['label'],
                          style: TextStyle(
                              color: statusInfo['color'],
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (report.description.isNotEmpty)
              Text(report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(report.address,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            if (report.assignedHospitalName != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.local_hospital,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(report.assignedHospitalName!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(fmt.format(report.createdAt),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _statusInfo(String status) {
    switch (status) {
      case 'accepted':
        return {'label': 'Accepted', 'color': AppColors.success, 'icon': Icons.check_circle};
      case 'admitted':
        return {'label': 'Admitted', 'color': AppColors.primary, 'icon': Icons.local_hospital};
      case 'discharged':
        return {'label': 'Discharged', 'color': AppColors.accentOrange, 'icon': Icons.exit_to_app};
      case 'rejected':
        return {'label': 'Rejected', 'color': AppColors.error, 'icon': Icons.cancel};
      default:
        return {'label': 'Pending', 'color': AppColors.warning, 'icon': Icons.hourglass_empty};
    }
  }
}
