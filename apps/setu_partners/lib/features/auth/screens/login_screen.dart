import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';
import '../widgets/social_login.dart';
import '../../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart'; // ✅ ADD THIS
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // ✅ Basic validation
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.logIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // ✅ Navigate to home
      Navigator.pushReplacementNamed(context, AppRoutes.home);

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                'Welcome Back! 👋',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Log in to your account',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  color: Color(0xFF6B6B6B),
                ),
              ),
              const SizedBox(height: 28),

              // Tabs
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A4EFF),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: const Text(
                            'Sign Up',
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fields
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
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5A4EFF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              AuthButton(
                label: 'Log In',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 28),

              const SocialLogin(),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 13,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
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