import 'package:flutter/material.dart';
import 'report_controller.dart';

class ImagePickerWidget extends StatelessWidget {
  final ReportController controller;

  const ImagePickerWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Upload Photo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(Optional)',
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF7C3AED).withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => controller.setImageSelected(true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
              color: controller.isImageSelected
                  ? const Color(0xFF7C3AED).withOpacity(0.08)
                  : const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: controller.isImageSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF7C3AED).withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: controller.isImageSelected
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF7C3AED),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Image Selected',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to change',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Color(0xFF7C3AED),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap to upload image',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PNG, JPG up to 5MB',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}