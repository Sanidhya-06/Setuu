// lib/services/file_service.dart
// Picks .xlsx or .csv, reads bytes in memory only. Nothing is uploaded.

import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class PickedFileResult {
  final String fileName;
  final List<Map<String, dynamic>> rows;
  const PickedFileResult({required this.fileName, required this.rows});
}

class FileService {
  FileService._();
  static final FileService instance = FileService._();

  Future<PickedFileResult?> pickAndParse() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Could not read file bytes. Please try again.');
    }

    final name = file.name.toLowerCase();
    List<Map<String, dynamic>> rows;

    if (name.endsWith('.xlsx')) {
      rows = await compute(_parseExcel, bytes);
    } else if (name.endsWith('.csv')) {
      rows = await compute(_parseCsv, utf8.decode(bytes));
    } else {
      throw Exception('Unsupported file type: ${file.name}');
    }

    return PickedFileResult(fileName: file.name, rows: rows);
  }

  static List<Map<String, dynamic>> _parseExcel(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    Sheet? sheet;
    for (final s in excel.sheets.values) {
      if (s.rows.isNotEmpty) {
        sheet = s;
        break;
      }
    }
    if (sheet == null || sheet.rows.length < 2) return [];

    final headers = sheet.rows.first
        .map((c) => c?.value?.toString().trim().toLowerCase() ?? '')
        .toList();

    final result = <Map<String, dynamic>>[];
    for (int i = 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      final map = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < row.length; j++) {
        if (headers[j].isNotEmpty) {
          map[headers[j]] = row[j]?.value?.toString().trim() ?? '';
        }
      }
      if (_valid(map)) result.add(map);
    }
    return result;
  }

  static List<Map<String, dynamic>> _parseCsv(String content) {
    final table = const CsvToListConverter(eol: '\n').convert(content);
    if (table.length < 2) return [];

    final headers = table.first
        .map((h) => h.toString().trim().toLowerCase())
        .toList();

    final result = <Map<String, dynamic>>[];
    for (int i = 1; i < table.length; i++) {
      final row = table[i];
      final map = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < row.length; j++) {
        if (headers[j].isNotEmpty) {
          map[headers[j]] = row[j]?.toString().trim() ?? '';
        }
      }
      if (_valid(map)) result.add(map);
    }
    return result;
  }

  static bool _valid(Map<String, dynamic> row) {
    const keys = {'category', 'date', 'location'};
    return row.keys.any(keys.contains);
  }
}