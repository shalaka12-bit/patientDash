// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import 'register_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final auth = Get.find<AuthService>();
    final err = await auth.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    setState(() => _loading = false);
    if (err != null) {
      Get.snackbar('Login Failed', err,
          backgroundColor: AppColors.error, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.local_hospital_rounded,
                        size: 42, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Welcome back',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                const Text('Sign in to your account',
                    style: TextStyle(
                        fontSize: 15, color: AppColors.textSecondary)),
                const SizedBox(height: 36),
                CustomTextField(
                  controller: _emailCtrl,
                  label: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v!.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 16),
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
                  validator: (v) =>
                      v!.length < 6 ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Sign In',
                  loading: _loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(() => const RegisterScreen()),
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
