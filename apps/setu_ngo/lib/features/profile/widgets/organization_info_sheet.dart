import 'package:flutter/material.dart';
import '../models/ngo_profile_model.dart';

class OrganizationInfoSheet extends StatelessWidget {
  final OrganizationInfo info;

  const OrganizationInfoSheet({super.key, required this.info});

  static void show(BuildContext context, OrganizationInfo info) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrganizationInfoSheet(info: info),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Organization Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),
          _InfoTile(
            label: 'Registration Number',
            value: info.registrationNumber,
            icon: Icons.confirmation_number_outlined,
          ),
          _InfoTile(
            label: 'Established Year',
            value: info.establishedYear,
            icon: Icons.calendar_today_outlined,
          ),
          _InfoTile(
            label: 'Organization Type',
            value: info.organizationType,
            icon: Icons.business_outlined,
          ),
          _InfoTile(
            label: 'Tax Exemption Status',
            value: info.taxExemptionStatus,
            icon: Icons.receipt_long_outlined,
          ),
          if (info.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              info.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF444444),
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF6B5ECD).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6B5ECD)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : '—',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}