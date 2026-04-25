// lib/screens/admin_panel_screen.dart
// This screen is for hospital admins only.
// Access it separately (e.g., via a hidden route or separate admin app).

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Appointments'),
            Tab(text: 'Emergency Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AppointmentsTab(),
          _EmergencyReportsTab(),
        ],
      ),
    );
  }
}

// ── APPOINTMENTS TAB ────────────────────────────────────────────────────────
class _AppointmentsTab extends StatelessWidget {
  const _AppointmentsTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (_, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No appointments yet.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _AppointmentCard(doc: docs[i]),
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _AppointmentCard({required this.doc});

  Future<void> _updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(docId)
        .update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
    // Also mirror to emergency_reports for admission status bar
    final data = (await FirebaseFirestore.instance
            .collection('appointments')
            .doc(docId)
            .get())
        .data() as Map<String, dynamic>;
    final userId = data['userId'];
    final reports = await FirebaseFirestore.instance
        .collection('emergency_reports')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (reports.docs.isNotEmpty) {
      await reports.docs.first.reference.update({'status': status});
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final status = data['status'] ?? 'pending';
    final fmt = DateFormat('dd MMM, hh:mm a');
    final createdAt = (data['createdAt'] as Timestamp).toDate();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['patientName'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(data['patientMobile'] ?? '',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                      Text(data['hospitalName'] ?? '',
                          style: const TextStyle(
                              color: AppColors.primary, fontSize: 12)),
                    ],
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 4),
            Text(fmt.format(createdAt),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionBtn(
                  label: 'Accept',
                  color: AppColors.success,
                  icon: Icons.check,
                  onTap: () => _updateStatus(doc.id, 'accepted'),
                ),
                _ActionBtn(
                  label: 'Admit',
                  color: AppColors.primary,
                  icon: Icons.local_hospital,
                  onTap: () => _updateStatus(doc.id, 'admitted'),
                ),
                _ActionBtn(
                  label: 'Discharge',
                  color: AppColors.accentOrange,
                  icon: Icons.exit_to_app,
                  onTap: () => _updateStatus(doc.id, 'discharged'),
                ),
                _ActionBtn(
                  label: 'Reject',
                  color: AppColors.error,
                  icon: Icons.cancel,
                  onTap: () => _updateStatus(doc.id, 'rejected'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── EMERGENCY REPORTS TAB ────────────────────────────────────────────────────
class _EmergencyReportsTab extends StatelessWidget {
  const _EmergencyReportsTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('emergency_reports')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (_, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('No reports yet.'));
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _ReportCard(doc: docs[i]),
        );
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _ReportCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final fmt = DateFormat('dd MMM yyyy, hh:mm a');
    final createdAt = (data['createdAt'] as Timestamp).toDate();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(data['emergencyType'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                _StatusBadge(status: data['status'] ?? 'pending'),
              ],
            ),
            const SizedBox(height: 6),
            Text(data['description'] ?? '',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(data['address'] ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(fmt.format(createdAt),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── SHARED WIDGETS ────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _color(String s) {
    switch (s) {
      case 'accepted': return AppColors.success;
      case 'admitted': return AppColors.primary;
      case 'discharged': return AppColors.accentOrange;
      case 'rejected': return AppColors.error;
      default: return AppColors.warning;
    }
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label,
      required this.color,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
}
