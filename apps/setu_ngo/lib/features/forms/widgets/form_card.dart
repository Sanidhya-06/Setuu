import 'package:flutter/material.dart';
import '../form_controller.dart';

class FormCard extends StatelessWidget {
  final FormModel form;
  final VoidCallback? onTap;
  final VoidCallback? onViewResponses;
  final VoidCallback? onDelete;

  const FormCard({
    super.key,
    required this.form,
    this.onTap,
    this.onViewResponses,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconBox(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    form.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    form.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _StatusRow(
                    status: form.status,
                    createdAt: form.createdAt,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${form.responseCount}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5B4CFF),
                      ),
                    ),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (v) {
                        if (v == 'delete') onDelete?.call();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'Responses',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 10),
                _ViewResponsesButton(onTap: onViewResponses),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox() {
    final config = _iconConfig();
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: config.$1,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(config.$2, color: config.$3, size: 22),
    );
  }

  (Color, IconData, Color) _iconConfig() {
    if (form.status == FormStatus.draft) {
      return (
        const Color(0xFFE3F2FD),
        Icons.water_drop_outlined,
        const Color(0xFF2196F3),
      );
    }
    final palette = [
      (const Color(0xFFEDE7FF), Icons.list_alt_rounded, const Color(0xFF7C4DFF)),
      (const Color(0xFFE8F5E9), Icons.group_outlined, const Color(0xFF43A047)),
      (const Color(0xFFFFF3E0), Icons.volunteer_activism_outlined, const Color(0xFFFF8F00)),
      (const Color(0xFFE8EAF6), Icons.school_outlined, const Color(0xFF3F51B5)),
    ];
    return palette[form.id.hashCode.abs() % palette.length];
  }
}

// ── Sub-widgets ──────────────────────────────────

class _StatusRow extends StatelessWidget {
  final FormStatus status;
  final DateTime createdAt;

  const _StatusRow({required this.status, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    final isActive = status == FormStatus.active;
    final color = isActive ? const Color(0xFF4CAF50) : const Color(0xFF2196F3);
    final label = isActive ? 'Active' : 'Draft';
    final prefix = isActive ? 'Created on' : 'Updated on';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateStr =
        '$prefix ${createdAt.day} ${months[createdAt.month - 1]} ${createdAt.year}';

    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          '  ·  $dateStr',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}

class _ViewResponsesButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _ViewResponsesButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF5B4CFF).withOpacity(0.35),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_outlined,
                size: 12, color: const Color(0xFF5B4CFF)),
            const SizedBox(width: 4),
            const Text(
              'View Responses',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B4CFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}