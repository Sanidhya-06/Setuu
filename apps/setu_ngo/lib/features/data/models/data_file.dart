import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Enums
// ─────────────────────────────────────────────

enum FileType { xlsx, csv, pdf }

enum ProcessingStatus { processed, processing, failed }

// ─────────────────────────────────────────────
//  DataFile
// ─────────────────────────────────────────────

class DataFile {
  final String id;
  final String name;
  final FileType fileType;
  final String uploadedOn;
  final String sizeMB;
  final int records;
  final ProcessingStatus status;
  final double? processingProgress;

  const DataFile({
    required this.id,
    required this.name,
    required this.fileType,
    required this.uploadedOn,
    required this.sizeMB,
    required this.records,
    required this.status,
    this.processingProgress,
  });
}

// ─────────────────────────────────────────────
//  OverviewStat
// ─────────────────────────────────────────────

class OverviewStat {
  final String label;
  final String value;
  final String changeText;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const OverviewStat({
    required this.label,
    required this.value,
    required this.changeText,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}

// ─────────────────────────────────────────────
//  InsightItem
// ─────────────────────────────────────────────

class InsightItem {
  final String title;
  final String description;
  final String tag;
  final Color tagColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String date;

  const InsightItem({
    required this.title,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.date,
  });
}

// ─────────────────────────────────────────────
//  AnalyticsStat
// ─────────────────────────────────────────────

class AnalyticsStat {
  final String label;
  final String value;
  final double change;
  final List<double> sparkline;

  const AnalyticsStat({
    required this.label,
    required this.value,
    required this.change,
    required this.sparkline,
  });
}

// ─────────────────────────────────────────────
//  NavBarItem
// ─────────────────────────────────────────────

class NavBarItem {
  final IconData icon;
  final String label;

  const NavBarItem({required this.icon, required this.label});
}

// ─────────────────────────────────────────────
//  Static data store
// ─────────────────────────────────────────────

class DataPageData {
  DataPageData._();

  static const List<DataFile> files = [
    DataFile(
      id: 'f1',
      name: 'Community_Survey_May2024.xlsx',
      fileType: FileType.xlsx,
      uploadedOn: '25 May 2024',
      sizeMB: '8.4 MB',
      records: 2450,
      status: ProcessingStatus.processed,
    ),
    DataFile(
      id: 'f2',
      name: 'Water_Quality_Report_April.csv',
      fileType: FileType.csv,
      uploadedOn: '20 May 2024',
      sizeMB: '2.1 MB',
      records: 1250,
      status: ProcessingStatus.processed,
    ),
    DataFile(
      id: 'f3',
      name: 'Health_Camp_Summary_March.pdf',
      fileType: FileType.pdf,
      uploadedOn: '15 May 2024',
      sizeMB: '1.8 MB',
      records: 980,
      status: ProcessingStatus.processed,
    ),
    DataFile(
      id: 'f4',
      name: 'Waste_Collection_Data_May.xlsx',
      fileType: FileType.xlsx,
      uploadedOn: '10 May 2024',
      sizeMB: '3.2 MB',
      records: 1870,
      status: ProcessingStatus.processed,
    ),
    DataFile(
      id: 'f5',
      name: 'Volunteer_Engagement_April.csv',
      fileType: FileType.csv,
      uploadedOn: '5 May 2024',
      sizeMB: '1.6 MB',
      records: 1100,
      status: ProcessingStatus.processing,
      processingProgress: 0.65,
    ),
  ];

  static const List<OverviewStat> stats = [
    OverviewStat(
      label: 'Datasets\nUploaded',
      value: '8',
      changeText: '↑ 2 vs last month',
      icon: Icons.insert_drive_file_outlined,
      iconBgColor: Color(0xFFEEEBFF),
      iconColor: Color(0xFF6C5CE7),
    ),
    OverviewStat(
      label: 'Total Records\nProcessed',
      value: '12,450',
      changeText: '↑ 18% vs last month',
      icon: Icons.check_circle_outline,
      iconBgColor: Color(0xFFE6F9F1),
      iconColor: Color(0xFF00B47E),
    ),
    OverviewStat(
      label: 'Insights\nGenerated',
      value: '24',
      changeText: '↑ 20% vs last month',
      icon: Icons.bar_chart,
      iconBgColor: Color(0xFFFFF3E6),
      iconColor: Color(0xFFFF8C00),
    ),
    OverviewStat(
      label: 'Reports\nExported',
      value: '5',
      changeText: '↑ 14% vs last month',
      icon: Icons.picture_as_pdf_outlined,
      iconBgColor: Color(0xFFFFEBEB),
      iconColor: Color(0xFFFF4B4B),
    ),
  ];

  static const List<String> tabs = [
    'Uploaded Data',
    'Processed Data',
    'Insights',
    'Reports',
  ];

  static const List<InsightItem> insights = [
    InsightItem(
      title: 'Community Engagement Peak',
      description:
          'Survey responses peaked on weekends with 68% participation rate above baseline.',
      tag: 'Trend',
      tagColor: Color(0xFF6C5CE7),
      icon: Icons.people_outline,
      iconColor: Color(0xFF6C5CE7),
      iconBg: Color(0xFFEEEBFF),
      date: '25 May 2024',
    ),
    InsightItem(
      title: 'Water Quality Anomaly',
      description:
          'pH levels in sector B dropped below safe thresholds on 3 consecutive days.',
      tag: 'Alert',
      tagColor: Color(0xFFFF4B4B),
      icon: Icons.water_drop_outlined,
      iconColor: Color(0xFF00B47E),
      iconBg: Color(0xFFE6F9F1),
      date: '20 May 2024',
    ),
    InsightItem(
      title: 'Volunteer Efficiency Up',
      description:
          'Average tasks per volunteer increased by 22% compared to the previous quarter.',
      tag: 'Positive',
      tagColor: Color(0xFF00B47E),
      icon: Icons.volunteer_activism_outlined,
      iconColor: Color(0xFFFF8C00),
      iconBg: Color(0xFFFFF3E6),
      date: '15 May 2024',
    ),
    InsightItem(
      title: 'Waste Collection Optimised',
      description:
          'Route optimisation reduced fuel usage by 15% while covering 8% more area.',
      tag: 'Efficiency',
      tagColor: Color(0xFFFF8C00),
      icon: Icons.delete_outline,
      iconColor: Color(0xFFFF4B4B),
      iconBg: Color(0xFFFFEBEB),
      date: '10 May 2024',
    ),
  ];

  static const List<AnalyticsStat> analyticsStats = [
    AnalyticsStat(
      label: 'Data Uploaded',
      value: '17.4 MB',
      change: 12.4,
      sparkline: [2.0, 3.5, 2.8, 4.2, 5.0, 4.6, 6.1],
    ),
    AnalyticsStat(
      label: 'Records Processed',
      value: '7,650',
      change: 18.2,
      sparkline: [1.5, 2.0, 3.8, 3.2, 5.5, 4.8, 7.0],
    ),
    AnalyticsStat(
      label: 'Avg Processing Time',
      value: '4.2 min',
      change: -8.3,
      sparkline: [6.0, 5.5, 5.2, 4.8, 4.5, 4.3, 4.2],
    ),
    AnalyticsStat(
      label: 'Error Rate',
      value: '0.8%',
      change: -22.0,
      sparkline: [3.0, 2.5, 2.0, 1.8, 1.2, 1.0, 0.8],
    ),
  ];

  static const List<NavBarItem> navItems = [
    NavBarItem(icon: Icons.home_outlined, label: 'Dashboard'),
    NavBarItem(icon: Icons.campaign_outlined, label: 'Campaigns'),
    NavBarItem(icon: Icons.cloud_upload_outlined, label: 'Data'),
    NavBarItem(icon: Icons.assignment_outlined, label: 'Forms'),
    NavBarItem(icon: Icons.person_outline, label: 'Profile'),
  ];
}