import 'package:flutter/material.dart';
import '../models/data_file.dart';

class DataFileListItem extends StatelessWidget {
  final DataFile file;

  const DataFileListItem({super.key, required this.file});

  // ── Helpers ─────────────────────────────────────────────

  Color get _iconBg {
    switch (file.fileType) {
      case FileType.xlsx:
        return const Color(0xFFE6F9F1);
      case FileType.csv:
        return const Color(0xFFFFF3E6);
      case FileType.pdf:
        return const Color(0xFFFFEBEB);
    }
  }

  Color get _iconColor {
    switch (file.fileType) {
      case FileType.xlsx:
        return const Color(0xFF00B47E);
      case FileType.csv:
        return const Color(0xFFFF8C00);
      case FileType.pdf:
        return const Color(0xFFFF4B4B);
    }
  }

  IconData get _icon {
    switch (file.fileType) {
      case FileType.xlsx:
        return Icons.table_chart_outlined;
      case FileType.csv:
        return Icons.view_list_outlined;
      case FileType.pdf:
        return Icons.picture_as_pdf_outlined;
    }
  }

  String get _typeLabel {
    switch (file.fileType) {
      case FileType.xlsx:
        return 'XLS';
      case FileType.csv:
        return 'CSV';
      case FileType.pdf:
        return 'PDF';
    }
  }

  String _fmt(int n) {
    if (n >= 1000) {
      final thousands = n ~/ 1000;
      final remainder = (n % 1000).toString().padLeft(3, '0');
      return '$thousands,$remainder';
    }
    return n.toString();
  }

  // ── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          _FileIcon(bg: _iconBg, color: _iconColor, icon: _icon, label: _typeLabel),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  'Uploaded on ${file.uploadedOn} · ${file.sizeMB} · ${_fmt(file.records)} records',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8A8A9A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                _StatusBadge(status: file.status),
              ],
            ),
          ),
          const SizedBox(width: 8),
          file.status == ProcessingStatus.processing
              ? _ProgressColumn(progress: file.processingProgress ?? 0)
              : const Icon(Icons.more_vert, color: Color(0xFF8A8A9A), size: 20),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────

class _FileIcon extends StatelessWidget {
  final Color bg;
  final Color color;
  final IconData icon;
  final String label;

  const _FileIcon({
    required this.bg,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 6,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProcessingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == ProcessingStatus.processed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F9F1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Processed',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00B47E),
          ),
        ),
      );
    }
    if (status == ProcessingStatus.processing) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
            ),
          ),
          SizedBox(width: 6),
          Text(
            'Processing',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C5CE7),
            ),
          ),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Failed',
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFF4B4B),
        ),
      ),
    );
  }
}

class _ProgressColumn extends StatelessWidget {
  final double progress;

  const _ProgressColumn({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6C5CE7),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFEEEBFF),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}