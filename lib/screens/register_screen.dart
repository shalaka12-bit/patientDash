import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'A+';
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [0, 1, 2].map((i) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color:
                  i <= _currentStep ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Personal Info',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            prefixIcon:
                Icon(Icons.person_outline, color: AppColors.primary),
          ),
          validator: (v) => v!.isEmpty ? 'Full name required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Age *',
            prefixIcon:
                Icon(Icons.cake_outlined, color: AppColors.primary),
          ),
          validator: (v) => v!.isEmpty ? 'Age required' : null,
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gender *',
            prefixIcon:
                Icon(Icons.wc_outlined, color: AppColors.primary),
          ),
          items: _genders
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (v) => setState(() => _selectedGender = v!),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _selectedBloodGroup,
          decoration: const InputDecoration(
            labelText: 'Blood Group *',
            prefixIcon:
                Icon(Icons.bloodtype_outlined, color: AppColors.primary),
          ),
          items: _bloodGroups
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: (v) => setState(() => _selectedBloodGroup = v!),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Info',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Mobile Number *',
            prefixIcon:
                Icon(Icons.phone_outlined, color: AppColors.primary),
          ),
          validator: (v) => v!.isEmpty ? 'Mobile number required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _addressController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Address *',
            prefixIcon:
                Icon(Icons.location_on_outlined, color: AppColors.primary),
            alignLabelWithHint: true,
          ),
          validator: (v) => v!.isEmpty ? 'Address required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _emergencyContactController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Emergency Contact *',
            prefixIcon:
                Icon(Icons.emergency_outlined, color: AppColors.primary),
            helperText: 'Family member or trusted person number',
          ),
          validator: (v) => v!.isEmpty ? 'Emergency contact required' : null,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account Setup',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address *',
            prefixIcon:
                Icon(Icons.email_outlined, color: AppColors.primary),
          ),
          validator: (v) {
            if (v!.isEmpty) return 'Email required';
            if (!v.contains('@')) return 'Enter valid email';
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password *',
            prefixIcon:
                const Icon(Icons.lock_outlined, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (v) {
            if (v!.isEmpty) return 'Password required';
            if (v.length < 6) return 'Minimum 6 characters';
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 8),
              Text(
                'Step ${_currentStep + 1} of 3',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),

              // Step Content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentStep == 0
                    ? _buildStep1()
                    : _currentStep == 1
                        ? _buildStep2()
                        : _buildStep3(),
              ),

              const SizedBox(height: 32),

              // Navigation Buttons
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _currentStep--),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side:
                              const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Back',
                            style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_currentStep < 2) {
                                setState(() => _currentStep++);
                              } else {
                                _handleRegister();
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          : Text(_currentStep < 2
                              ? 'Next'
                              : 'Create Account'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: GoogleFonts.poppins(
                          color: AppColors.textSecondary, fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Sign In',
                        style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
