import 'package:flutter/material.dart';

class InterestChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestChip({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5A4EFF).withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5A4EFF)
                : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF5A4EFF)
                    : const Color(0xFF1C1C1C),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF5A4EFF),
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}