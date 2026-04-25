import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          size: 44,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'MedAlert',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Patient Dashboard',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Login Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Sign in to your account',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.primary),
                          hintText: 'Enter your email',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Email is required';
                          if (!v.contains('@')) return 'Enter valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined,
                              color: AppColors.primary),
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Password is required';
                          if (v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
