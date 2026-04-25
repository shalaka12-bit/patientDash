import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';
import '../models/models.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  bool _isLoading = true;
  List<Hospital> _hospitals = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _hospitals = _getDummyHospitals();
        _isLoading = false;
      });
    }
  }

  List<Hospital> _getDummyHospitals() {
    return [
      Hospital(
        id: '1',
        name: 'Kokilaben Dhirubhai Ambani Hospital',
        address: 'Rao Saheb Achutrao Patwardhan Marg, Four Bungalows, Andheri West',
        latitude: 19.1334,
        longitude: 72.8268,
        distance: 1.2,
        hasICU: true,
        hasOxygen: true,
        availableBeds: 12,
        phone: '+91-22-4269-6969',
        rating: 4.8,
        isOpen: true,
      ),
      Hospital(
        id: '2',
        name: 'Hiranandani Hospital',
        address: 'Dr. E Borges Road, Hillside Ave, Powai',
        latitude: 19.1176,
        longitude: 72.9060,
        distance: 3.5,
        hasICU: true,
        hasOxygen: true,
        availableBeds: 6,
        phone: '+91-22-2576-3599',
        rating: 4.6,
        isOpen: true,
      ),
      Hospital(
        id: '3',
        name: 'Nanavati Max Super Speciality Hospital',
        address: 'S. V. Road, Vile Parle West',
        latitude: 19.0990,
        longitude: 72.8397,
        distance: 4.8,
        hasICU: false,
        hasOxygen: true,
        availableBeds: 20,
        phone: '+91-22-2626-7500',
        rating: 4.5,
        isOpen: true,
      ),
      Hospital(
        id: '4',
        name: 'Lilavati Hospital',
        address: 'A-791, Bandra Reclamation, Bandra West',
        latitude: 19.0558,
        longitude: 72.8227,
        distance: 7.2,
        hasICU: true,
        hasOxygen: true,
        availableBeds: 3,
        phone: '+91-22-2675-1000',
        rating: 4.7,
        isOpen: true,
      ),
      Hospital(
        id: '5',
        name: 'Breach Candy Hospital',
        address: '60A, Bhulabhai Desai Rd, Breach Candy',
        latitude: 18.9678,
        longitude: 72.8056,
        distance: 12.4,
        hasICU: true,
        hasOxygen: true,
        availableBeds: 0,
        phone: '+91-22-2367-2888',
        rating: 4.9,
        isOpen: true,
      ),
    ];
  }

  List<Hospital> get _filteredHospitals {
    if (_searchQuery.isEmpty) return _hospitals;
    return _hospitals
        .where((h) =>
            h.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            h.address.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _showHospitalDetails(Hospital hospital) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.local_hospital_rounded,
                        color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hospital.name,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 16),
                            Text(' ${hospital.rating}',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: hospital.isOpen
                                    ? AppColors.success.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                hospital.isOpen ? 'Open' : 'Closed',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: hospital.isOpen
                                      ? AppColors.success
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(hospital.address,
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.directions_walk_rounded,
                      size: 16, color: AppColors.textSecondary),
                  Text(
                    '  ${hospital.distance} km away',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Text('Resource Availability',
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _resourceChip('ICU', hospital.hasICU),
                  const SizedBox(width: 10),
                  _resourceChip('Oxygen', hospital.hasOxygen),
                  const SizedBox(width: 10),
                  _resourceChip(
                      '${hospital.availableBeds} Beds',
                      hospital.availableBeds > 0),
                ],
              ),
              const SizedBox(height: 24),
              Text('Route & Directions',
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_rounded,
                          size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 8),
                      Text('Map View',
                          style: GoogleFonts.poppins(
                              color: AppColors.textSecondary)),
                      Text('${hospital.distance} km | ~${(hospital.distance * 3).round()} min drive',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.directions_rounded),
                      label: const Text('Get Directions'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAppointmentRequest(hospital);
                      },
                      icon: const Icon(Icons.calendar_today_rounded),
                      label: const Text('Book Appointment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentRequest(Hospital hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Appointment Request',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(
          'Your appointment request has been sent to ${hospital.name}. The admin will review and confirm or reject it. You can track the status in the Admission Status tab.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _resourceChip(String label, bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: available
            ? AppColors.success.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: available
              ? AppColors.success.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 14,
            color: available ? AppColors.success : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: available ? AppColors.success : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.secondary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Nearest Hospitals',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.headerGradient),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search hospitals...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.divider),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter chips
                  Row(
                    children: [
                      _filterChip('ICU Available', Icons.bed_rounded),
                      const SizedBox(width: 8),
                      _filterChip('Oxygen', Icons.air_rounded),
                      const SizedBox(width: 8),
                      _filterChip('Nearest', Icons.near_me_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                          color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text('Finding nearby hospitals...',
                          style: GoogleFonts.poppins(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final hospital = _filteredHospitals[i];
                  return _HospitalCard(
                    hospital: hospital,
                    onTap: () => _showHospitalDetails(hospital),
                  );
                },
                childCount: _filteredHospitals.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _filterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.accent,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback onTap;

  const _HospitalCard({required this.hospital, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_hospital_rounded,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hospital.name,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
                          Text(' ${hospital.rating}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Text('• ${hospital.distance} km',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: hospital.availableBeds > 0
                        ? AppColors.success.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hospital.availableBeds > 0
                        ? '${hospital.availableBeds} beds'
                        : 'Full',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: hospital.availableBeds > 0
                          ? AppColors.success
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(hospital.address,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(
              children: [
                _tag('ICU', hospital.hasICU, Icons.bed_rounded),
                const SizedBox(width: 8),
                _tag('O₂', hospital.hasOxygen, Icons.air_rounded),
                const Spacer(),
                Text('Tap to view & book →',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label, bool available, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: available
            ? AppColors.success.withOpacity(0.1)
            : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12,
              color: available ? AppColors.success : Colors.red),
          const SizedBox(width: 3),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: available ? AppColors.success : Colors.red,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
