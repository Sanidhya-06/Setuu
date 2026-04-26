// apps/setu_ngo/lib/features/auth/widgets/signup_widgets.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

const kPrimary    = Color(0xFF5B4FCF);
const kPrimaryBg  = Color(0xFFEDE9FF);
const kBorder     = Color(0xFFE0E0E0);
const kTextDark   = Color(0xFF1A1A2E);
const kTextGrey   = Color(0xFF9E9E9E);
const kBg         = Color(0xFFF8F7FF);
const kSuccess    = Color(0xFF4CAF50);
const kError      = Color(0xFFE53935);

// ── Step Indicator ────────────────────────────────────────────────────────────

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final step = i + 1;
        final done   = step < currentStep;
        final active = step == currentStep;
        return Row(children: [
          _Dot(step: step, done: done, active: active),
          if (step < totalSteps)
            Container(width: 40, height: 2,
              color: done ? kPrimary : kBorder),
        ]);
      }),
    );
  }
}

class _Dot extends StatelessWidget {
  final int step;
  final bool done, active;
  const _Dot({required this.step, required this.done, required this.active});

  @override
  Widget build(BuildContext context) {
    final filled = done || active;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 32, height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? kPrimary : Colors.white,
        border: Border.all(color: filled ? kPrimary : kBorder, width: 2),
      ),
      child: Center(
        child: done
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
          : Text('$step',
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: active ? Colors.white : kTextGrey)),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title, subtitle;
  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(
        fontSize: 22, fontWeight: FontWeight.w700,
        color: kTextDark, letterSpacing: -0.4)),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(fontSize: 14, color: kTextGrey)),
    ],
  );
}

// ── Field Label ───────────────────────────────────────────────────────────────

class FieldLabel extends StatelessWidget {
  final String label;
  final bool required;
  const FieldLabel({super.key, required this.label, this.required = true});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(text: TextSpan(
      text: label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kTextDark),
      children: required ? [const TextSpan(
        text: ' *', style: TextStyle(color: kError))] : [],
    )),
  );
}

// ── Text Field ────────────────────────────────────────────────────────────────

class SignupTextField extends StatelessWidget {
  final String hint;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final int maxLines;

  const SignupTextField({
    super.key,
    required this.hint,
    this.prefixIcon,
    this.prefixWidget,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.maxLines = 1,
  });

  static InputDecoration _dec({
    required String hint,
    Widget? prefix,
    Widget? suffix,
  }) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: kTextGrey, fontSize: 14),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPrimary, width: 1.5)),
    );

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    onChanged: onChanged,
    style: const TextStyle(fontSize: 14, color: kTextDark),
    decoration: _dec(
      hint: hint,
      prefix: prefixWidget ?? (prefixIcon != null ? Icon(prefixIcon, color: kTextGrey, size: 18) : null),
      suffix: suffixIcon,
    ),
  );
}

// ── Dropdown ──────────────────────────────────────────────────────────────────

class SignupDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData? prefixIcon;

  const SignupDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: (value?.isEmpty ?? true) ? null : value,
    hint: Text(hint, style: const TextStyle(color: kTextGrey, fontSize: 14)),
    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kTextGrey),
    items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: kTextGrey, size: 18) : null,
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPrimary, width: 1.5)),
    ),
  );
}

// ── File Upload Tile ──────────────────────────────────────────────────────────

class FileUploadTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final String note;
  final bool required;
  final String? fileName;      // null = nothing picked yet
  final double? progress;      // null = idle | 0–1 uploading | 1.0 = done
  final VoidCallback onTap;

  const FileUploadTile({
    super.key,
    required this.label,
    required this.subtitle,
    required this.note,
    required this.onTap,
    this.required = true,
    this.fileName,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final idle      = progress == null;
    final uploading = !idle && progress! < 1.0;
    final done      = !idle && progress! >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, required: required),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: kTextGrey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: uploading ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: done ? const Color(0xFFEEFAF0) : Colors.white,
              border: Border.all(
                color: done ? kSuccess : uploading ? kPrimary : kBorder,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: done
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.check_circle_rounded, color: kSuccess, size: 18),
                  const SizedBox(width: 8),
                  Flexible(child: Text(fileName ?? 'Uploaded',
                    style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis)),
                ])
              : uploading
                ? Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Flexible(child: Text(fileName ?? '', style: const TextStyle(fontSize: 12, color: kPrimary, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                      Text('${(progress! * 100).toInt()}%', style: const TextStyle(fontSize: 12, color: kPrimary, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: kPrimaryBg,
                        valueColor: const AlwaysStoppedAnimation<Color>(kPrimary),
                      ),
                    ),
                  ])
                : Column(children: [
                    const Icon(Icons.upload_rounded, color: kPrimary, size: 22),
                    const SizedBox(height: 4),
                    const Text('Upload File', style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                  ]),
          ),
        ),
        const SizedBox(height: 4),
        Text(note, style: const TextStyle(fontSize: 11, color: kTextGrey)),
      ],
    );
  }
}

// ── Primary Button ────────────────────────────────────────────────────────────

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showArrow;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: 52,
    child: ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        disabledBackgroundColor: kPrimary.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isLoading
        ? const SizedBox(width: 22, height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ]),
    ),
  );
}

// ── Back Outline Button ───────────────────────────────────────────────────────

class BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.arrow_back_rounded, color: kPrimary, size: 18),
        SizedBox(width: 6),
        Text('Back', style: TextStyle(color: kPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

// ── Error Banner ──────────────────────────────────────────────────────────────

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEBEE),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: kError.withOpacity(0.3)),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline_rounded, color: kError, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(message,
        style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 13))),
    ]),
  );
}

// ── Shared AppBar builder ─────────────────────────────────────────────────────

AppBar signupAppBar({required String step, required VoidCallback onBack}) =>
  AppBar(
    backgroundColor: kBg, elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_rounded, color: kTextDark),
      onPressed: onBack,
    ),
    title: Column(children: [
      const Text('Sign Up',
        style: TextStyle(color: kTextDark, fontSize: 17, fontWeight: FontWeight.w700)),
      const Text('Create your NGO account',
        style: TextStyle(color: kTextGrey, fontSize: 12)),
      Text(step, style: const TextStyle(color: kTextGrey, fontSize: 11)),
    ]),
    centerTitle: true,
  );

// ── Step illustration placeholder ─────────────────────────────────────────────

class StepIllustration extends StatelessWidget {
  final IconData icon;
  const StepIllustration({super.key, required this.icon});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      height: 110, width: 110,
      decoration: BoxDecoration(color: kPrimaryBg, shape: BoxShape.circle),
      child: Icon(icon, size: 52, color: kPrimary),
    ),
  );
}