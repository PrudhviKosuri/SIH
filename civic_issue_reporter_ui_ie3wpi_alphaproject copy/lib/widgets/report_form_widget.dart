import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../styles/app_theme.dart';
import '../services/location_service.dart';

class ReportFormWidget extends StatefulWidget {
  const ReportFormWidget({super.key});

  @override
  State<ReportFormWidget> createState() => _ReportFormWidgetState();
}

class _ReportFormWidgetState extends State<ReportFormWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedCategory = '';
  List<File> _selectedImages = [];
  final LocationService _locationService = LocationService();
  bool _isGettingLocation = false;
  Map<String, dynamic>? _locationData;

  final List<String> _categories = [
    'Streetlight Issue',
    'Road Damage',
    'Water Leakage',
    'Sewer Clogging',
    'Power Outage',
    'Waste Management',
    'Others',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REPORT YOUR ISSUE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutral600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Category Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutral700,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
                  decoration: const InputDecoration(
                    hintText: 'Select category...',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? '';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Location Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutral700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter location...',
                          prefixIcon: Icon(Icons.location_on, size: 16),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isGettingLocation ? null : _getCurrentLocation,
                      icon: _isGettingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.my_location),
                      tooltip: 'Get current location',
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.primaryLight.withValues(
                          alpha: 0.3,
                        ),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutral700,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe the issue in detail...',
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Image Upload
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Photos',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutral700,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryLight.withValues(alpha: 0.2),
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.upload,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          children: [
                            Text(
                              'Upload Photos',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'JPG, PNG up to 10MB',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Image Preview
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.neutral300),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle camera
                        },
                        icon: const Icon(Icons.camera_alt),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryLight.withValues(
                            alpha: 0.3,
                          ),
                          shape: const CircleBorder(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          // Handle file attachment
                        },
                        icon: const Icon(Icons.attach_file),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryLight.withValues(
                            alpha: 0.3,
                          ),
                          shape: const CircleBorder(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          // Handle voice note
                        },
                        icon: const Icon(Icons.mic),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryLight.withValues(
                            alpha: 0.3,
                          ),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _canSubmit() ? _submitReport : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.neutral100,
                    disabledBackgroundColor: AppTheme.neutral400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _descriptionController.text.trim().isNotEmpty &&
        _selectedCategory.isNotEmpty;
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      _locationData = await _locationService.getLocationDataForBackend();
      
      if (_locationData != null) {
        setState(() {
          _locationController.text = _locationData!['address'] ?? 
              'Lat: ${_locationData!['latitude']?.toStringAsFixed(6)}, '
              'Lng: ${_locationData!['longitude']?.toStringAsFixed(6)}';
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location retrieved successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to get current location. Please enter manually.'),
              backgroundColor: AppTheme.warningColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error getting location. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  Future<void> _submitReport() async {
    if (_canSubmit()) {
      // Prepare report data for backend
      final reportData = {
        'category': _selectedCategory,
        'description': _descriptionController.text.trim(),
        'location_text': _locationController.text.trim(),
        'location_data': _locationData,
        'images_count': _selectedImages.length,
        'timestamp': DateTime.now().toIso8601String(),
        // Add more fields as needed
      };

      // TODO: Send report data to backend API
      // Example:
      // await _submitReportToBackend(reportData);
      
      // For now, just log the data
      if (mounted) {
        print('Report data ready for backend: $reportData');
        
        // Send location data to backend if available
        if (_locationData != null) {
          await _locationService.sendLocationToBackend(_locationData!);
        }
      }
      
      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text(
              'Report submitted successfully! You can track its progress in the Reports section.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _clearForm() {
    setState(() {
      _descriptionController.clear();
      _locationController.clear();
      _selectedCategory = '';
      _selectedImages.clear();
      _locationData = null;
      _isGettingLocation = false;
    });
    _locationService.clearLocationData();
  }
}
