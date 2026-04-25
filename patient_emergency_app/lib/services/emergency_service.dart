// lib/services/emergency_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/emergency_report_model.dart';

class EmergencyService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // ── Location ──────────────────────────────────────────────────────────────
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromCoords(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      final p = placemarks.first;
      return '${p.street}, ${p.locality}, ${p.administrativeArea} ${p.postalCode}';
    } catch (_) {
      return 'Location detected';
    }
  }

  // ── File Upload ────────────────────────────────────────────────────────────
  Future<String> uploadFile(File file, String userId) async {
    final ref = _storage
        .ref()
        .child('reports/$userId/${DateTime.now().millisecondsSinceEpoch}');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  // ── Submit Emergency Report ────────────────────────────────────────────────
  Future<String> submitReport(EmergencyReport report) async {
    final doc = await _db.collection('emergency_reports').add(report.toMap());
    return doc.id;
  }

  // ── Get Reports for Patient ────────────────────────────────────────────────
  Stream<List<EmergencyReport>> getPatientReports(String userId) {
    return _db
        .collection('emergency_reports')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => EmergencyReport.fromMap(d.data(), d.id))
            .toList());
  }

  // ── Admin: Get All Reports ─────────────────────────────────────────────────
  Stream<List<EmergencyReport>> getAllReports() {
    return _db
        .collection('emergency_reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => EmergencyReport.fromMap(d.data(), d.id))
            .toList());
  }

  // ── Admin: Update Report Status ────────────────────────────────────────────
  Future<void> updateReportStatus(String reportId, String status,
      {String? hospitalId, String? hospitalName}) async {
    final data = <String, dynamic>{'status': status};
    if (hospitalId != null) data['assignedHospitalId'] = hospitalId;
    if (hospitalName != null) data['assignedHospitalName'] = hospitalName;
    await _db.collection('emergency_reports').doc(reportId).update(data);
  }
}
