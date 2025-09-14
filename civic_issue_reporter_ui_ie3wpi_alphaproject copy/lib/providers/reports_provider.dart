import 'package:flutter/material.dart';
import '../models/report.dart';
import '../utils/mock_data.dart';

class ReportsProvider extends ChangeNotifier {
  List<Report> _reports = [];
  bool _isLoading = false;
  
  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  
  List<Report> get recentReports => _reports.take(5).toList();
  
  ReportsProvider() {
    loadReports();
  }
  
  Future<void> loadReports() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _reports = List.from(MockData.mockReports);
    _isLoading = false;
    notifyListeners();
  }
  
  void addReport(Report report) {
    _reports.insert(0, report); // Add to the beginning of the list
    notifyListeners();
  }
  
  void updateReport(int id, Report updatedReport) {
    final index = _reports.indexWhere((report) => report.id == id);
    if (index != -1) {
      _reports[index] = updatedReport;
      notifyListeners();
    }
  }
  
  void removeReport(int id) {
    _reports.removeWhere((report) => report.id == id);
    notifyListeners();
  }
  
  Report? getReportById(int id) {
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Report> getReportsByStatus(ReportStatus status) {
    return _reports.where((report) => report.status == status).toList();
  }
  
  List<Report> getReportsByCategory(String category) {
    return _reports.where((report) => report.category == category).toList();
  }
  
  Future<void> submitNewReport({
    required String title,
    required String category,
    required String description,
    String? location,
    bool hasAttachments = false,
  }) async {
    // Generate new ID
    final newId = _reports.isEmpty ? 1 : _reports.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;
    
    // Create new report
    final newReport = Report(
      id: newId,
      title: title,
      category: category,
      date: DateTime.now().toLocal().toString().split(' ')[0].split('-').reversed.join('/'),
      status: ReportStatus.sent,
      description: description,
      location: location,
      hasAttachments: hasAttachments,
    );
    
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    addReport(newReport);
  }
}