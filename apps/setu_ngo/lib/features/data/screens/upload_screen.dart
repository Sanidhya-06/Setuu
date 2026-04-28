// lib/screens/upload_screen.dart

import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../services/processing_service.dart';
import '../services/firestore_service.dart';
import '../models/insight_model.dart';
import '../widgets/frequency_bar_widget.dart';
import '../widgets/insight_summary_card.dart';

enum _S { idle, picking, processing, saving, done, error }

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  _S _state = _S.idle;
  String? _fileName;
  String? _error;
  InsightModel? _preview;
  List<Map<String, dynamic>> _rows = [];

  Future<void> _pick() async {
    setState(() {
      _state = _S.picking;
      _error = null;
      _preview = null;
      _fileName = null;
      _rows = [];
    });
    try {
      final r = await FileService.instance.pickAndParse();
      if (r == null) {
        setState(() => _state = _S.idle);
        return;
      }
      setState(() {
        _fileName = r.fileName;
        _rows = r.rows;
        _state = _S.idle;
      });
    } catch (e) {
      setState(() {
        _state = _S.error;
        _error = e.toString();
      });
    }
  }

  Future<void> _process() async {
    if (_rows.isEmpty) {
      setState(() {
        _state = _S.error;
        _error = 'No valid rows found. Ensure columns: category, date, location.';
      });
      return;
    }

    setState(() => _state = _S.processing);
    await Future<void>.delayed(const Duration(milliseconds: 80));

    InsightModel insight;
    try {
      insight = ProcessingService.instance.generateInsights(_rows);
    } catch (e) {
      setState(() {
        _state = _S.error;
        _error = 'Processing error: $e';
      });
      return;
    }

    setState(() => _state = _S.saving);
    try {
      await FirestoreService.instance.saveInsight(insight);
    } catch (e) {
      setState(() {
        _state = _S.error;
        _error = 'Firestore error: $e';
      });
      return;
    }

    setState(() {
      _state = _S.done;
      _preview = insight;
    });
  }

  void _reset() {
    setState(() {
      _state = _S.idle;
      _fileName = null;
      _error = null;
      _preview = null;
      _rows = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final canProcess = _state == _S.idle && _fileName != null;
    final busy = _state == _S.processing ||
        _state == _S.saving ||
        _state == _S.picking;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FF),
        elevation: 0,
        title: const Text(
          'Upload & Process',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        actions: [
          if (_state == _S.done || _state == _S.error)
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF6C5CE7)),
              onPressed: _reset,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Pick file card ──────────────────────────────
            GestureDetector(
              onTap: (!busy && (_state == _S.idle || _state == _S.error))
                  ? _pick
                  : null,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: _fileName != null
                      ? const Color(0xFFEEEBFF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _fileName != null
                        ? const Color(0xFF6C5CE7)
                        : const Color(0xFFE5E5EF),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _fileName != null
                          ? Icons.check_circle_outline
                          : Icons.upload_file_outlined,
                      size: 36,
                      color: _fileName != null
                          ? const Color(0xFF6C5CE7)
                          : const Color(0xFFB0B0C0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _fileName ?? 'Tap to pick a file',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _fileName != null
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _fileName != null
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFF8A8A9A),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_fileName == null) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Supports .xlsx and .csv',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFFB0B0C0)),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Process button ──────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: canProcess ? _process : null,
                icon: const Icon(Icons.analytics_outlined),
                label: const Text(
                  'Process & Save to Firestore',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF6C5CE7).withOpacity(0.35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),

            // ── Loading ─────────────────────────────────────
            if (busy) ...[
              const SizedBox(height: 28),
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6C5CE7)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  _state == _S.picking
                      ? 'Reading file…'
                      : _state == _S.processing
                          ? 'Generating insights…'
                          : 'Saving to Firestore…',
                  style: const TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            // ── Error ───────────────────────────────────────
            if (_state == _S.error && _error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFFF4B4B).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFFF4B4B), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                            color: Color(0xFFCC0000), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Success preview ─────────────────────────────
            if (_state == _S.done && _preview != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F9F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF00B47E).withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Color(0xFF00B47E), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Saved! View full list in the Insights tab.',
                        style: TextStyle(
                          color: Color(0xFF007A55),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InsightSummaryCard(insight: _preview!),
              FrequencyBarWidget(
                title: 'Categories',
                data: _preview!.categories,
                barColor: const Color(0xFF6C5CE7),
              ),
              FrequencyBarWidget(
                title: 'Trends (by Date)',
                data: _preview!.trends,
                barColor: const Color(0xFF00B47E),
              ),
              FrequencyBarWidget(
                title: 'Locations',
                data: _preview!.locations,
                barColor: const Color(0xFFFF8C00),
              ),
            ],
          ],
        ),
      ),
    );
  }
}