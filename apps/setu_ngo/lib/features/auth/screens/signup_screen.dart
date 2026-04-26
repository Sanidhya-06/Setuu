// apps/setu_ngo/lib/features/auth/screens/signup_screen.dart
//
// Root of the signup flow. Wraps RegistrationProvider and switches
// between Step screens + the success screen based on provider state.
// No Navigator.push between steps — avoids back-stack pollution.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/signup_widgets.dart';
import 'signup_step1_screen.dart';
import 'signup_step2_screen.dart';
import 'signup_step3_screen.dart';
import 'signup_step4_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: const _SignupShell(),
    );
  }
}

class _SignupShell extends StatelessWidget {
  const _SignupShell();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    // Submitted → show success screen
    if (provider.isSubmitted) return const _SuccessScreen();

    // Route between steps — AnimatedSwitcher gives a gentle fade
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: switch (provider.currentStep) {
        1 => const SignupStep1Screen(key: ValueKey(1)),
        2 => const SignupStep2Screen(key: ValueKey(2)),
        3 => const SignupStep3Screen(key: ValueKey(3)),
        4 => const SignupStep4Screen(key: ValueKey(4)),
        _ => const SignupStep1Screen(key: ValueKey(1)),
      },
    );
  }
}

// ── Success Screen ────────────────────────────────────────────────────────────

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated check
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value, child: child),
                child: Container(
                  width: 100, height: 100,
                  decoration: const BoxDecoration(
                    color: kSuccess, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 52),
                ),
              ),
              const SizedBox(height: 32),

              const Text('Application Submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w700,
                  color: kTextDark, letterSpacing: -0.5)),
              const SizedBox(height: 12),
              const Text(
                'Your NGO registration is under review.\nWe\'ll notify you via email and SMS once verified.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: kTextGrey, height: 1.5)),
              const SizedBox(height: 48),

           PrimaryButton(
                  label: 'Back to Login',
                  showArrow: false,
                  onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (_) => LoginScreen()),
                 (route) => false,
        );
         },
 ), 
            ],
          ),
        ),
      ),
    );
  }
}