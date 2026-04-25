// lib/services/hospital_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';

class HospitalService {
  final _db = FirebaseFirestore.instance;

  Future<List<HospitalModel>> getNearbyHospitals(
      double userLat, double userLng) async {
    final snap = await _db
        .collection('hospitals')
        .where('availableBeds', isGreaterThan: 0)
        .get();

    final hospitals = snap.docs
        .map((d) => HospitalModel.fromMap(d.data(), d.id))
        .toList();

    for (final h in hospitals) {
      h.distanceKm = Geolocator.distanceBetween(
              userLat, userLng, h.latitude, h.longitude) /
          1000;
    }

    hospitals.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
    return hospitals;
  }

  Future<HospitalModel?> getHospitalById(String id) async {
    final doc = await _db.collection('hospitals').doc(id).get();
    if (!doc.exists) return null;
    return HospitalModel.fromMap(doc.data()!, doc.id);
  }
}
