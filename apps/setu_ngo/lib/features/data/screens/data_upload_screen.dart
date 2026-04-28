import 'package:flutter/material.dart';

class DataUploadScreen extends StatelessWidget {
  const DataUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Data'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Data Upload Under Work ⬆️',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}