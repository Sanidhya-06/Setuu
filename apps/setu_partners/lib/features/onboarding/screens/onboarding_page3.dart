import 'package:flutter/material.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  static const _perks = [
    'Personalized campaign recommendations',
    'Updates on local opportunities',
    'Impact tracking & badges',
    'A community that cares',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // ── Illustration ──────────────────────────────────────────────────
          Center(
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEEEBFF),
                    const Color(0xFFF5F0FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Three people high-fiving
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _PersonAvatar(
                        color: const Color(0xFF7B6FFF),
                        size: 64,
                        icon: Icons.person_rounded,
                      ),
                      const SizedBox(width: 8),
                      _PersonAvatar(
                        color: const Color(0xFF3D35CC),
                        size: 76,
                        icon: Icons.person_rounded,
                      ),
                      const SizedBox(width: 8),
                      _PersonAvatar(
                        color: const Color(0xFF5A4EFF),
                        size: 64,
                        icon: Icons.person_rounded,
                      ),
                    ],
                  ),
                  // Hands up icon overlay
                  const Positioned(
                    top: 16,
                    child: Icon(
                      Icons.celebration_rounded,
                      color: Color(0xFF5A4EFF),
                      size: 36,
                    ),
                  ),
                  // Confetti dots
                  ..._confettiDots(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Title ────────────────────────────────────────────────────────
          const Text(
            "You're all set! 🎉",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1C),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "We'll personalize your feed and keep\nyou updated on what matters.",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              color: Color(0xFF6B6B6B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // ── Perks Card ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You'll get",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                const SizedBox(height: 14),
                ..._perks.map(
                  (perk) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5A4EFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          perk,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 13,
                            color: Color(0xFF1C1C1C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _confettiDots() {
    final positions = [
      {'top': 20.0, 'left': 20.0, 'color': const Color(0xFFFFD740)},
      {'top': 30.0, 'right': 30.0, 'color': const Color(0xFFFF6B6B)},
      {'bottom': 30.0, 'left': 40.0, 'color': const Color(0xFF69F0AE)},
      {'bottom': 20.0, 'right': 50.0, 'color': const Color(0xFF40C4FF)},
    ];
    return positions.map((p) {
      return Positioned(
        top: p['top'] as double?,
        bottom: p['bottom'] as double?,
        left: p['left'] as double?,
        right: p['right'] as double?,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: p['color'] as Color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}

class _PersonAvatar extends StatelessWidget {
  final Color color;
  final double size;
  final IconData icon;

  const _PersonAvatar({
    required this.color,
    required this.size,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.55),
    );
  }
}