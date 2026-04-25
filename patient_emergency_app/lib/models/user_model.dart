// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String fullName;
  final int age;
  final String gender;
  final String mobileNumber;
  final String address;
  final String emergencyContact;
  final String bloodGroup;
  final String email;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.address,
    required this.emergencyContact,
    required this.bloodGroup,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] ?? '',
        fullName: map['fullName'] ?? '',
        age: map['age'] ?? 0,
        gender: map['gender'] ?? '',
        mobileNumber: map['mobileNumber'] ?? '',
        address: map['address'] ?? '',
        emergencyContact: map['emergencyContact'] ?? '',
        bloodGroup: map['bloodGroup'] ?? '',
        email: map['email'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'fullName': fullName,
        'age': age,
        'gender': gender,
        'mobileNumber': mobileNumber,
        'address': address,
        'emergencyContact': emergencyContact,
        'bloodGroup': bloodGroup,
        'email': email,
      };
}
