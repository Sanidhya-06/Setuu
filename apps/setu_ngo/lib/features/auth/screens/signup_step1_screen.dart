// apps/setu_ngo/lib/features/auth/screens/signup_step1_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/signup_widgets.dart';

class SignupStep1Screen extends StatefulWidget {
  const SignupStep1Screen({super.key});

  @override
  State<SignupStep1Screen> createState() => _SignupStep1ScreenState();
}

class _SignupStep1ScreenState extends State<SignupStep1Screen> {
  late final TextEditingController _ngoNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmCtrl;

  bool _showPassword = false;
  bool _showConfirm  = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from provider in case user navigated back
    final p = context.read<RegistrationProvider>();
    _ngoNameCtrl = TextEditingController(text: p.ngoName);
    _emailCtrl   = TextEditingController(text: p.email);
    _phoneCtrl   = TextEditingController(text: p.phoneNumber);
    _passwordCtrl = TextEditingController(text: p.password);
    _confirmCtrl  = TextEditingController(text: p.confirmPassword);
  }

  @override
  void dispose() {
    _ngoNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    final p = context.read<RegistrationProvider>();
    p.updateField(() {
      p.ngoName         = _ngoNameCtrl.text;
      p.email           = _emailCtrl.text;
      p.phoneNumber     = _phoneCtrl.text;
      p.password        = _passwordCtrl.text;
      p.confirmPassword = _confirmCtrl.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: kBg,
      appBar: signupAppBar(
        step: 'Step 1 of 4',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicator(currentStep: 1, totalSteps: 4),
              const SizedBox(height: 28),
              const StepIllustration(icon: Icons.assignment_ind_outlined),
              const SizedBox(height: 28),

              const SectionHeader(
                title: 'Basic Information',
                subtitle: "Let's start with your basic details.",
              ),
              const SizedBox(height: 24),

              // NGO Name
              const FieldLabel(label: 'NGO Name'),
              SignupTextField(
                controller: _ngoNameCtrl,
                hint: 'Enter your NGO name',
                prefixIcon: Icons.business_outlined,
                onChanged: (_) => _sync(),
              ),
              const SizedBox(height: 16),

              // Email
              const FieldLabel(label: 'Email Address'),
              SignupTextField(
                controller: _emailCtrl,
                hint: 'Enter your email address',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _sync(),
              ),
              const SizedBox(height: 16),

              // Phone
              const FieldLabel(label: 'Phone Number'),
              SignupTextField(
                controller: _phoneCtrl,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (_) => _sync(),
                prefixWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12),
                    const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    const Text('+91',
                      style: TextStyle(color: kTextDark, fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(width: 6),
                    Container(width: 1, height: 20, color: kBorder),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Password
              const FieldLabel(label: 'Password'),
              SignupTextField(
                controller: _passwordCtrl,
                hint: 'Create a strong password',
                prefixIcon: Icons.lock_outline_rounded,
                obscure: !_showPassword,
                onChanged: (_) => _sync(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: kTextGrey, size: 18),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              const FieldLabel(label: 'Confirm Password'),
              SignupTextField(
                controller: _confirmCtrl,
                hint: 'Confirm your password',
                prefixIcon: Icons.lock_outline_rounded,
                obscure: !_showConfirm,
                onChanged: (_) => _sync(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: kTextGrey, size: 18),
                  onPressed: () => setState(() => _showConfirm = !_showConfirm),
                ),
              ),
              const SizedBox(height: 20),

              if (provider.errorMessage != null) ...[
                ErrorBanner(message: provider.errorMessage!),
                const SizedBox(height: 16),
              ],

              PrimaryButton(
                label: 'Next',
                onTap: () {
                  _sync();
                  provider.validateAndNextStep1();
                },
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: kTextGrey, fontSize: 13),
                    children: [
                      TextSpan(text: 'Login',
                        style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600)),
                    ],
                  )),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}