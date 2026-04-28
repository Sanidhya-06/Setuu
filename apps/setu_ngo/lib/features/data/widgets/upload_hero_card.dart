import 'package:flutter/material.dart';

class UploadHeroCard extends StatelessWidget {
  final VoidCallback onUploadTap;

  const UploadHeroCard({super.key, required this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF3A2ECC), Color(0xFF6C5CE7), Color(0xFF9B87FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -24,
              top: -24,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              right: 50,
              bottom: -36,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            // Illustration
            const Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: _UploadIllustration(),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Upload New Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Upload excel, csv or pdf files.\nOur system will process and generate insights.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: onUploadTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            color: Color(0xFF4A3AFF),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Upload Data',
                            style: TextStyle(
                              color: Color(0xFF4A3AFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

// ── Illustration ──────────────────────────────────────────

class _UploadIllustration extends StatelessWidget {
  const _UploadIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // White document card
          Positioned(
            right: 0,
            top: 20,
            child: Container(
              width: 74,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LineBlock(width: 44, color: const Color(0xFFEEEBFF)),
                  const SizedBox(height: 5),
                  _LineBlock(width: 32, color: const Color(0xFFEEEBFF)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      _MiniBar(height: 14, color: Color(0xFF6C5CE7)),
                      SizedBox(width: 3),
                      _MiniBar(height: 22, color: Color(0xFF4A3AFF)),
                      SizedBox(width: 3),
                      _MiniBar(height: 10, color: Color(0xFF9B87FF)),
                      SizedBox(width: 3),
                      _MiniBar(height: 18, color: Color(0xFF6C5CE7)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // XLS badge
          Positioned(
            left: 0,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF00B47E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'XLS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          // Upload circle
          Positioned(
            right: -4,
            bottom: 14,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF00B47E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineBlock extends StatelessWidget {
  final double width;
  final Color color;

  const _LineBlock({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  final double height;
  final Color color;

  const _MiniBar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}