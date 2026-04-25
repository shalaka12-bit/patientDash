import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Map<String, String> _userData = const {
    'Full Name': 'Rahul Sharma',
    'Age': '32',
    'Gender': 'Male',
    'Blood Group': 'B+',
    'Mobile': '+91 98765 43210',
    'Email': 'rahul.sharma@email.com',
    'Address': 'Flat 4B, Sai Krupa Apts, Andheri West, Mumbai - 400053',
    'Emergency Contact': '+91 98765 00000',
  };

  final List<Map<String, dynamic>> _pastReports = const [
    {
      'date': 'Apr 20, 2026',
      'type': 'Heart Problem',
      'hospital': 'Kokilaben Hospital',
      'status': 'Discharged',
      'statusColor': 0xFF457B9D,
    },
    {
      'date': 'Apr 24, 2026',
      'type': 'Accident',
      'hospital': 'Hiranandani Hospital',
      'status': 'Admitted',
      'statusColor': 0xFF2D9D78,
    },
    {
      'date': 'Apr 25, 2026',
      'type': 'Fever',
      'hospital': 'Lilavati Hospital',
      'status': 'Pending',
      'statusColor': 0xFFF4A261,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () => _showEditProfile(context),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person_rounded,
                                size: 50, color: AppColors.primary),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rahul Sharma',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Patient ID: PAT-2026-001',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Blood group badge
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _InfoBadge(
                        icon: Icons.bloodtype_rounded,
                        label: 'Blood: B+',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      _InfoBadge(
                        icon: Icons.wc_rounded,
                        label: 'Male',
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 10),
                      _InfoBadge(
                        icon: Icons.cake_rounded,
                        label: 'Age: 32',
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _SectionCard(
                    title: 'Personal Information',
                    icon: Icons.person_outline,
                    children: [
                      _ProfileRow('Full Name', _userData['Full Name']!,
                          Icons.person_outline),
                      _ProfileRow('Email', _userData['Email']!,
                          Icons.email_outlined),
                      _ProfileRow('Mobile', _userData['Mobile']!,
                          Icons.phone_outlined),
                      _ProfileRow('Address', _userData['Address']!,
                          Icons.location_on_outlined),
                      _ProfileRow('Emergency Contact',
                          _userData['Emergency Contact']!,
                          Icons.emergency_outlined),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _SectionCard(
                    title: 'Medical Reports',
                    icon: Icons.folder_open_rounded,
                    trailing: Text('All Reports',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500)),
                    children: _pastReports.map((r) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(r['statusColor'] as int)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.description_rounded,
                                  color:
                                      Color(r['statusColor'] as int),
                                  size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(r['type'] as String,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  Text(
                                      '${r['hospital']} • ${r['date']}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Color(r['statusColor'] as int)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(r['status'] as String,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color:
                                        Color(r['statusColor'] as int),
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Settings
                  _SectionCard(
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    children: [
                      _SettingRow(
                          Icons.notifications_outlined,
                          'Notifications',
                          'Manage alerts'),
                      _SettingRow(
                          Icons.security_rounded, 'Privacy', 'Data & security'),
                      _SettingRow(
                          Icons.help_outline_rounded, 'Help & Support',
                          'FAQs, Contact us'),
                      _SettingRow(
                          Icons.info_outline_rounded, 'About MedAlert',
                          'Version 1.0.0'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded,
                          color: AppColors.danger),
                      label: Text('Sign Out',
                          style: GoogleFonts.poppins(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side:
                            const BorderSide(color: AppColors.danger),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to sign out?',
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textSecondary)),
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingRow(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        title: Text(title,
            style:
                GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textSecondary, size: 20),
        onTap: () {},
      ),
    );
  }
}
