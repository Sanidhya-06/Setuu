import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final String? fileName;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const UploadBox({
    super.key,
    this.fileName,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null && fileName!.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: hasFile
            ? const Color(0xFF5B4CFF).withOpacity(0.04)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasFile
              ? const Color(0xFF5B4CFF).withOpacity(0.45)
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: hasFile
          ? _FileRow(fileName: fileName!, onRemove: onRemove)
          : _UploadPrompt(onTap: onTap),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────

class _UploadPrompt extends StatelessWidget {
  final VoidCallback onTap;
  const _UploadPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFF5B4CFF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_upload_outlined,
            size: 34,
            color: Color(0xFF5B4CFF),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap to upload a file',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Supports PDF, JPG, PNG, DOCX',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFF5B4CFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Choose File',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FileRow extends StatelessWidget {
  final String fileName;
  final VoidCallback? onRemove;
  const _FileRow({required this.fileName, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF5B4CFF).withOpacity(0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.insert_drive_file_outlined,
              color: Color(0xFF5B4CFF), size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'File selected  ·  Ready to upload',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.close, size: 16, color: Colors.red.shade400),
          ),
        ),
      ],
    );
  }
}