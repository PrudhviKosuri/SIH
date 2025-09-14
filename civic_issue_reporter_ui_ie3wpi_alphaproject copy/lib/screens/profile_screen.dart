import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/report_form_widget.dart';
import '../styles/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  int _currentIndex = 3;
  bool _isEditing = false;
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();
  
  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Demo profile data
  Map<String, String> _profileData = {
    'name': 'Alex Johnson',
    'email': 'alex.johnson@civicreporter.com',
    'phone': '+1 (555) 987-6543',
    'address': '456 Oak Avenue, Downtown, CA 90210',
    'bio': 'Active citizen committed to making our community better',
  };
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _loadProfileData();
  }
  
  void _initializeControllers() {
    _nameController = TextEditingController(text: _profileData['name']);
    _emailController = TextEditingController(text: _profileData['email']);
    _phoneController = TextEditingController(text: _profileData['phone']);
    _addressController = TextEditingController(text: _profileData['address']);
    _bioController = TextEditingController(text: _profileData['bio']);
  }
  
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AppTheme.animationDuration,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: AppTheme.animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: AppTheme.animationCurve),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: AppTheme.animationCurve),
    );
    
    _fadeController.forward();
    _slideController.forward();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileData['name'] = prefs.getString('profile_name') ?? 'Alex Johnson';
      _profileData['email'] = prefs.getString('profile_email') ?? 'alex.johnson@civicreporter.com';
      _profileData['phone'] = prefs.getString('profile_phone') ?? '+1 (555) 987-6543';
      _profileData['address'] = prefs.getString('profile_address') ?? '456 Oak Avenue, Downtown, CA 90210';
      _profileData['bio'] = prefs.getString('profile_bio') ?? 'Active citizen committed to making our community better';
    });
    _initializeControllers();
  }
  
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _nameController.text);
    await prefs.setString('profile_email', _emailController.text);
    await prefs.setString('profile_phone', _phoneController.text);
    await prefs.setString('profile_address', _addressController.text);
    await prefs.setString('profile_bio', _bioController.text);
    
    setState(() {
      _profileData['name'] = _nameController.text;
      _profileData['email'] = _emailController.text;
      _profileData['phone'] = _phoneController.text;
      _profileData['address'] = _addressController.text;
      _profileData['bio'] = _bioController.text;
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
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
        Navigator.pushNamed(context, '/reports');
        break;
      case 2:
        // Add new report
        _showAddReportDialog();
        break;
      case 3:
        // Already on profile
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

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 70,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
  
  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryLight,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: AppTheme.primaryColor,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.neutral100, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppTheme.neutral100,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _profileData['name'] ?? 'User Name',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _profileData['email'] ?? 'user@example.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutral600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _profileData['bio'] ?? 'No bio available',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String value, IconData icon, TextEditingController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.neutral600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isEditing
                ? TextFormField(
                    controller: controller,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter $title',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )
                : Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.neutral800,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBioCard(String title, String value, IconData icon, TextEditingController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.neutral600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isEditing
                ? TextFormField(
                    controller: controller,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Tell us about yourself',
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  )
                : Text(
                    value.isNotEmpty ? value : 'No bio available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: value.isNotEmpty ? AppTheme.neutral800 : AppTheme.neutral500,
                      fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
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
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      // Reset controllers to original values
                      _initializeControllers();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check_rounded),
                  onPressed: _saveProfileData,
                ),
              ],
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 16),
                _buildInfoCard('Full Name', _profileData['name']!, Icons.person_rounded, _nameController),
                const SizedBox(height: 12),
                _buildInfoCard('Email Address', _profileData['email']!, Icons.email_rounded, _emailController),
                const SizedBox(height: 12),
                _buildInfoCard('Phone Number', _profileData['phone']!, Icons.phone_rounded, _phoneController),
                const SizedBox(height: 12),
                _buildInfoCard('Address', _profileData['address']!, Icons.location_on_rounded, _addressController),
                const SizedBox(height: 12),
                _buildBioCard('Bio', _profileData['bio']!, Icons.info_rounded, _bioController),
                const SizedBox(height: 32),
                if (_isEditing)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _initializeControllers();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.neutral400),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfileData,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: !_isEditing
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: const Icon(Icons.edit_rounded),
              heroTag: 'profile_edit_fab',
            )
          : null,
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
