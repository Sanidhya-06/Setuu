<<<<<<< HEAD
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
=======
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/data_file.dart';

class DataAnalyticsScreen extends StatefulWidget {
  const DataAnalyticsScreen({super.key});

  @override
  State<DataAnalyticsScreen> createState() => _DataAnalyticsScreenState();
}

class _DataAnalyticsScreenState extends State<DataAnalyticsScreen> {
  int _selectedRange = 1; // 0=Week, 1=Month, 2=Quarter

  static const List<String> _ranges = ['Week', 'Month', 'Quarter'];

  @override
  Widget build(BuildContext context) {
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
          'Analytics',
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
                color: const Color(0xFFEEEBFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.ios_share_outlined,
                      size: 14, color: Color(0xFF6C5CE7)),
                  SizedBox(width: 4),
                  Text(
                    'Export',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Range toggle
            _RangeToggle(
              ranges: _ranges,
              selected: _selectedRange,
              onSelect: (i) => setState(() => _selectedRange = i),
            ),

            const SizedBox(height: 20),

            // Stat cards
            _StatGrid(stats: DataPageData.analyticsStats),

            const SizedBox(height: 24),

            // Bar chart
            const Text(
              'Records Processed Over Time',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 14),
            _BarChart(range: _selectedRange),

            const SizedBox(height: 24),

            // File type breakdown
            const Text(
              'File Type Breakdown',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 14),
            const _FileTypeBreakdown(),

            const SizedBox(height: 24),

            // Processing timeline
            const Text(
              'Processing Timeline',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 14),
            const _ProcessingTimeline(),
          ],
        ),
      ),
    );
  }
}

// ── Range toggle ──────────────────────────────────────────────────────────────

class _RangeToggle extends StatelessWidget {
  final List<String> ranges;
  final int selected;
  final ValueChanged<int> onSelect;

  const _RangeToggle({
    required this.ranges,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: List.generate(ranges.length, (i) {
          final isSelected = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  ranges[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF8A8A9A),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Stat grid ─────────────────────────────────────────────────────────────────

class _StatGrid extends StatelessWidget {
  final List<AnalyticsStat> stats;

  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, i) => _AnalyticsStatCard(stat: stats[i]),
    );
  }
}

class _AnalyticsStatCard extends StatelessWidget {
  final AnalyticsStat stat;

  const _AnalyticsStatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final isPositive = stat.change >= 0;
    final changeColor = isPositive
        ? const Color(0xFF00B47E)
        : const Color(0xFFFF4B4B);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            stat.label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8A8A9A),
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${isPositive ? '↑' : '↓'} ${stat.change.abs()}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: changeColor,
                    ),
                  ),
                ],
              ),
              _Sparkline(values: stat.sparkline, color: changeColor),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sparkline ─────────────────────────────────────────────────────────────────

class _Sparkline extends StatelessWidget {
  final List<double> values;
  final Color color;

