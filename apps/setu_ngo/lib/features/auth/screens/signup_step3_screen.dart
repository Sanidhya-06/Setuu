// apps/setu_ngo/lib/features/auth/screens/signup_step3_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/signup_widgets.dart';

class SignupStep3Screen extends StatefulWidget {
  const SignupStep3Screen({super.key});

  @override
  State<SignupStep3Screen> createState() => _SignupStep3ScreenState();
}

class _SignupStep3ScreenState extends State<SignupStep3Screen> {
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _socialCtrl;

  @override
  void initState() {
    super.initState();
    final p = context.read<RegistrationProvider>();
    _websiteCtrl = TextEditingController(text: p.websiteUrl);
    _socialCtrl  = TextEditingController(text: p.socialMediaLink);
  }

  @override
  void dispose() {
    _websiteCtrl.dispose();
    _socialCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String slot) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);

    // Validate size (5 MB max)
    final bytes = await file.length();
    if (bytes > 5 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File must be under 5 MB')),
        );
      }
      return;
    }

    // Fake upload — drives progress bar in the UI, file goes nowhere
    if (mounted) {
      await context.read<RegistrationProvider>().pickAndFakeUpload(
        file: file,
        slot: slot,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: kBg,
      appBar: signupAppBar(
        step: 'Step 3 of 4',
        onBack: () => provider.goBack(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicator(currentStep: 3, totalSteps: 4),
              const SizedBox(height: 28),
              const StepIllustration(icon: Icons.verified_outlined),
              const SizedBox(height: 28),

              const SectionHeader(
                title: 'Verification & Documents',
                subtitle: 'Upload required documents for verification.',
              ),
              const SizedBox(height: 24),

              // Registration Certificate
              FileUploadTile(
                label: 'Registration Certificate',
                subtitle: 'Upload your NGO registration certificate',
                note: 'PDF, JPG or PNG (Max. 5MB)',
                fileName: provider.registrationCertificate?.path.split('/').last,
                progress: provider.certProgress,
                onTap: () => _pickFile('cert'),
              ),
              const SizedBox(height: 20),

              // Government ID Proof
              FileUploadTile(
                label: 'Government ID Proof',
                subtitle: 'Upload PAN card / Aadhaar / 12A / 80G certificate',
                note: 'PDF, JPG or PNG (Max. 5MB)',
                fileName: provider.governmentIdProof?.path.split('/').last,
                progress: provider.govIdProgress,
                onTap: () => _pickFile('govId'),
              ),
              const SizedBox(height: 20),

              // Additional Document (optional)
              FileUploadTile(
                label: 'Additional Document',
                subtitle: 'Any other supporting document',
                note: 'PDF, JPG or PNG (Max. 5MB)',
                required: false,
                fileName: provider.additionalDocument?.path.split('/').last,
                progress: provider.additionalDocProgress,
                onTap: () => _pickFile('additional'),
              ),
              const SizedBox(height: 20),

              // Website (optional)
              const FieldLabel(label: 'Website', required: false),
              SignupTextField(
                controller: _websiteCtrl,
                hint: 'Enter your website URL',
                prefixIcon: Icons.language_outlined,
                keyboardType: TextInputType.url,
                onChanged: (val) {
                  provider.updateField(() => provider.websiteUrl = val);
                },
              ),
              const SizedBox(height: 16),

              // Social Media (optional)
              const FieldLabel(label: 'Social Media', required: false),
              SignupTextField(
                controller: _socialCtrl,
                hint: 'Enter social media link',
                prefixIcon: Icons.share_outlined,
                keyboardType: TextInputType.url,
                onChanged: (val) {
                  provider.updateField(() => provider.socialMediaLink = val);
                },
              ),
              const SizedBox(height: 20),

              if (provider.errorMessage != null) ...[
                ErrorBanner(message: provider.errorMessage!),
                const SizedBox(height: 16),
              ],

              Row(children: [
                Expanded(child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => provider.goBack(),
                )),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: PrimaryButton(
                  label: 'Next',
                  onTap: () => provider.validateAndNextStep3(),
                )),
              ]),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}