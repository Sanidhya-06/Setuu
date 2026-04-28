import 'package:flutter/material.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Heatmap Under Work 🔥',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}