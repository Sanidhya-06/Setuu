import 'package:flutter/material.dart';
import '../models/data_file.dart';

class DataBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const DataBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = DataPageData.navItems;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onItemSelected(i),
                behavior: HitTestBehavior.opaque,
                child: _NavChip(
                  item: items[i],
                  isSelected: isSelected,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  final NavBarItem item;
  final bool isSelected;

  const _NavChip({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEEEBFF)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.icon,
            color: isSelected
                ? const Color(0xFF6C5CE7)
                : const Color(0xFF8A8A9A),
            size: 22,
          ),
        ),
        Text(
          item.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected
                ? const Color(0xFF6C5CE7)
                : const Color(0xFF8A8A9A),
          ),
        ),
      ],
    );
  }
}