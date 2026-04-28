import 'package:flutter/material.dart';

class DataAnalyticsScreen extends StatelessWidget {
  const DataAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Analytics'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Data Analytics Under Work 📊',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}