  const _Sparkline({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(52, 32),
      painter: _SparklinePainter(values: values, color: color),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxV = values.reduce(math.max);
    final minV = values.reduce(math.min);
    final range = (maxV - minV) == 0 ? 1.0 : maxV - minV;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - (size.height * (values[i] - minV) / range);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Bar chart ─────────────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final int range;

  const _BarChart({required this.range});

  static const List<List<_BarData>> _datasets = [
    // Week
    [
      _BarData(label: 'Mon', value: 0.5),
      _BarData(label: 'Tue', value: 0.7),
      _BarData(label: 'Wed', value: 0.4),
      _BarData(label: 'Thu', value: 0.9),
      _BarData(label: 'Fri', value: 0.6),
      _BarData(label: 'Sat', value: 0.3),
      _BarData(label: 'Sun', value: 0.2),
    ],
    // Month
    [
      _BarData(label: 'Wk 1', value: 0.4),
      _BarData(label: 'Wk 2', value: 0.65),
      _BarData(label: 'Wk 3', value: 0.8),
      _BarData(label: 'Wk 4', value: 1.0),
    ],
    // Quarter
    [
      _BarData(label: 'Jan', value: 0.3),
      _BarData(label: 'Feb', value: 0.55),
      _BarData(label: 'Mar', value: 0.7),
      _BarData(label: 'Apr', value: 0.6),
      _BarData(label: 'May', value: 0.85),
      _BarData(label: 'Jun', value: 1.0),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final data = _datasets[range];
    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data
                  .map(
                    (d) => _Bar(data: d),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: data
                .map(
                  (d) => Text(
                    d.label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8A8A9A),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final double value; // 0.0 – 1.0

  const _BarData({required this.label, required this.value});
}

class _Bar extends StatelessWidget {
  final _BarData data;

  const _Bar({required this.data});

  @override
  Widget build(BuildContext context) {
    const maxHeight = 110.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: maxHeight * data.value,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9B87FF), Color(0xFF4A3AFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}

// ── File type breakdown ────────────────────────────────────────────────────────

class _FileTypeBreakdown extends StatelessWidget {
  const _FileTypeBreakdown();

  static const List<_TypeBreakdown> _breakdowns = [
    _TypeBreakdown(label: 'Excel (XLSX)', pct: 0.45, color: Color(0xFF00B47E)),
    _TypeBreakdown(label: 'CSV', pct: 0.35, color: Color(0xFFFF8C00)),
    _TypeBreakdown(label: 'PDF', pct: 0.20, color: Color(0xFFFF4B4B)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: _breakdowns.map((b) => _BreakdownRow(b: b)).toList(),
      ),
    );
  }
}

class _TypeBreakdown {
  final String label;
  final double pct;
  final Color color;

  const _TypeBreakdown(
      {required this.label, required this.pct, required this.color});
}

class _BreakdownRow extends StatelessWidget {
  final _TypeBreakdown b;

  const _BreakdownRow({required this.b});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: b.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    b.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              Text(
                '${(b.pct * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: b.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: b.pct,
              minHeight: 6,
              backgroundColor: const Color(0xFFF0F0F8),
              valueColor: AlwaysStoppedAnimation<Color>(b.color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Processing timeline ────────────────────────────────────────────────────────

class _ProcessingTimeline extends StatelessWidget {
  const _ProcessingTimeline();

  static const List<_TimelineEvent> _events = [
    _TimelineEvent(
      title: 'Community Survey Processed',
      subtitle: 'Generated 8 insights · 2,450 records',
      time: '2h ago',
      color: Color(0xFF00B47E),
      icon: Icons.check_circle_outline,
    ),
    _TimelineEvent(
      title: 'Water Quality Data Ingested',
      subtitle: 'Detected 2 anomalies · 1,250 records',
      time: '5h ago',
      color: Color(0xFFFF4B4B),
      icon: Icons.warning_amber_outlined,
    ),
    _TimelineEvent(
      title: 'Waste Collection Upload',
      subtitle: 'Processing complete · 1,870 records',
      time: '1d ago',
      color: Color(0xFF6C5CE7),
      icon: Icons.cloud_done_outlined,
    ),
    _TimelineEvent(
      title: 'Health Camp PDF Parsed',
      subtitle: 'Text extraction successful · 980 records',
      time: '2d ago',
      color: Color(0xFFFF8C00),
      icon: Icons.picture_as_pdf_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: List.generate(_events.length, (i) {
          return _TimelineRow(
            event: _events[i],
            isLast: i == _events.length - 1,
          );
        }),
      ),
    );
  }
}

class _TimelineEvent {
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final IconData icon;

  const _TimelineEvent({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class _TimelineRow extends StatelessWidget {
  final _TimelineEvent event;
  final bool isLast;

  const _TimelineRow({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + line
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(event.icon, color: event.color, size: 16),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE5E5EF),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      Text(
                        event.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB0B0C0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8A8A9A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
      ),
    );
  }
}