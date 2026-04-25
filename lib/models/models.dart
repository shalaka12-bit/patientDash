class UserModel {
  final String id;
  final String fullName;
  final String email;
  final int age;
  final String gender;
  final String mobileNumber;
  final String address;
  final String emergencyContact;
  final String bloodGroup;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.address,
    required this.emergencyContact,
    required this.bloodGroup,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      address: map['address'] ?? '',
      emergencyContact: map['emergencyContact'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'age': age,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'address': address,
      'emergencyContact': emergencyContact,
      'bloodGroup': bloodGroup,
    };
  }
}

class EmergencyReport {
  final String id;
  final String patientId;
  final String emergencyType;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final DateTime submittedAt;
  final String status;
  final List<String> uploadedFiles;
  final String? assignedHospital;

  EmergencyReport({
    required this.id,
    required this.patientId,
    required this.emergencyType,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.submittedAt,
    required this.status,
    required this.uploadedFiles,
    this.assignedHospital,
  });
}

class Hospital {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final bool hasICU;
  final bool hasOxygen;
  final int availableBeds;
  final String phone;
  final double rating;
  final bool isOpen;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.hasICU,
    required this.hasOxygen,
    required this.availableBeds,
    required this.phone,
    required this.rating,
    required this.isOpen,
  });
}

class AdmissionRecord {
  final String id;
  final String hospitalName;
  final String emergencyType;
  final DateTime admitDate;
  final DateTime? dischargeDate;
  final String status; // 'pending', 'admitted', 'discharged', 'rejected'
  final String doctorName;

  AdmissionRecord({
    required this.id,
    required this.hospitalName,
    required this.emergencyType,
    required this.admitDate,
    this.dischargeDate,
    required this.status,
    required this.doctorName,
  });
}
