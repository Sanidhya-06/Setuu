import 'package:flutter/material.dart';
<<<<<<< HEAD

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
=======
import '../models/data_file.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Static mock column/row data per file type
// ─────────────────────────────────────────────────────────────────────────────

class _MockTable {
  final List<String> columns;
  final List<List<String>> rows;

  const _MockTable({required this.columns, required this.rows});
}

const _MockTable _xlsxMock = _MockTable(
  columns: ['ID', 'Name', 'Age', 'District', 'Response'],
  rows: [
    ['001', 'Priya Sharma', '28', 'Andheri', 'Strongly Agree'],
    ['002', 'Rahul Mehta', '34', 'Borivali', 'Agree'],
    ['003', 'Sneha Patil', '22', 'Kurla', 'Neutral'],
    ['004', 'Amit Joshi', '45', 'Thane', 'Disagree'],
    ['005', 'Divya Nair', '31', 'Bandra', 'Strongly Agree'],
    ['006', 'Karan Shah', '27', 'Powai', 'Agree'],
    ['007', 'Meera Iyer', '38', 'Chembur', 'Agree'],
    ['008', 'Rohan Gupta', '29', 'Malad', 'Neutral'],
  ],
);

const _MockTable _csvMock = _MockTable(
  columns: ['Date', 'Location', 'pH', 'Turbidity', 'Status'],
  rows: [
    ['2024-04-01', 'Sector A', '7.2', '0.8 NTU', 'Safe'],
    ['2024-04-02', 'Sector B', '6.1', '2.3 NTU', 'Alert'],
    ['2024-04-03', 'Sector C', '7.4', '0.6 NTU', 'Safe'],
    ['2024-04-04', 'Sector B', '5.9', '4.1 NTU', 'Critical'],
    ['2024-04-05', 'Sector A', '7.1', '0.9 NTU', 'Safe'],
    ['2024-04-06', 'Sector D', '7.3', '1.0 NTU', 'Safe'],
    ['2024-04-07', 'Sector B', '6.5', '1.8 NTU', 'Caution'],
    ['2024-04-08', 'Sector C', '7.5', '0.7 NTU', 'Safe'],
  ],
);

const _MockTable _pdfMock = _MockTable(
  columns: ['Camp', 'Date', 'Patients', 'Doctors', 'Coverage'],
  rows: [
    ['Camp A', '2024-03-01', '240', '4', '92%'],
    ['Camp B', '2024-03-05', '185', '3', '87%'],
    ['Camp C', '2024-03-10', '310', '5', '95%'],
    ['Camp D', '2024-03-15', '220', '4', '89%'],
    ['Camp E', '2024-03-20', '275', '5', '91%'],
    ['Camp F', '2024-03-25', '190', '3', '85%'],
    ['Camp G', '2024-03-30', '250', '4', '93%'],
    ['Camp H', '2024-03-31', '130', '2', '78%'],
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────────────────────

class DataRawViewScreen extends StatelessWidget {
  final DataFile file;

  const DataRawViewScreen({super.key, required this.file});

  _MockTable get _table {
    switch (file.fileType) {
      case FileType.xlsx:
        return _xlsxMock;
      case FileType.csv:
        return _csvMock;
      case FileType.pdf:
        return _pdfMock;
    }
  }

  Color get _typeColor {
    switch (file.fileType) {
      case FileType.xlsx:
        return const Color(0xFF00B47E);
      case FileType.csv:
        return const Color(0xFFFF8C00);
      case FileType.pdf:
        return const Color(0xFFFF4B4B);
    }
  }

  String get _typeLabel {
    switch (file.fileType) {
      case FileType.xlsx:
        return 'XLSX';
      case FileType.csv:
        return 'CSV';
      case FileType.pdf:
        return 'PDF';
    }
  }

  @override
  Widget build(BuildContext context) {
    final table = _table;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        title: const Text(
          'Raw Data View',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _typeLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _typeColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // File info card
          _FileInfoCard(file: file, typeColor: _typeColor),

          const SizedBox(height: 16),

          // Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: _DataTable(table: table, typeColor: _typeColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _FileInfoCard extends StatelessWidget {
  final DataFile file;
  final Color typeColor;

  const _FileInfoCard({required this.file, required this.typeColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file_outlined,
                color: Color(0xFF6C5CE7), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${file.sizeMB} · ${file.records} records · ${file.uploadedOn}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8A8A9A),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F9F1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Processed',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00B47E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataTable extends StatelessWidget {
  final _MockTable table;
  final Color typeColor;

  const _DataTable({required this.table, required this.typeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: const Color(0xFFE5E5EF),
              width: 1,
            ),
          ),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            // Header row
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF5F3FF)),
              children: table.columns
                  .map(
                    (col) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        col,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Data rows
            ...List.generate(table.rows.length, (i) {
              final row = table.rows[i];
              return TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd
                      ? const Color(0xFFFAFAFF)
                      : Colors.white,
                ),
                children: row
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        child: Text(
                          cell,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
      ),
    );
  }
}