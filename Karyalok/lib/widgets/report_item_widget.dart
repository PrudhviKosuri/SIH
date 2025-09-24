import 'package:flutter/material.dart';
import '../models/report.dart';
import '../styles/app_theme.dart';
import 'status_bar_widget.dart';

class ReportItemWidget extends StatelessWidget {
  final Report report;
  final bool detailed;

  const ReportItemWidget({
    super.key,
    required this.report,
    this.detailed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (detailed) {
      return _buildDetailedItem();
    }
    return _buildCompactItem();
  }

  Widget _buildDetailedItem() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(report.category),
                    color: AppTheme.primaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              report.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.neutral800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                report.status,
                              ).withValues(alpha: 0.1),
                              border: Border.all(
                                color: _getStatusColor(
                                  report.status,
                                ).withValues(alpha: 0.2),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              report.status.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(report.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (report.description != null)
                        Text(
                          report.description!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.neutral600,
                            height: 1.4,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppTheme.neutral500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            report.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.neutral500,
                            ),
                          ),
                          if (report.location != null) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: AppTheme.neutral500,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                report.location!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.neutral500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          if (report.hasAttachments) ...[
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.attach_file,
                              size: 12,
                              color: AppTheme.neutral500,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Photos',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.neutral500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (report.hasAttachments) ...[
              const Divider(height: 24),
              const Text(
                'Attached Photos:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutral700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.neutral300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Photo 1',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.neutral500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.neutral300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Photo 2',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.neutral500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            StatusBarWidget(currentStatus: report.status),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactItem() {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(report.category),
                    color: AppTheme.primaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              report.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.neutral800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (report.hasAttachments)
                            const Icon(
                              Icons.attach_file,
                              size: 12,
                              color: AppTheme.neutral500,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppTheme.neutral500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            report.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StatusBarWidget(currentStatus: report.status, compact: true),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Power Outage':
        return Icons.flash_on;
      case 'Water Leakage':
        return Icons.water_drop;
      case 'Road Damage':
        return Icons.build;
      case 'Streetlight Issue':
        return Icons.lightbulb_outline;
      case 'Sewer Clogging':
        return Icons.water_drop;
      case 'Waste Management':
        return Icons.build;
      default:
        return Icons.flash_on;
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.sent:
        return AppTheme.primaryColor;
      case ReportStatus.received:
        return AppTheme.warningColor;
      case ReportStatus.resolved:
        return AppTheme.successColor;
    }
  }
}
