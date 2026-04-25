// lib/models/hospital_model.dart
class HospitalModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final bool hasICU;
  final bool hasOxygen;
  final int availableBeds;
  final String phone;
  final double rating;
  double? distanceKm; // computed at runtime

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hasICU,
    required this.hasOxygen,
    required this.availableBeds,
    required this.phone,
    required this.rating,
    this.distanceKm,
  });

  factory HospitalModel.fromMap(Map<String, dynamic> map, String id) =>
      HospitalModel(
        id: id,
        name: map['name'] ?? '',
        address: map['address'] ?? '',
        latitude: (map['latitude'] ?? 0.0).toDouble(),
        longitude: (map['longitude'] ?? 0.0).toDouble(),
        hasICU: map['hasICU'] ?? false,
        hasOxygen: map['hasOxygen'] ?? false,
        availableBeds: map['availableBeds'] ?? 0,
        phone: map['phone'] ?? '',
        rating: (map['rating'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'hasICU': hasICU,
        'hasOxygen': hasOxygen,
        'availableBeds': availableBeds,
        'phone': phone,
        'rating': rating,
      };
}
