import 'package:flutter/material.dart';
import '../widgets/interest_chip.dart';
import '../onboarding_controller.dart';

class OnboardingPage1 extends StatelessWidget {
  final OnboardingController controller;

  const OnboardingPage1({super.key, required this.controller});

  static const _interests = [
    {'label': 'Environment', 'icon': Icons.eco_rounded, 'color': Color(0xFF4CAF50)},
    {'label': 'Education', 'icon': Icons.school_rounded, 'color': Color(0xFF5A4EFF)},
    {'label': 'Health', 'icon': Icons.favorite_rounded, 'color': Color(0xFFE53935)},
    {'label': 'Animal Welfare', 'icon': Icons.pets_rounded, 'color': Color(0xFFFF8F00)},
    {'label': 'Community', 'icon': Icons.group_rounded, 'color': Color(0xFF5A4EFF)},
    {'label': 'Disaster Relief', 'icon': Icons.shield_rounded, 'color': Color(0xFF757575)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // ── Illustration ─────────────────────────────────────────────────
          Center(
            child: Container(
              width: 220,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEBFF),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // floating interest icons around center
                  _FloatingIcon(Icons.eco_rounded, const Color(0xFF4CAF50), top: 20, left: 30),
                  _FloatingIcon(Icons.school_rounded, const Color(0xFF5A4EFF), top: 20, right: 30),
                  _FloatingIcon(Icons.favorite_rounded, const Color(0xFFE53935), bottom: 40, left: 20),
                  _FloatingIcon(Icons.group_rounded, const Color(0xFF5A4EFF), bottom: 40, right: 20),
                  // center person icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5A4EFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Title ────────────────────────────────────────────────────────
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1C),
                height: 1.3,
              ),
              children: [
                TextSpan(text: "Let's "),
                TextSpan(
                  text: 'personalize',
                  style: TextStyle(color: Color(0xFF5A4EFF)),
                ),
                TextSpan(text: '\nyour experience'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tell us what interests you so we can\nshow you the right campaigns.',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              color: Color(0xFF6B6B6B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // ── Interests label ───────────────────────────────────────────────
          const Text(
            'Select your interests',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1C),
            ),
          ),
          const SizedBox(height: 14),

          // ── Interests grid ────────────────────────────────────────────────
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _interests.map((item) {
                final label = item['label'] as String;
                return InterestChip(
                  label: label,
                  icon: item['icon'] as IconData,
                  iconColor: item['color'] as Color,
                  isSelected: controller.isSelected(label),
                  onTap: () => controller.toggleInterest(label),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? top, bottom, left, right;

  const _FloatingIcon(
    this.icon,
    this.color, {
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}