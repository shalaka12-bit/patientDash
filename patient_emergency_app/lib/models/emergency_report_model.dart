// lib/models/emergency_report_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyReport {
  final String? id;
  final String userId;
  final String emergencyType;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> uploadedFileUrls;
  final String status; // pending, accepted, admitted, discharged, rejected
  final DateTime createdAt;
  final String? assignedHospitalId;
  final String? assignedHospitalName;

  EmergencyReport({
    this.id,
    required this.userId,
    required this.emergencyType,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.uploadedFileUrls,
    this.status = 'pending',
    required this.createdAt,
    this.assignedHospitalId,
    this.assignedHospitalName,
  });

  factory EmergencyReport.fromMap(Map<String, dynamic> map, String id) =>
      EmergencyReport(
        id: id,
        userId: map['userId'] ?? '',
        emergencyType: map['emergencyType'] ?? '',
        description: map['description'] ?? '',
        latitude: (map['latitude'] ?? 0.0).toDouble(),
        longitude: (map['longitude'] ?? 0.0).toDouble(),
        address: map['address'] ?? '',
        uploadedFileUrls: List<String>.from(map['uploadedFileUrls'] ?? []),
        status: map['status'] ?? 'pending',
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        assignedHospitalId: map['assignedHospitalId'],
        assignedHospitalName: map['assignedHospitalName'],
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'emergencyType': emergencyType,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'uploadedFileUrls': uploadedFileUrls,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
        'assignedHospitalId': assignedHospitalId,
        'assignedHospitalName': assignedHospitalName,
      };
}
