import 'package:flutter/material.dart';

class CategoryStat {
  final String id;
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final int programCount;

  const CategoryStat({
    required this.id,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.programCount,
  });
}