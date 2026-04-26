// apps/setu_ngo/lib/features/auth/screens/signup_step4_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/signup_widgets.dart';

class SignupStep4Screen extends StatefulWidget {
  const SignupStep4Screen({super.key});

  @override
  State<SignupStep4Screen> createState() => _SignupStep4ScreenState();
}

class _SignupStep4ScreenState extends State<SignupStep4Screen> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: kBg,
      appBar: signupAppBar(
        step: 'Step 4 of 4',
        onBack: () => provider.goBack(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicator(currentStep: 4, totalSteps: 4),
              const SizedBox(height: 28),

              // Success illustration
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 110, height: 110,
                      decoration: const BoxDecoration(
                        color: kPrimaryBg, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: kPrimary, size: 48),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        width: 36, height: 36,
                        decoration: const BoxDecoration(
                          color: kSuccess, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text('Almost Done!',
                  style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700,
                    color: kTextDark, letterSpacing: -0.5)),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text('Review your details and submit your application.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: kTextGrey)),
              ),
              const SizedBox(height: 28),

              // What happens next
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kPrimaryBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What happens next?',
                      style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700, color: kPrimary)),
                    const SizedBox(height: 16),
                    _NextStep(
                      icon: Icons.description_outlined,
                      text: 'We will review your application and documents.',
                    ),
                    const SizedBox(height: 14),
                    _NextStep(
                      icon: Icons.mail_outline_rounded,
                      text: 'You will receive an email and SMS once verified.',
                    ),
                    const SizedBox(height: 14),
                    _NextStep(
                      icon: Icons.lock_open_outlined,
                      text: 'Once approved, you can access all features.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Summary card
              _SummaryCard(provider: provider),
              const SizedBox(height: 24),

              // Confirmation checkbox
              GestureDetector(
                onTap: () => setState(() => _confirmed = !_confirmed),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: _confirmed ? kPrimary : Colors.white,
                        border: Border.all(
                          color: _confirmed ? kPrimary : kBorder, width: 1.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _confirmed
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                        : null,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'I confirm that all the information provided is true and accurate.',
                        style: TextStyle(fontSize: 13, color: kTextDark, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (provider.errorMessage != null) ...[
                ErrorBanner(message: provider.errorMessage!),
                const SizedBox(height: 16),
              ],

              Row(children: [
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => provider.goBack(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: 'Submit Application',
                    showArrow: false,
                    isLoading: provider.isLoading,
                    onTap: _confirmed ? () => provider.submitApplication() : null,
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 13, color: kTextGrey),
                    SizedBox(width: 4),
                    Text('Your information is secure with us.',
                      style: TextStyle(fontSize: 12, color: kTextGrey)),
                  ],
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

// ── What happens next row ─────────────────────────────────────────────────────

class _NextStep extends StatelessWidget {
  final IconData icon;
  final String text;
  const _NextStep({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: kPrimary, size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(text,
            style: const TextStyle(fontSize: 13, color: kTextDark, height: 1.4)),
        ),
      ),
    ],
  );
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final RegistrationProvider provider;
  const _SummaryCard({required this.provider});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Application Summary',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextDark)),
        const SizedBox(height: 12),
        const Divider(color: kBorder, height: 1),
        const SizedBox(height: 12),
        _Row('NGO Name',      provider.ngoName),
        _Row('Email',         provider.email),
        _Row('Phone',         '+91 ${provider.phoneNumber}'),
        _Row('Type',          provider.ngoType),
        _Row('Reg. Number',   provider.registrationNumber),
        _Row('Year Est.',     provider.yearOfEstablishment),
        _Row('City / State',  '${provider.city}, ${provider.state}'),
        _Row('Pincode',       provider.pincode),
        if (provider.websiteUrl.isNotEmpty)
          _Row('Website', provider.websiteUrl),
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
            style: const TextStyle(fontSize: 12, color: kTextGrey)),
        ),
        Expanded(
          child: Text(value,
            style: const TextStyle(fontSize: 13, color: kTextDark, fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );
}