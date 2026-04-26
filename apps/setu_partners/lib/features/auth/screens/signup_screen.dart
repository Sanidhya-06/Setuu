import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';
import '../widgets/social_login.dart';
import '../../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart'; 

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // ✅ SUCCESS → Navigate to onboarding
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboarding,
      );

    } on FirebaseAuthException catch (e) {
      String message = e.message ?? "Signup failed";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome! 👋',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Create an account to get started',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  color: Color(0xFF6B6B6B),
                ),
              ),
              const SizedBox(height: 28),

              // Toggle Tabs
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A4EFF),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              InputField(
                controller: _nameController,
                hint: 'Name',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),

              InputField(
                controller: _emailController,
                hint: 'Email',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              InputField(
                controller: _passwordController,
                hint: 'Password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF6B6B6B),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 28),

              AuthButton(
                label: 'Sign Up',
                isLoading: _isLoading,
                onPressed: _handleSignUp,
              ),

              const SizedBox(height: 28),

              const SocialLogin(),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 13,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5A4EFF),
                      ),
                    ),
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