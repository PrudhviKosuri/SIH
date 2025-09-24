enum ReportStatus { sent, received, resolved }

class Report {
  final int id;
  final String title;
  final String category;
  final String date;
  final ReportStatus status;
  final String? description;
  final String? location;
  final bool hasAttachments;

  const Report({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.status,
    this.description,
    this.location,
    this.hasAttachments = false,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      date: json['date'],
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.sent,
      ),
      description: json['description'],
      location: json['location'],
      hasAttachments: json['hasAttachments'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'status': status.name,
      'description': description,
      'location': location,
      'hasAttachments': hasAttachments,
    };
  }
}
