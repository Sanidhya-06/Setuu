// apps/setu_ngo/lib/features/dashboard/presentation/dashboard/widgets/dashboard_widgets.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/dashboard_models.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

const kPrimary   = Color(0xFF5B4FCF);
const kPrimaryBg = Color(0xFFEDE9FF);
const kBg        = Color(0xFFF8F7FF);
const kSurface   = Colors.white;
const kBorder    = Color(0xFFEEEEEE);
const kTextDark  = Color(0xFF1A1A2E);
const kTextGrey  = Color(0xFF9E9E9E);
const kGreen     = Color(0xFF2DB77B);
const kOrange    = Color(0xFFE8900A);
const kRed       = Color(0xFFE53935);

const _categoryColors = {
  IssueCategory.environment: Color(0xFF4CAF50),
  IssueCategory.education:   Color(0xFF5B4FCF),
  IssueCategory.health:      Color(0xFFFFB300),
  IssueCategory.community:   Color(0xFFE53935),
  IssueCategory.others:      Color(0xFF9E9E9E),
};

Color categoryColor(IssueCategory cat) =>
    _categoryColors[cat] ?? const Color(0xFF9E9E9E);

// ── Stat Card ─────────────────────────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final double changePercent;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    final up = changePercent >= 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDec(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                        fontWeight: FontWeight.w500))),
          ]),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: kTextDark)),
          const SizedBox(height: 6),
          Row(children: [
            Icon(
                up
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 12,
                color: up ? kGreen : kRed),
            const SizedBox(width: 2),
            Text('${changePercent.abs().toStringAsFixed(0)}%',
                style: TextStyle(
                    fontSize: 11,
                    color: up ? kGreen : kRed,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Text('vs last month',
                style: TextStyle(fontSize: 10, color: kTextGrey)),
          ]),
        ],
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionTitle(
      {super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: kTextDark)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!,
                  style: const TextStyle(
                      fontSize: 13,
                      color: kPrimary,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      );
}

// ── Line Chart ────────────────────────────────────────────────────────────────

class TrendLineChart extends StatelessWidget {
  final List<TrendPoint> points;
  final int totalParticipants;
  final double changePercent;

  const TrendLineChart({
    super.key,
    required this.points,
    required this.totalParticipants,
    required this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const _EmptyChart(label: 'No trend data yet');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDec(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Campaign Participation',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kTextDark)),
            _PillTag(label: 'This Month'),
          ]),
          const SizedBox(height: 4),
          const Text('Total Participants',
              style: TextStyle(fontSize: 12, color: kTextGrey)),
          const SizedBox(height: 2),
          Text(totalParticipants.toString(),
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: kTextDark)),
          const SizedBox(height: 2),
          Row(children: [
            Icon(
                changePercent >= 0
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 13,
                color: kGreen),
            Text(
                ' ${changePercent.abs().toStringAsFixed(0)}% from last month',
                style: const TextStyle(
                    fontSize: 12,
                    color: kGreen,
                    fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _LinePainter(points),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: points
                .map((p) => Text(p.label,
                    style: const TextStyle(fontSize: 10, color: kTextGrey)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<TrendPoint> points;
  _LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxY =
        points.map((p) => p.count).reduce(math.max).toDouble();
    final minY =
        points.map((p) => p.count).reduce(math.min).toDouble();
    final range = (maxY - minY) == 0 ? 1.0 : (maxY - minY);
    final dx = size.width / (points.length - 1);

    List<Offset> pts = List.generate(
        points.length,
        (i) => Offset(
              i * dx,
              size.height -
                  ((points[i].count - minY) / range) * size.height,
            ));

    final fillPath = Path()..moveTo(pts.first.dx, size.height);
    for (final p in pts) fillPath.lineTo(p.dx, p.dy);
    fillPath
      ..lineTo(pts.last.dx, size.height)
      ..close();

    canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimary.withOpacity(0.25),
              kPrimary.withOpacity(0.01)
            ],
          ).createShader(
              Rect.fromLTWH(0, 0, size.width, size.height)));

    final linePath = Path()
      ..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 =
          Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 =
          Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      linePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
        linePath,
        Paint()
          ..color = kPrimary
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);

    for (final p in pts) {
      canvas.drawCircle(p, 4, Paint()..color = kPrimary);
      canvas.drawCircle(p, 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.points != points;
}

// ── Donut Chart ───────────────────────────────────────────────────────────────

class DonutChart extends StatelessWidget {
  final List<CategorySplit> categories;

  const DonutChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty)
      return const _EmptyChart(label: 'No category data yet');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDec(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Issue Trends',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kTextDark)),
            _PillTag(label: 'This Month'),
          ]),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              width: 100, height: 100,
              child: CustomPaint(painter: _DonutPainter(categories)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categories
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(children: [
                            Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                    color: categoryColor(c.category),
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(c.category.label,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: kTextDark))),
                            Text(
                                '${c.percentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kTextDark)),
                          ]),
                        ))
                    .toList(),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<CategorySplit> categories;
  _DonutPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double startAngle = -math.pi / 2;

    for (final c in categories) {
      final sweep = (c.percentage / 100) * 2 * math.pi;
      canvas.drawArc(
          rect, startAngle, sweep, false,
          Paint()
            ..color = categoryColor(c.category)
            ..strokeWidth = 18
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.butt);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.categories != categories;
}

// ── Issue Heatmap — source-aware ──────────────────────────────────────────────
//
// Shows a unified heatmap combining:
//   • NGO / partner uploaded data  (issue_records)  — purple tones
//   • Volunteer reported issues    (reports)         — orange/red tones
//   • Both sources at same location                  — combined intensity
//
// Uses Flutter CustomPainter — no map SDK required.

class IssueHeatmap extends StatelessWidget {
  final List<HeatPoint> points;

  const IssueHeatmap({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final ngoCount = points.where((p) => p.hasNgoData).length;
    final volunteerCount = points.where((p) => p.hasVolunteerReport).length;
    final bothCount = points.where((p) => p.hasBothSources).length;

    return Container(
      decoration: _cardDec(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Source legend row ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                const Text('Impact Map',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kTextDark)),
                const Spacer(),
                _SourceBadge(
                    color: kPrimary,
                    label: 'NGO ($ngoCount)'),
                const SizedBox(width: 8),
                _SourceBadge(
                    color: kOrange,
                    label: 'Volunteers ($volunteerCount)'),
                if (bothCount > 0) ...[
                  const SizedBox(width: 8),
                  _SourceBadge(
                      color: kRed,
                      label: 'Both ($bothCount)'),
                ],
              ],
            ),
          ),

          // ── Map canvas ───────────────────────────────────────────────────
          if (points.isEmpty)
            Container(
              height: 180,
              color: const Color(0xFFE8EAF0),
              child: const Center(
                child: Text('No location data yet',
                    style: TextStyle(color: kTextGrey, fontSize: 13)),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFE8EAF0)),
                  CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _HeatmapPainter(points),
                  ),
                  // Severity gradient legend
                  Positioned(
                    bottom: 8, left: 8, right: 8,
                    child: Row(children: [
                      const Text('Low',
                          style:
                              TextStyle(fontSize: 10, color: kTextDark)),
                      Expanded(
                        child: Container(
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(colors: [
                              Color(0xFFFFEB3B),
                              Color(0xFFFF5722),
                              Color(0xFFB71C1C),
                            ]),
                          ),
                        ),
                      ),
                      const Text('High',
                          style:
                              TextStyle(fontSize: 10, color: kTextDark)),
                    ]),
                  ),
                ],
              ),
            ),

          // ── Total summary ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(children: [
              _SummaryChip(
                  icon: Icons.location_on_rounded,
                  label: '${points.length} locations'),
              const SizedBox(width: 8),
              _SummaryChip(
                  icon: Icons.bar_chart_rounded,
                  label:
                      '${points.fold(0, (s, p) => s + p.count)} total issues'),
            ]),
          ),
        ],
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<HeatPoint> points;
  _HeatmapPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final lats = points.map((p) => p.latitude).toList();
    final lngs = points.map((p) => p.longitude).toList();
    final minLat = lats.reduce(math.min);
    final maxLat = lats.reduce(math.max);
    final minLng = lngs.reduce(math.min);
    final maxLng = lngs.reduce(math.max);
    final latRange =
        (maxLat - minLat).abs() == 0 ? 1.0 : (maxLat - minLat);
    final lngRange =
        (maxLng - minLng).abs() == 0 ? 1.0 : (maxLng - minLng);
    final maxCount = points.map((p) => p.count).reduce(math.max);

    for (final point in points) {
      final x = ((point.longitude - minLng) / lngRange) *
              (size.width * 0.8) +
          size.width * 0.1;
      final y = ((maxLat - point.latitude) / latRange) *
              (size.height * 0.7) +
          size.height * 0.1;

      final radius = 12.0 + (point.count / maxCount) * 28;

      // Color depends on source
      final color = _pointColor(point);

      // Glow ring
      canvas.drawCircle(
          Offset(x, y),
          radius * 1.8,
          Paint()
            ..color = color.withOpacity(0.15)
            ..maskFilter =
                const MaskFilter.blur(BlurStyle.normal, 12));

      // Core circle
      canvas.drawCircle(
          Offset(x, y), radius, Paint()..color = color.withOpacity(0.65));

      // If both sources: draw a white ring to distinguish
      if (point.hasBothSources) {
        canvas.drawCircle(
            Offset(x, y),
            radius + 3,
            Paint()
              ..color = Colors.white.withOpacity(0.6)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
      }
    }
  }

  Color _pointColor(HeatPoint point) {
    if (point.hasBothSources) {
      return const Color(0xFFB71C1C); // deep red — highest priority
    }
    if (point.hasVolunteerReport) {
      return switch (point.severity) {
        Severity.low    => const Color(0xFFFFB74D),
        Severity.medium => const Color(0xFFFF5722),
        Severity.high   => const Color(0xFFB71C1C),
      };
    }
    // NGO data — purple tones
    return switch (point.severity) {
      Severity.low    => const Color(0xFF9575CD),
      Severity.medium => const Color(0xFF5B4FCF),
      Severity.high   => const Color(0xFF311B92),
    };
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) => old.points != points;
}

