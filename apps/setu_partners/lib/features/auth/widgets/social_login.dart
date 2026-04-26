import 'package:flutter/material.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            const Expanded(
              child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 12,
                  color: Color(0xFF6B6B6B),
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Social buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              onTap: () {},
              child: Image.network(
                'https://www.google.com/favicon.ico',
                width: 22,
                height: 22,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.g_mobiledata_rounded,
                  size: 26,
                  color: Color(0xFF1C1C1C),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _SocialButton(
              onTap: () {},
              child: const Icon(
                Icons.apple_rounded,
                size: 24,
                color: Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(width: 16),
            _SocialButton(
              onTap: () {},
              child: const Icon(
                Icons.facebook_rounded,
                size: 24,
                color: Color(0xFF1877F2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _SocialButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}