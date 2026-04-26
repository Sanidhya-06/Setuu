import 'package:flutter/material.dart';
import '../models/category_stat.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryStat> categories;
  final void Function(CategoryStat)? onTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: categories.map((cat) => _CategoryTile(cat: cat, onTap: onTap)).toList(),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryStat cat;
  final void Function(CategoryStat)? onTap;

  const _CategoryTile({required this.cat, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(cat),
      child: Container(
        decoration: BoxDecoration(
          color: cat.bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat.icon, size: 22, color: cat.iconColor),
            const SizedBox(height: 6),
            Text(
              cat.label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF0D0D0D),
              ),
            ),
            Text(
              '${cat.programCount} Programs',
              style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A7A)),
            ),
          ],
        ),
      ),
    );
  }
}