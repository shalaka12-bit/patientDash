// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/emergency_service.dart';
import '../models/emergency_report_model.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    final service = EmergencyService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => _confirmLogout(context, auth),
          ),
        ],
      ),
      body: Obx(() {
        final user = auth.userModel.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user.fullName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(user.email,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoRow(Icons.cake_outlined, 'Age', '${user.age} years'),
                      _divider(),
                      _infoRow(Icons.wc_outlined, 'Gender', user.gender),
                      _divider(),
                      _infoRow(Icons.phone_outlined, 'Mobile', user.mobileNumber),
                      _divider(),
                      _infoRow(Icons.bloodtype_outlined, 'Blood Group',
                          user.bloodGroup),
                      _divider(),
                      _infoRow(Icons.emergency_outlined, 'Emergency Contact',
                          user.emergencyContact),
                      _divider(),
                      _infoRow(Icons.location_on_outlined, 'Address',
                          user.address),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Report history
              const Text('All Visit Reports',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              StreamBuilder<List<EmergencyReport>>(
                stream: service.getPatientReports(auth.firebaseUser.value!.uid),
                builder: (_, snap) {
                  if (!snap.hasData || snap.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No visit records yet.',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    );
                  }
                  return Column(
                    children: snap.data!.map((r) => _ReportHistoryTile(report: r)).toList(),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _divider() => const Divider(height: 1, color: AppColors.border);

  void _confirmLogout(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              auth.logout();
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _ReportHistoryTile extends StatelessWidget {
  final EmergencyReport report;
  const _ReportHistoryTile({required this.report});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    final statusColor = report.status == 'discharged'
        ? AppColors.success
        : report.status == 'admitted'
            ? AppColors.primary
            : report.status == 'rejected'
                ? AppColors.error
                : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment,
                size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.emergencyType,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(fmt.format(report.createdAt),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                if (report.assignedHospitalName != null)
                  Text(report.assignedHospitalName!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              report.status.capitalizeFirst ?? report.status,
              style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
