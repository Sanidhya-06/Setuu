import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, size: 18, color: Color(0xFF7A7A7A)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search programs or causes...',
                  style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
                ),
              ),
              Icon(Icons.tune, size: 18, color: Color(0xFF7A7A7A)),
            ],
          ),
        ),
      ),
    );
  }
}