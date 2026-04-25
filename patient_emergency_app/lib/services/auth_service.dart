// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      await fetchUserModel(user.uid);
      Get.offAll(() => const DashboardScreen());
    }
  }

  Future<void> fetchUserModel(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      userModel.value = UserModel.fromMap(doc.data()!);
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> register({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
    required String mobileNumber,
    required String address,
    required String emergencyContact,
    required String bloodGroup,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = UserModel(
        uid: cred.user!.uid,
        fullName: fullName,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber,
        address: address,
        emergencyContact: emergencyContact,
        bloodGroup: bloodGroup,
        email: email,
      );
      await _db.collection('users').doc(cred.user!.uid).set(user.toMap());
      userModel.value = user;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    userModel.value = null;
  }
}
