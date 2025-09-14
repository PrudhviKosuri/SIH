import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';
import '../styles/app_theme.dart';
import '../services/location_service.dart';
import '../screens/camera_screen.dart';
import '../providers/reports_provider.dart';
import 'voice_recorder_widget.dart';
import 'video_upload_widget.dart';

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
  
  // Voice recording properties
  String? _audioPath;
  Duration _recordingDuration = Duration.zero;
  
  // Video properties
  File? _selectedVideo;

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
  void initState() {
    super.initState();
  }
  
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
                
                // Audio attachment indicator
                if (_audioPath != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.audiotrack_rounded,
                          color: AppTheme.accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voice Recording',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                              Text(
                                'Duration: ${_recordingDuration.inMinutes}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.neutral600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_audioPath != null) {
                                File(_audioPath!).delete();
                                _audioPath = null;
                              }
                            });
                          },
                          icon: const Icon(Icons.close_rounded, size: 16),
                          style: IconButton.styleFrom(
                            foregroundColor: AppTheme.errorColor,
                            minimumSize: const Size(24, 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Video attachment indicator
                if (_selectedVideo != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.videocam_rounded,
                          color: AppTheme.secondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Video Attachment',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              FutureBuilder<int>(
                                future: _selectedVideo!.length(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final sizeInMB = snapshot.data! / (1024 * 1024);
                                    return Text(
                                      'Size: ${sizeInMB.toStringAsFixed(1)} MB',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.neutral600,
                                      ),
                                    );
                                  }
                                  return Text(
                                    'Loading...',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.neutral600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedVideo = null;
                            });
                          },
                          icon: const Icon(Icons.close_rounded, size: 16),
                          style: IconButton.styleFrom(
                            foregroundColor: AppTheme.errorColor,
                            minimumSize: const Size(24, 24),
                          ),
                        ),
                      ],
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
                        onPressed: _takePhotoFromCamera,
                        icon: const Icon(Icons.camera_alt_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          foregroundColor: AppTheme.primaryColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        tooltip: 'Take Photo',
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _pickVideo,
                        icon: const Icon(Icons.videocam_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                          foregroundColor: AppTheme.secondaryColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        tooltip: 'Upload Video',
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _handleVoiceRecording,
                        icon: const Icon(Icons.mic_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                          foregroundColor: AppTheme.accentColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        tooltip: 'Record Voice',
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

  Future<void> _handleVoiceRecording() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceRecorderWidget(
        onRecordingComplete: (audioPath, duration) {
          setState(() {
            _audioPath = audioPath;
            _recordingDuration = duration;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Voice recording attached!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        },
      ),
    );
  }
  
  
  Future<void> _pickVideo() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoUploadWidget(
        onVideoSelected: (videoFile) {
          setState(() {
            _selectedVideo = videoFile;
          });
        },
      ),
    );
  }

  Future<void> _takePhotoFromCamera() async {
    try {
      final String? imagePath = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        ),
      );

      if (imagePath != null && mounted) {
        setState(() {
          _selectedImages.add(File(imagePath));
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo added successfully!'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<bool> _showImagePreviewDialog(File imageFile) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          decoration: BoxDecoration(
            color: AppTheme.neutral100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.preview_rounded,
                      color: AppTheme.neutral100,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Photo Preview',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.neutral100,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Image preview
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppTheme.neutral400),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.close_rounded, size: 18),
                            const SizedBox(width: 8),
                            const Text('Retake'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_rounded, size: 18),
                            const SizedBox(width: 8),
                            const Text('Use Photo'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
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
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Submitting report...'),
                ],
              ),
            ),
          ),
        );

        // Submit report using provider
        final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
        await reportsProvider.submitNewReport(
          title: '$_selectedCategory Issue',
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
          location: _locationController.text.isNotEmpty ? _locationController.text.trim() : null,
          hasAttachments: _selectedImages.isNotEmpty || _audioPath != null || _selectedVideo != null,
        );

        // Send location data to backend if available
        if (_locationData != null) {
          await _locationService.sendLocationToBackend(_locationData!);
        }

        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();
        }
        
        // Show success dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppTheme.successColor),
                  const SizedBox(width: 8),
                  const Text('Success!'),
                ],
              ),
              content: const Text(
                'Your report has been submitted successfully! You can track its progress in the Reports section.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close bottom sheet
                    _clearForm();
                  },
                  child: const Text('View Reports'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // Close loading dialog if it's open
        if (mounted) {
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting report: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
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
