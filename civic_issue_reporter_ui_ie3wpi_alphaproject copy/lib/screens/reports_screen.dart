import 'package:flutter/material.dart';
import '../models/report.dart';
import '../utils/mock_data.dart';
import '../widgets/report_item_widget.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/report_form_widget.dart';
import '../styles/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _currentIndex = 1;
  String _selectedStatus = 'all';
  String _searchTerm = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Report> get _filteredReports {
    return MockData.mockReports.where((report) {
      final matchesStatus =
          _selectedStatus == 'all' || report.status.name == _selectedStatus;
      final matchesSearch =
          report.title.toLowerCase().contains(_searchTerm.toLowerCase()) ||
              report.category.toLowerCase().contains(_searchTerm.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Map<String, int> get _statusCounts {
    return {
      'all': MockData.mockReports.length,
      'sent': MockData.mockReports
          .where((r) => r.status == ReportStatus.sent)
          .length,
      'received': MockData.mockReports
          .where((r) => r.status == ReportStatus.received)
          .length,
      'resolved': MockData.mockReports
          .where((r) => r.status == ReportStatus.resolved)
          .length,
    };
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        // Already on reports
        break;
      case 2:
        // Add new report
        _showAddReportDialog();
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _showAddReportDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppTheme.neutral200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Report New Issue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ReportFormWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral200,
      body: Column(
        children: [
          // Header with search and filters
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.primaryDark, AppTheme.primaryColor],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'MY REPORTS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutral100,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchTerm = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search reports...',
                        hintStyle: const TextStyle(color: AppTheme.neutral300),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppTheme.neutral400,
                          size: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(color: AppTheme.neutral100),
                    ),

                    const SizedBox(height: 12),

                    // Status Filter
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _statusCounts.length,
                        itemBuilder: (context, index) {
                          final status = _statusCounts.keys.elementAt(index);
                          final count = _statusCounts[status]!;
                          final isSelected = _selectedStatus == status;

                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedStatus = status;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.neutral100
                                      : Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${status.toUpperCase()} ($count)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.neutral100,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Reports List
          Expanded(
            child: _filteredReports.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 40,
                          color: AppTheme.neutral400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No reports found matching your criteria.',
                          style: TextStyle(
                            color: AppTheme.neutral600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      return ReportItemWidget(
                        report: _filteredReports[index],
                        detailed: true,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
