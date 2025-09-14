import 'package:flutter/material.dart';
import '../utils/mock_data.dart';
import 'report_item_widget.dart';

class RecentReportsWidget extends StatelessWidget {
  const RecentReportsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recentReports = MockData.mockReports.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT REPORTS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5A5A5A),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...recentReports.map(
          (report) => ReportItemWidget(report: report, detailed: false),
        ),
      ],
    );
  }
}
