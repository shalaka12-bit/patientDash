import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';
import '../models/models.dart';

class AdmissionStatusScreen extends StatelessWidget {
  const AdmissionStatusScreen({super.key});

  List<AdmissionRecord> get _records => [
        AdmissionRecord(
          id: '1',
          hospitalName: 'Kokilaben Dhirubhai Ambani Hospital',
          emergencyType: 'Heart Problem',
          admitDate: DateTime(2026, 4, 20, 14, 30),
          dischargeDate: DateTime(2026, 4, 25, 10, 0),
          status: 'discharged',
          doctorName: 'Dr. Priya Sharma',
        ),
        AdmissionRecord(
          id: '2',
          hospitalName: 'Hiranandani Hospital',
          emergencyType: 'Accident',
          admitDate: DateTime(2026, 4, 24, 9, 0),
          dischargeDate: null,
          status: 'admitted',
          doctorName: 'Dr. Rohan Mehta',
        ),
        AdmissionRecord(
          id: '3',
          hospitalName: 'Lilavati Hospital',
          emergencyType: 'Fever',
          admitDate: DateTime(2026, 4, 25, 8, 0),
          dischargeDate: null,
          status: 'pending',
          doctorName: 'Dr. Anita Patel',
        ),
      ];

  Color _statusColor(String status) {
    switch (status) {
      case 'admitted':
        return AppColors.success;
      case 'discharged':
        return AppColors.accent;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'admitted':
        return Icons.check_circle_rounded;
      case 'discharged':
        return Icons.home_rounded;
      case 'pending':
        return Icons.access_time_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'admitted':
        return 'Admitted';
      case 'discharged':
        return 'Discharged';
      case 'pending':
        return 'Pending Review';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String _formatDate(DateTime dt) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month]} ${dt.year}, $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final records = _records;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: const Color(0xFF457B9D),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Admission Status',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF457B9D), Color(0xFF2D9D78)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Summary cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overview',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Total Visits',
                        value: records.length.toString(),
                        icon: Icons.history_rounded,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        label: 'Currently Admitted',
                        value: records
                            .where((r) => r.status == 'admitted')
                            .length
                            .toString(),
                        icon: Icons.bed_rounded,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        label: 'Pending',
                        value: records
                            .where((r) => r.status == 'pending')
                            .length
                            .toString(),
                        icon: Icons.pending_rounded,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Admission History',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),

          // Records list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final record = records[i];
                final statusColor = _statusColor(record.status);
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.06),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_statusIcon(record.status),
                                  color: statusColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(record.hospitalName,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text(record.emergencyType,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _statusLabel(record.status),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _DetailRow(
                              icon: Icons.person_outline,
                              label: 'Doctor',
                              value: record.doctorName,
                            ),
                            const SizedBox(height: 8),
                            _DetailRow(
                              icon: Icons.login_rounded,
                              label: 'Admit Date',
                              value: _formatDate(record.admitDate),
                            ),
                            if (record.dischargeDate != null) ...[
                              const SizedBox(height: 8),
                              _DetailRow(
                                icon: Icons.logout_rounded,
                                label: 'Discharge Date',
                                value: _formatDate(record.dischargeDate!),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Timeline steps
                      if (record.status == 'admitted' ||
                          record.status == 'discharged')
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 8),
                              Text('Timeline',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              _TimelineStep(
                                label: 'Report Submitted',
                                done: true,
                                color: AppColors.success,
                              ),
                              _TimelineStep(
                                label: 'Admin Reviewed',
                                done: true,
                                color: AppColors.success,
                              ),
                              _TimelineStep(
                                label: 'Appointment Accepted',
                                done: true,
                                color: AppColors.success,
                              ),
                              _TimelineStep(
                                label: 'Patient Admitted',
                                done: true,
                                color: AppColors.success,
                              ),
                              _TimelineStep(
                                label: 'Patient Discharged',
                                done: record.status == 'discharged',
                                color: AppColors.accent,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
              childCount: records.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.textSecondary),
                maxLines: 2),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text('$label: ',
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final bool done;
  final Color color;
  final bool isLast;

  const _TimelineStep({
    required this.label,
    required this.done,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: done ? color : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: done ? color : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 20,
                color: done ? color.withOpacity(0.3) : Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Text(label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: done ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight:
                    done ? FontWeight.w500 : FontWeight.w400,
              )),
        ),
      ],
    );
  }
}
