import 'package:flutter/material.dart';

class DataInsightsScreen extends StatelessWidget {
  const DataInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Insights'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Data Insights Under Work 📊',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}