// lib/screens/hospital_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../services/emergency_service.dart';
import '../services/hospital_service.dart';
import '../models/hospital_model.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';
import 'appointment_screen.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  final _hospitalService = HospitalService();
  final _emergencyService = EmergencyService();
  List<HospitalModel>? _hospitals;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    final pos = await _emergencyService.getCurrentPosition();
    if (pos == null) {
      setState(() {
        _error = 'Location permission required';
        _loading = false;
      });
      return;
    }
    try {
      final hospitals = await _hospitalService.getNearbyHospitals(
          pos.latitude, pos.longitude);
      setState(() {
        _hospitals = hospitals;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _openMap(HospitalModel hospital) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${hospital.latitude},${hospital.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Hospitals')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _buildList(),
    );
  }

  Widget _buildError() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadHospitals, child: const Text('Retry')),
          ],
        ),
      );

  Widget _buildList() => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _hospitals!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _HospitalCard(
          hospital: _hospitals![i],
          onDirections: () => _openMap(_hospitals![i]),
          onAppointment: () =>
              Get.to(() => AppointmentScreen(hospital: _hospitals![i])),
        ),
      );
}

class _HospitalCard extends StatelessWidget {
  final HospitalModel hospital;
  final VoidCallback onDirections;
  final VoidCallback onAppointment;

  const _HospitalCard({
    required this.hospital,
    required this.onDirections,
    required this.onAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_hospital,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hospital.name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(hospital.address,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${hospital.distanceKm?.toStringAsFixed(1)} km',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Badges
            Wrap(
              spacing: 8,
              children: [
                if (hospital.hasICU) _badge('ICU Available', AppColors.success),
                if (hospital.hasOxygen)
                  _badge('Oxygen Available', AppColors.primaryLight),
                _badge('${hospital.availableBeds} Beds', AppColors.accentOrange),
                _badge('★ ${hospital.rating}', AppColors.warning),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Directions'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAppointment,
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Appointment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w500)),
      );
}
