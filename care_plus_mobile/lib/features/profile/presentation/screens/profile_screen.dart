import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../shared/models/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  bool _notificationsEnabled = true;
  bool _medicationReminders = true;
  bool _healthAlerts = true;
  UserRole _selectedRole = UserRole.patient;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Load user data from storage or provider
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+1 (555) 123-4567';
    _emergencyContactController.text = '+1 (555) 987-6543';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(),
              SizedBox(height: 24.h),

              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              SizedBox(height: 16.h),
              _buildPersonalInfoSection(),
              SizedBox(height: 24.h),

              // Account Settings Section
              _buildSectionHeader('Account Settings'),
              SizedBox(height: 16.h),
              _buildAccountSettingsSection(),
              SizedBox(height: 24.h),

              // Notification Settings Section
              _buildSectionHeader('Notification Settings'),
              SizedBox(height: 16.h),
              _buildNotificationSettingsSection(),
              SizedBox(height: 24.h),

              // Health Information Section
              _buildSectionHeader('Health Information'),
              SizedBox(height: 16.h),
              _buildHealthInfoSection(),
              SizedBox(height: 24.h),

              // Emergency Contact Section
              _buildSectionHeader('Emergency Contact'),
              SizedBox(height: 16.h),
              _buildEmergencyContactSection(),
              SizedBox(height: 32.h),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 60.sp, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    onPressed: _updateProfilePicture,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            _nameController.text.isEmpty ? 'Your Name' : _nameController.text,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getRoleColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              _selectedRole.name.toUpperCase(),
              style: TextStyle(
                color: _getRoleColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildAccountSettingsSection() {
    return Column(
      children: [
        _buildDropdownField(
          label: 'Account Type',
          value: _selectedRole,
          icon: Icons.account_circle_outlined,
          items: UserRole.values.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (UserRole? value) {
            if (value != null) {
              setState(() {
                _selectedRole = value;
              });
            }
          },
        ),
        SizedBox(height: 16.h),
        _buildListTile(
          title: 'Change Password',
          icon: Icons.lock_outline,
          onTap: _changePassword,
        ),
        _buildListTile(
          title: 'Privacy Settings',
          icon: Icons.privacy_tip_outlined,
          onTap: _openPrivacySettings,
        ),
      ],
    );
  }

  Widget _buildNotificationSettingsSection() {
    return Column(
      children: [
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive notifications on your device',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          title: 'Medication Reminders',
          subtitle: 'Get reminded to take your medications',
          value: _medicationReminders,
          onChanged: (value) {
            setState(() {
              _medicationReminders = value;
            });
          },
        ),
        _buildSwitchTile(
          title: 'Health Alerts',
          subtitle: 'Receive important health notifications',
          value: _healthAlerts,
          onChanged: (value) {
            setState(() {
              _healthAlerts = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHealthInfoSection() {
    return Column(
      children: [
        _buildListTile(
          title: 'Medical History',
          subtitle: 'View and update your medical history',
          icon: Icons.history_outlined,
          onTap: _openMedicalHistory,
        ),
        _buildListTile(
          title: 'Allergies & Conditions',
          subtitle: 'Manage your allergies and medical conditions',
          icon: Icons.warning_amber_outlined,
          onTap: _openAllergiesAndConditions,
        ),
        _buildListTile(
          title: 'Insurance Information',
          subtitle: 'Update your insurance details',
          icon: Icons.medical_services_outlined,
          onTap: _openInsuranceInfo,
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection() {
    return Column(
      children: [
        _buildTextField(
          controller: _emergencyContactController,
          label: 'Emergency Contact Number',
          icon: Icons.emergency_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter an emergency contact number';
            }
            return null;
          },
        ),
        SizedBox(height: 8.h),
        Text(
          'This number will be contacted in case of emergency',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Save Changes',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _exportData,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Export My Data',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _logout,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Color _getRoleColor() {
    switch (_selectedRole) {
      case UserRole.patient:
        return Colors.blue;
      case UserRole.doctor:
        return Colors.green;
      case UserRole.caregiver:
        return Colors.orange;
    }
  }

  void _updateProfilePicture() {
    // Implement profile picture update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture update coming soon')),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    }
  }

  void _changePassword() {
    // Implement change password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password coming soon')),
    );
  }

  void _openPrivacySettings() {
    // Implement privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon')),
    );
  }

  void _openMedicalHistory() {
    // Implement medical history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medical history coming soon')),
    );
  }

  void _openAllergiesAndConditions() {
    // Implement allergies and conditions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Allergies & conditions coming soon')),
    );
  }

  void _openInsuranceInfo() {
    // Implement insurance info
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Insurance information coming soon')),
    );
  }

  void _exportData() {
    // Implement data export
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data export coming soon')));
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout functionality coming soon'),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
