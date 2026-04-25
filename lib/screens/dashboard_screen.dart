import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';
import 'emergency_report_screen.dart';
import 'hospitals_screen.dart';
import 'chatbot_screen.dart';
import 'admission_status_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EmergencyReportScreen(),
    const HospitalsScreen(),
    const ChatbotScreen(),
    const AdmissionStatusScreen(),
    const ProfileScreen(),
  ];

  final List<_NavItem> _navItems = [
    _NavItem(Icons.emergency_rounded, Icons.emergency_outlined, 'Emergency'),
    _NavItem(Icons.local_hospital_rounded, Icons.local_hospital_outlined,
        'Hospitals'),
    _NavItem(Icons.chat_bubble_rounded, Icons.chat_bubble_outlined, 'Chatbot'),
    _NavItem(Icons.assignment_turned_in_rounded,
        Icons.assignment_turned_in_outlined, 'Status'),
    _NavItem(Icons.person_rounded, Icons.person_outlined, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isSelected = _selectedIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16 : 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 22,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Text(
                            item.label,
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  _NavItem(this.activeIcon, this.icon, this.label);
}
