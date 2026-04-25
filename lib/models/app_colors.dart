import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE63946);
  static const Color primaryDark = Color(0xFFC1121F);
  static const Color primaryLight = Color(0xFFFF6B6B);
  static const Color secondary = Color(0xFF1D3557);
  static const Color accent = Color(0xFF457B9D);
  static const Color success = Color(0xFF2D9D78);
  static const Color warning = Color(0xFFF4A261);
  static const Color danger = Color(0xFFE76F51);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color cardShadow = Color(0x1A000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE63946), Color(0xFFC1121F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFE63946), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF1D3557), Color(0xFF457B9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
