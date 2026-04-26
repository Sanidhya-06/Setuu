import 'package:flutter/material.dart';
import '../widgets/upload_box.dart';

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  String? _fileName;
  bool _uploading = false;
  bool _done = false;

  // ─── Mock picker (swap for FilePicker.platform.pickFiles() in prod) ──
  Future<void> _pick() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      _fileName = 'community_survey_data.pdf';
      _done = false;
    });
  }

  void _remove() => setState(() {
        _fileName = null;
        _done = false;
      });

  Future<void> _upload() async {
    if (_fileName == null) return;
    setState(() => _uploading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _uploading = false;
      _done = true;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('File uploaded successfully!'),
        backgroundColor: const Color(0xFF5B4CFF),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F3FF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 17, color: Color(0xFF1A1A2E)),
          ),
        ),
        title: const Text(
          'Upload Files',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IntroCard(),
            const SizedBox(height: 18),
            UploadBox(
              fileName: _fileName,
              onTap: _pick,
              onRemove: _remove,
            ),
            const SizedBox(height: 18),
            if (_fileName != null) ...[
              _FileInfoCard(
                  fileName: _fileName!, done: _done),
              const SizedBox(height: 14),
              _UploadButton(
                loading: _uploading,
                done: _done,
                onPressed: _upload,
              ),
              const SizedBox(height: 18),
            ],
            _FormatsCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF5B4CFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.cloud_upload_outlined,
                color: Color(0xFF5B4CFF), size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Supporting Files',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Attach documents, images or reports to your form data.',
                  style: TextStyle(fontSize: 12.5, color: Colors.grey),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FileInfoCard extends StatelessWidget {
  final String fileName;
  final bool done;
  const _FileInfoCard({required this.fileName, required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFF5B4CFF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selected File',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 10),
          _Row(label: 'Name', value: fileName),
          _Row(
            label: 'Status',
            value: done ? '✓ Uploaded' : 'Ready to upload',
            valueColor: done ? Colors.green.shade600 : null,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Row({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF1A1A2E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final bool loading;
  final bool done;
  final VoidCallback onPressed;
  const _UploadButton(
      {required this.loading, required this.done, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (loading || done) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              done ? Colors.green.shade600 : const Color(0xFF5B4CFF),
          disabledBackgroundColor:
              done ? Colors.green.shade600 : Colors.grey.shade300,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                done ? '✓  Uploaded' : 'Upload File',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _FormatsCard extends StatelessWidget {
  static const _formats = [
    (Icons.picture_as_pdf_outlined, 'PDF', 'Up to 10 MB'),
    (Icons.image_outlined, 'JPG / PNG', 'Up to 5 MB'),
    (Icons.description_outlined, 'DOCX', 'Up to 8 MB'),
    (Icons.table_chart_outlined, 'XLSX', 'Up to 8 MB'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Supported Formats',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _formats.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(f.$1, size: 18, color: const Color(0xFF5B4CFF)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.$2,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E))),
                        Text(f.$3,
                            style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}