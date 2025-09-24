import '../models/report.dart';

class MockData {
  static final List<Report> mockReports = [
    const Report(
      id: 1,
      title: 'No light since 3 days',
      category: 'Streetlight Issue',
      date: '2 days ago',
      status: ReportStatus.resolved,
      description:
          'Street light has been out for multiple days causing safety concerns for pedestrians and vehicles.',
      location: 'Main Street, Block A',
      hasAttachments: true,
    ),
    const Report(
      id: 2,
      title: 'Sewer clogging near main park',
      category: 'Sewer Clogging',
      date: '5 days ago',
      status: ReportStatus.received,
      description:
          'Severe sewer blockage causing water overflow and unpleasant odors in the residential area.',
      location: 'Central Park Area',
      hasAttachments: true,
    ),
    const Report(
      id: 3,
      title: 'Major pothole on 5th Avenue',
      category: 'Road Damage',
      date: '1 week ago',
      status: ReportStatus.resolved,
      description:
          'Large pothole causing damage to vehicles and creating safety hazards for commuters.',
      location: '5th Avenue, Near Shopping Complex',
      hasAttachments: false,
    ),
    const Report(
      id: 4,
      title: 'Street lamp not working',
      category: 'Streetlight Issue',
      date: '3 days ago',
      status: ReportStatus.sent,
      description:
          'Broken street lamp near residential area making it unsafe for evening walks.',
      location: 'Residential Block B',
      hasAttachments: false,
    ),
    const Report(
      id: 5,
      title: 'Water leakage from main pipe',
      category: 'Water Leakage',
      date: '1 day ago',
      status: ReportStatus.received,
      description:
          'Major water leakage from underground pipe causing water wastage and street flooding.',
      location: 'Industrial Area, Sector 12',
      hasAttachments: true,
    ),
    const Report(
      id: 6,
      title: 'Garbage not collected for weeks',
      category: 'Waste Management',
      date: '4 days ago',
      status: ReportStatus.sent,
      description:
          'Municipal garbage collection has been irregular, causing accumulation of waste.',
      location: 'Residential Complex, Building C',
      hasAttachments: true,
    ),
  ];
}
