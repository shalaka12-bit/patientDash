// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emergencyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _gender;
  String? _bloodGroup;
  bool _loading = false;
  bool _obscure = true;

  final _genders = ['Male', 'Female', 'Other'];
  final _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null || _bloodGroup == null) {
      Get.snackbar('Missing Fields', 'Please select Gender and Blood Group',
          backgroundColor: AppColors.warning, colorText: Colors.white);
      return;
    }
    setState(() => _loading = true);
    final auth = Get.find<AuthService>();
    final err = await auth.register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      fullName: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      gender: _gender!,
      mobileNumber: _mobileCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      emergencyContact: _emergencyCtrl.text.trim(),
      bloodGroup: _bloodGroup!,
    );
    setState(() => _loading = false);
    if (err != null) {
      Get.snackbar('Registration Failed', err,
          backgroundColor: AppColors.error, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Personal Information'),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _ageCtrl,
                  label: 'Age',
                  prefixIcon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                // Gender dropdown
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc_outlined),
                  ),
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _mobileCtrl,
                  label: 'Mobile Number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _addressCtrl,
                  label: 'Address',
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _emergencyCtrl,
                  label: 'Emergency Contact',
                  prefixIcon: Icons.emergency_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _bloodGroup,
                  decoration: const InputDecoration(
                    labelText: 'Blood Group',
                    prefixIcon: Icon(Icons.bloodtype_outlined),
                  ),
                  items: _bloodGroups
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  onChanged: (v) => setState(() => _bloodGroup = v),
                ),
                const SizedBox(height: 24),
                _sectionTitle('Account Credentials'),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailCtrl,
                  label: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _passCtrl,
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Create Account',
                  loading: _loading,
                  onPressed: _register,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      );
}
