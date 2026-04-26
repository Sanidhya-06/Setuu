// apps/setu_ngo/lib/features/auth/screens/signup_step2_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/signup_widgets.dart';

class SignupStep2Screen extends StatefulWidget {
  const SignupStep2Screen({super.key});

  @override
  State<SignupStep2Screen> createState() => _SignupStep2ScreenState();
}

class _SignupStep2ScreenState extends State<SignupStep2Screen> {
  late final TextEditingController _regNoCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _pincodeCtrl;

  @override
  void initState() {
    super.initState();
    final p = context.read<RegistrationProvider>();
    _regNoCtrl = TextEditingController(text: p.registrationNumber);
    _addressCtrl = TextEditingController(text: p.address);
    _cityCtrl = TextEditingController(text: p.city);
    _pincodeCtrl = TextEditingController(text: p.pincode);
  }

  @override
  void dispose() {
    _regNoCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    final p = context.read<RegistrationProvider>();
    p.updateField(() {
      p.registrationNumber = _regNoCtrl.text;
      p.address = _addressCtrl.text;
      p.city = _cityCtrl.text;
      p.pincode = _pincodeCtrl.text;
    });
  }

  static const _ngoTypes = [
    'Education',
    'Healthcare',
    'Environment',
    'Women Empowerment',
    'Child Welfare',
    'Animal Welfare',
    'Disaster Relief',
    'Rural Development',
    'Poverty Alleviation',
    'Human Rights',
    'Arts & Culture',
    'Other',
  ];

  static const _indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu & Kashmir',
    'Ladakh',
    'Puducherry',
  ];

  List<String> get _years {
    final current = DateTime.now().year;
    return List.generate(current - 1947, (i) => '${current - i}');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: kBg,
      appBar: signupAppBar(
        step: 'Step 2 of 4',
        onBack: () => provider.goBack(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicator(currentStep: 2, totalSteps: 4),
              const SizedBox(height: 28),
              const StepIllustration(icon: Icons.location_city_outlined),
              const SizedBox(height: 28),

              const SectionHeader(
                title: 'Organization Details',
                subtitle: 'Tell us more about your organization.',
              ),
              const SizedBox(height: 24),

              // NGO Type
              const FieldLabel(label: 'NGO Type / Category'),
              SignupDropdown(
                hint: 'Select category',
                value: provider.ngoType,
                items: _ngoTypes,
                onChanged: (val) {
                  context.read<RegistrationProvider>().updateField(
                    () => context.read<RegistrationProvider>().ngoType =
                        val ?? '',
                  );
                },
              ),
              const SizedBox(height: 16),

              // Registration Number
              const FieldLabel(label: 'Registration Number'),
              SignupTextField(
                controller: _regNoCtrl,
                hint: 'Enter registration number',
                prefixIcon: Icons.tag_rounded,
                onChanged: (_) => _sync(),
              ),
              const SizedBox(height: 16),

              // Year of Establishment
              const FieldLabel(label: 'Year of Establishment'),
              SignupDropdown(
                hint: 'Select year',
                value: provider.yearOfEstablishment,
                items: _years,
                prefixIcon: Icons.calendar_today_outlined,
                onChanged: (val) {
                  context.read<RegistrationProvider>().updateField(
                    () =>
                        context
                                .read<RegistrationProvider>()
                                .yearOfEstablishment =
                            val ?? '',
                  );
                },
              ),
              const SizedBox(height: 16),

              // Address
              const FieldLabel(label: 'Address'),
              SignupTextField(
                controller: _addressCtrl,
                hint: 'Enter complete address',
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                onChanged: (_) => _sync(),
              ),
              const SizedBox(height: 16),

              // City + State
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel(label: 'City'),
                        SignupTextField(
                          controller: _cityCtrl,
                          hint: 'Enter city',
                          onChanged: (_) => _sync(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel(label: 'State'),
                        SignupDropdown(
                          hint: 'Select state',
                          value: provider.state,
                          items: _indianStates,
                          onChanged: (val) {
                            context.read<RegistrationProvider>().updateField(
                              () => context.read<RegistrationProvider>().state =
                                  val ?? '',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pincode
              const FieldLabel(label: 'Pincode'),
              SignupTextField(
                controller: _pincodeCtrl,
                hint: 'Enter pincode',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (_) => _sync(),
              ),
              const SizedBox(height: 20),

              if (provider.errorMessage != null) ...[
                ErrorBanner(message: provider.errorMessage!),
                const SizedBox(height: 16),
              ],

              Row(
                children: [
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
                      label: 'Next',
                      onTap: () {
                        _sync();
                        provider.validateAndNextStep2();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
