import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../styles/app_theme.dart';
import '../models/report.dart';
import '../providers/reports_provider.dart';

class RecentReportsWidget extends StatefulWidget {
  const RecentReportsWidget({super.key});

  @override
  State<RecentReportsWidget> createState() => _RecentReportsWidgetState();
}

class _RecentReportsWidgetState extends State<RecentReportsWidget> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppTheme.animationDuration,
      vsync: this,
    );
    
    _itemControllers = [];
    _itemAnimations = [];
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeItemAnimations(int itemCount) {
    // Dispose existing controllers
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    
    _itemControllers.clear();
    _itemAnimations.clear();
    
    for (int i = 0; i < itemCount; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 300 + (i * 100)),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
      
      _itemControllers.add(controller);
      _itemAnimations.add(animation);
    }
  }

  void _animateItems() async {
    for (int i = 0; i < _itemControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 100));
      if (mounted) {
        _itemControllers[i].forward();
      }
    }
  }

  Widget _buildReportContent(Report report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getCategoryColor(report.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(report.category),
                color: _getCategoryColor(report.category),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          report.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.neutral800,
                          ),
                        ),
                      ),
                      _buildStatusChip(report.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (report.description != null)
                    Text(
                      report.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.neutral600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: AppTheme.neutral500,
            ),
            const SizedBox(width: 6),
            Text(
              _formatDate(report.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.neutral500,
              ),
            ),
            const SizedBox(width: 16),
            if (report.location != null) ...[
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppTheme.neutral500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  report.location!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (report.hasAttachments) ...[
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attachment_rounded,
                      size: 12,
                      color: AppTheme.infoColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Media',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.infoColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildReportCard(Report report, int index) {
    return AnimatedBuilder(
      animation: _itemAnimations[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _itemAnimations[index].value)),
          child: Opacity(
            opacity: _itemAnimations[index].value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _showReportDetails(report);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildReportContent(report),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case ReportStatus.sent:
        color = AppTheme.infoColor;
        text = 'Sent';
        break;
      case ReportStatus.received:
        color = AppTheme.warningColor;
        text = 'In Progress';
        break;
      case ReportStatus.resolved:
        color = AppTheme.successColor;
        text = 'Resolved';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateFormat('dd/MM/yyyy').parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return DateFormat('MMM dd').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'power outage':
        return Icons.flash_off_rounded;
      case 'water leakage':
        return Icons.water_drop_rounded;
      case 'road damage':
        return Icons.construction_rounded;
      case 'streetlight issue':
        return Icons.lightbulb_outline_rounded;
      case 'sewer clogging':
        return Icons.water_damage_rounded;
      case 'waste management':
        return Icons.delete_outline_rounded;
      default:
        return Icons.report_problem_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'power outage':
        return AppTheme.warningColor;
      case 'water leakage':
        return AppTheme.infoColor;
      case 'road damage':
        return AppTheme.errorColor;
      case 'streetlight issue':
        return AppTheme.warningColor;
      case 'sewer clogging':
        return AppTheme.primaryColor;
      case 'waste management':
        return AppTheme.successColor;
      default:
        return AppTheme.neutral600;
    }
  }

  void _showReportDetails(Report report) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(report.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(report.category),
                      color: _getCategoryColor(report.category),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          report.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutral600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(report.status),
                ],
              ),
              if (report.description != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 16, color: AppTheme.neutral500),
                  const SizedBox(width: 6),
                  Text(
                    'Reported on ${report.date}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutral500,
                    ),
                  ),
                ],
              ),
              if (report.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 16, color: AppTheme.neutral500),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        report.location!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report details copied to clipboard'),
                          backgroundColor: AppTheme.infoColor,
                        ),
                      );
                    },
                    child: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsProvider>(
      builder: (context, reportsProvider, child) {
        final reports = reportsProvider.recentReports;
        final isLoading = reportsProvider.isLoading;
        
        // Initialize animations when reports change
        if (reports.isNotEmpty && _itemControllers.length != reports.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeItemAnimations(reports.length);
            _animateItems();
          });
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recent Reports',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutral800,
                  ),
                ),
                const Spacer(),
                if (!isLoading)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reports');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.neutral300.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              )
            else if (reports.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.neutral200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 48,
                      color: AppTheme.neutral500,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reports yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.neutral600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start by reporting your first civic issue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.neutral500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: reports
                    .asMap()
                    .entries
                    .map((entry) {
                      if (entry.key < _itemAnimations.length) {
                        return _buildReportCard(entry.value, entry.key);
                      } else {
                        // Fallback for new reports without animation
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.black.withOpacity(0.1),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _showReportDetails(entry.value),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: _buildReportContent(entry.value),
                              ),
                            ),
                          ),
                        );
                      }
                    })
                    .toList(),
              ),
          ],
        );
      },
    );
  }
}
