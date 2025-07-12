import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_theme.dart';

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardHomeScreen(),
    const MedicationsTabScreen(),
    const HealthTabScreen(),
    const ProfileTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            activeIcon: Icon(Icons.medication),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Dashboard Home Screen
class DashboardHomeScreen extends ConsumerWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.medical_services, color: AppColors.primary, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              AppConstants.appName,
              style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizing.paddingL),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, John!',
                    style: AppTextStyles.heading3.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'How are you feeling today?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.add_circle_outline,
                        label: 'Log Vitals',
                        onTap: () => context.push('/health/add-vitals'),
                      ),
                      SizedBox(width: 12.w),
                      _buildQuickActionButton(
                        icon: Icons.medication,
                        label: 'Take Med',
                        onTap: () => context.push('/medications'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Quick Stats
            Text('Today\'s Overview', style: AppTextStyles.heading4),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Medications',
                    value: '3/5',
                    subtitle: 'taken today',
                    icon: Icons.medication,
                    color: AppColors.medicationTaken,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    title: 'Blood Pressure',
                    value: '120/80',
                    subtitle: 'last reading',
                    icon: Icons.favorite,
                    color: AppColors.healthGood,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Upcoming Medications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Medications', style: AppTextStyles.heading4),
                TextButton(
                  onPressed: () => context.push('/medications'),
                  child: Text(
                    'View All',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Medication List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return _buildMedicationCard(
                  name: [
                    'Aspirin 100mg',
                    'Metformin 500mg',
                    'Lisinopril 10mg',
                  ][index],
                  time: ['8:00 AM', '2:00 PM', '8:00 PM'][index],
                  status: ['pending', 'pending', 'taken'][index],
                );
              },
            ),

            SizedBox(height: 24.h),

            // Health Trends
            Text('Health Trends', style: AppTextStyles.heading4),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 200.h,
              padding: EdgeInsets.all(AppSizing.paddingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'Health Chart\n(Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSizing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(icon, size: 20.sp, color: color),
            ],
          ),
          SizedBox(height: 8.h),
          Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard({
    required String name,
    required String time,
    required String status,
  }) {
    Color statusColor = status == 'taken'
        ? AppColors.medicationTaken
        : status == 'pending'
        ? AppColors.medicationPending
        : AppColors.medicationMissed;

    return Container(
      padding: EdgeInsets.all(AppSizing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.medication, color: statusColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium),
                Text(
                  time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (status == 'pending')
            ElevatedButton(
              onPressed: () {
                // TODO: Mark as taken
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(60.w, 32.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                'Take',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
            ),
          if (status == 'taken')
            Icon(Icons.check_circle, color: statusColor, size: 24.sp),
        ],
      ),
    );
  }
}

// Placeholder screens for other tabs
class MedicationsTabScreen extends StatelessWidget {
  const MedicationsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medications'), centerTitle: true),
      body: const Center(child: Text('Medications Screen - Coming Soon')),
    );
  }
}

class HealthTabScreen extends StatelessWidget {
  const HealthTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health'), centerTitle: true),
      body: const Center(child: Text('Health Screen - Coming Soon')),
    );
  }
}

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: const Center(child: Text('Profile Screen - Coming Soon')),
    );
  }
}