// ── Source Badge ──────────────────────────────────────────────────────────────

class _SourceBadge extends StatelessWidget {
  final Color color;
  final String label;
  const _SourceBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8, height: 8,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 10, color: kTextGrey)),
        ],
      );
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SummaryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: kPrimaryBg, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 12, color: kPrimary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: kPrimary,
                  fontWeight: FontWeight.w600)),
        ]),
      );
}

// ── Top Campaign Card ─────────────────────────────────────────────────────────

class TopCampaignCard extends StatelessWidget {
  final Campaign campaign;
  const TopCampaignCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDec(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Performing Campaign',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kTextDark)),
            const SizedBox(height: 12),
            Text(campaign.title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kTextDark)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.location_on_outlined,
                  size: 13, color: kTextGrey),
              const SizedBox(width: 2),
              Text(campaign.location,
                  style:
                      const TextStyle(fontSize: 12, color: kTextGrey)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: campaign.goalPercent,
                    minHeight: 8,
                    backgroundColor: kPrimaryBg,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(kPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${campaign.volunteerCount}/${campaign.volunteerGoal}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: kTextDark)),
            ]),
            const SizedBox(height: 4),
            Text(
                '${(campaign.goalPercent * 100).toStringAsFixed(0)}% Goal Achieved',
                style: const TextStyle(
                    fontSize: 11,
                    color: kPrimary,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

// ── Upcoming Campaign Tile ────────────────────────────────────────────────────

class CampaignTile extends StatelessWidget {
  final Campaign campaign;
  const CampaignTile({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    final date = campaign.startDate;
    final dateStr =
        '${date.day} ${_month(date.month)} ${date.year} · ${_time(date)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDec(),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
              color: kPrimaryBg,
              borderRadius: BorderRadius.circular(10)),
          child: campaign.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(campaign.imageUrl!,
                      fit: BoxFit.cover))
              : const Icon(Icons.campaign_rounded,
                  color: kPrimary, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(campaign.title,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kTextDark))),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE6F9F0),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('Upcoming',
                      style: TextStyle(
                          fontSize: 10,
                          color: kGreen,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_outlined,
                    size: 12, color: kTextGrey),
                const SizedBox(width: 2),
                Text(campaign.location,
                    style: const TextStyle(
                        fontSize: 11, color: kTextGrey)),
              ]),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: kTextGrey),
                const SizedBox(width: 2),
                Text(dateStr,
                    style: const TextStyle(
                        fontSize: 11, color: kTextGrey)),
              ]),
              const SizedBox(height: 4),
              Text(
                  '${campaign.volunteerCount}/${campaign.volunteerGoal} Volunteers',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: kTextDark)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right_rounded, color: kTextGrey),
      ]),
    );
  }

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];

  String _time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} AM';
}

// ── Recent Activity Tile ──────────────────────────────────────────────────────

class ActivityTile extends StatelessWidget {
  final RecentActivity activity;
  const ActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final icon = switch (activity.fileType) {
      'csv'   => Icons.table_chart_outlined,
      'excel' => Icons.grid_on_outlined,
      'pdf'   => Icons.picture_as_pdf_outlined,
      _       => Icons.upload_file_outlined,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
              color: kPrimaryBg,
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: kPrimary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${activity.fileName} uploaded (${activity.recordCount} records)',
            style: const TextStyle(fontSize: 12, color: kTextDark),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(activity.timeAgo,
            style: const TextStyle(fontSize: 11, color: kTextGrey)),
      ]),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

BoxDecoration _cardDec() => BoxDecoration(
      color: kSurface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2))
      ],
    );

class _PillTag extends StatelessWidget {
  final String label;
  const _PillTag({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: kTextGrey)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded,
              size: 14, color: kTextGrey),
        ]),
      );
}

class _EmptyChart extends StatelessWidget {
  final String label;
  const _EmptyChart({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        height: 180,
        decoration: _cardDec(),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bar_chart_rounded,
                color: kTextGrey, size: 36),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: kTextGrey, fontSize: 13)),
          ],
        )),
      );
}