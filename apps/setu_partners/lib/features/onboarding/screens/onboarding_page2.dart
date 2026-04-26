import 'package:flutter/material.dart';
import '../onboarding_controller.dart';

class OnboardingPage2 extends StatelessWidget {
  final OnboardingController controller;

  const OnboardingPage2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // ── Map Illustration ────────────────────────────────────────────
          Center(
            child: SizedBox(
              height: 210,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEBFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  Positioned(
                    top: 0,
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5A4EFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 20,
                          color: const Color(0xFF5A4EFF),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Title ──────────────────────────────────────────────────────
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
                TextSpan(text: 'Where do you want\nto '),
                TextSpan(
                  text: 'make an impact?',
                  style: TextStyle(color: Color(0xFF5A4EFF)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add your location to discover local\nopportunities near you.',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              color: Color(0xFF6B6B6B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // ── Location Card ──────────────────────────────────────────────
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(16),
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
                    'Your Location',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Location display row ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF5A4EFF),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: controller.isLoadingLocation
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF5A4EFF),
                                  ),
                                )
                              : Text(
                                  controller.location,
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 14,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                        ),
                        // GPS detect button
                        GestureDetector(
                          onTap: controller.isLoadingLocation
                              ? null
                              : controller.detectCurrentLocation,
                          child: const Icon(
                            Icons.gps_fixed_rounded,
                            color: Color(0xFF5A4EFF),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Error message ────────────────────────────────────
                  if (controller.locationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      controller.locationError!,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ── Manual entry option ──────────────────────────────
                  GestureDetector(
                    onTap: () => _showManualLocationSheet(context),
                    child: const Row(
                      children: [
                        Text(
                          'Enter manually',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A4EFF),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF5A4EFF),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom sheet for manual location entry ─────────────────────────────
  void _showManualLocationSheet(BuildContext context) {
    final textController = TextEditingController(text: controller.location);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your location',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              autofocus: true,
              style: const TextStyle(fontFamily: 'Rubik', fontSize: 14),
              decoration: InputDecoration(
                hintText: 'e.g. Mumbai, India',
                hintStyle: const TextStyle(color: Color(0xFF6B6B6B)),
                prefixIcon: const Icon(Icons.location_on_outlined,
                    color: Color(0xFF5A4EFF)),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A4EFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  final entered = textController.text.trim();
                  if (entered.isNotEmpty) {
                    controller.updateLocation(entered);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5A4EFF).withOpacity(0.08)
      ..strokeWidth = 1;

    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final roadPaint = Paint()
      ..color = const Color(0xFF5A4EFF).withOpacity(0.15)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0),
        Offset(size.width * 0.4, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}