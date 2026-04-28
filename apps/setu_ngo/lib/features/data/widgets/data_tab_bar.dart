import 'package:flutter/material.dart';

class DataTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const DataTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final isSelected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onTabSelected(i),
              child: Padding(
                padding: const EdgeInsets.only(right: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tabs[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF8A8A9A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2.5,
                      width: isSelected ? (tabs[i].length * 7.8) : 0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DataSearchBar extends StatelessWidget {
  const DataSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  SizedBox(width: 14),
                  Icon(Icons.search, color: Color(0xFFB0B0C0), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Search datasets...',
                    style: TextStyle(
                      color: Color(0xFFB0B0C0),
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          _ActionBtn(
            icon: Icons.filter_list_rounded,
            label: 'Filter',
            fgColor: const Color(0xFF6C5CE7),
          ),
          const SizedBox(width: 8),
          _ActionBtn(
            icon: Icons.swap_vert_rounded,
            fgColor: const Color(0xFF4A4A6A),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color fgColor;

  const _ActionBtn({required this.icon, this.label, required this.fgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding:
          EdgeInsets.symmetric(horizontal: label != null ? 14 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: fgColor, size: 18),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}