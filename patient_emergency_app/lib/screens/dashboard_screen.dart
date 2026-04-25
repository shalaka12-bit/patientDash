// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'emergency_report_screen.dart';
import 'hospital_list_screen.dart';
import 'chatbot_screen.dart';
import 'admission_status_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final _screens = const [
    EmergencyReportScreen(),
    HospitalListScreen(),
    ChatbotScreen(),
    AdmissionStatusScreen(),
    ProfileScreen(),
  ];

  final _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.emergency_outlined),
      activeIcon: Icon(Icons.emergency),
      label: 'Emergency',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_hospital_outlined),
      activeIcon: Icon(Icons.local_hospital),
      label: 'Hospitals',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      activeIcon: Icon(Icons.chat_bubble),
      label: 'Chatbot',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_outlined),
      activeIcon: Icon(Icons.assignment),
      label: 'Status',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins', fontSize: 11),
          elevation: 0,
          items: _navItems,
        ),
      ),
    );
  }
}
