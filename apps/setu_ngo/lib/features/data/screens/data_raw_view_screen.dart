import 'package:flutter/material.dart';

class DataRawViewScreen extends StatelessWidget {
  const DataRawViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raw Data View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Raw Data View Under Work 📊',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}