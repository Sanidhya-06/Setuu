<<<<<<< HEAD
import 'package:flutter/material.dart';

class DataUploadScreen extends StatelessWidget {
  const DataUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
=======
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart'hide Border;
import 'package:cloud_firestore/cloud_firestore.dart';

class DataUploadScreen extends StatefulWidget {
  const DataUploadScreen({super.key});

  @override
  State<DataUploadScreen> createState() => _DataUploadScreenState();
}

class _DataUploadScreenState extends State<DataUploadScreen> {
  int? _selectedOption;
  bool _uploading = false;

  // 📂 PICK FILE + PROCESS + SAVE TO FIREBASE
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      int totalRows = 0;
      double totalIncome = 0;

      for (var table in excel.tables.keys) {
        var rows = excel.tables[table]!.rows;

        totalRows = rows.length - 1;

        for (int i = 1; i < rows.length; i++) {
          var income = rows[i].length > 3 ? rows[i][3]?.value : 0;

          if (income is num) {
            totalIncome += income;
          }
        }
      }

      double avgIncome =
          totalRows > 0 ? totalIncome / totalRows : 0;

      // 🔥 SAVE TO FIREBASE
      await FirebaseFirestore.instance.collection('uploads').add({
        'totalRows': totalRows,
        'avgIncome': avgIncome,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 🚀 NAVIGATE TO ANALYTICS SCREEN
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnalyticsScreen(
            totalRows: totalRows,
            avgIncome: avgIncome,
          ),
        ),
      );
    } else {
      print("User cancelled");
    }
  }

  void _startUpload() async {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select file type first')),
      );
      return;
    }

    setState(() => _uploading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _uploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Upload Complete')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
      appBar: AppBar(
        title: const Text('Upload Data'),
        centerTitle: true,
      ),
<<<<<<< HEAD
      body: const Center(
        child: Text(
          'Data Upload Under Work ⬆️',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
=======
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔵 Upload Box
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload, size: 40),
                    SizedBox(height: 8),
                    Text("Tap to upload",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Select File Type",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            _buildOption(0, "Excel", "Upload .xlsx/.xls"),
            _buildOption(1, "CSV", "Comma separated values"),
            _buildOption(2, "PDF", "Upload PDF report"),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _uploading ? null : _startUpload,
              child: _uploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload"),
            ),
          ],
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildOption(int index, String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: _selectedOption == index
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () => setState(() => _selectedOption = index),
      ),
    );
  }
}

// 📊 ANALYTICS SCREEN

class AnalyticsScreen extends StatelessWidget {
  final int totalRows;
  final double avgIncome;

  const AnalyticsScreen({
    super.key,
    required this.totalRows,
    required this.avgIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card("Total Records", totalRows.toString()),
            const SizedBox(height: 16),
            _card("Average Income", "₹${avgIncome.toStringAsFixed(0)}"),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
}