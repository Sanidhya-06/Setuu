// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'insights_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;

  static const _screens = [
    UploadScreen(),
    InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: Container(
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBtn(
                  icon: Icons.upload_file_outlined,
                  label: 'Upload',
                  selected: _idx == 0,
                  onTap: () => setState(() => _idx = 0),
                ),
                _NavBtn(
                  icon: Icons.insights_outlined,
                  label: 'Insights',
                  selected: _idx == 1,
                  onTap: () => setState(() => _idx = 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEEEBFF)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected
                    ? const Color(0xFF6C5CE7)
                    : const Color(0xFF8A8A9A),
                size: 22,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w400,
                color: selected
                    ? const Color(0xFF6C5CE7)
                    : const Color(0xFF8A8A9A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}