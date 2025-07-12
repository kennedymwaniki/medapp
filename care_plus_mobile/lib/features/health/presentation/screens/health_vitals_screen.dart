import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_theme.dart';

class HealthVitalsScreen extends ConsumerStatefulWidget {
  const HealthVitalsScreen({super.key});

  @override
  ConsumerState<HealthVitalsScreen> createState() => _HealthVitalsScreenState();
}

class _HealthVitalsScreenState extends ConsumerState<HealthVitalsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '7 days';

  // Sample health data
  final Map<String, List<VitalReading>> _vitalsData = {
    'Blood Pressure': [
      VitalReading(
        value: '120/80',
        unit: 'mmHg',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: VitalStatus.normal,
      ),
      VitalReading(
        value: '125/85',
        unit: 'mmHg',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: VitalStatus.elevated,
      ),
      VitalReading(
        value: '118/78',
        unit: 'mmHg',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
      ),
    ],
    'Heart Rate': [
      VitalReading(
        value: '72',
        unit: 'bpm',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: VitalStatus.normal,
      ),
      VitalReading(
        value: '68',
        unit: 'bpm',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: VitalStatus.normal,
      ),
      VitalReading(
        value: '75',
        unit: 'bpm',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
      ),
    ],
    'Weight': [
      VitalReading(
        value: '70.2',
        unit: 'kg',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: VitalStatus.normal,
      ),
      VitalReading(
        value: '70.5',
        unit: 'kg',
        date: DateTime.now().subtract(const Duration(days: 7)),
        status: VitalStatus.normal,
      ),
      VitalReading(
        value: '71.0',
        unit: 'kg',
        date: DateTime.now().subtract(const Duration(days: 14)),
        status: VitalStatus.normal,
      ),
    ],
    'Blood Sugar': [
      VitalReading(
        value: '95',
        unit: 'mg/dL',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: VitalStatus.normal,
      ),
      VitalReading(
        value: '102',
        unit: 'mg/dL',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: VitalStatus.elevated,
      ),
      VitalReading(
        value: '88',
        unit: 'mg/dL',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: VitalStatus.normal,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Vitals'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7 days', child: Text('Last 7 days')),
              const PopupMenuItem(
                value: '30 days',
                child: Text('Last 30 days'),
              ),
              const PopupMenuItem(
                value: '90 days',
                child: Text('Last 3 months'),
              ),
              const PopupMenuItem(value: '1 year', child: Text('Last year')),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedTimeRange),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trends'),
            Tab(text: 'Goals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOverviewTab(), _buildTrendsTab(), _buildGoalsTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVitalReading,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Reading', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Summary Card
          _buildHealthSummaryCard(),
          SizedBox(height: 20.h),

          // Quick Actions
          _buildQuickActions(),
          SizedBox(height: 20.h),

          // Vitals Grid
          Text(
            'Recent Vitals',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildVitalsGrid(),
          SizedBox(height: 20.h),

          // Recent Readings
          Text(
            'Recent Readings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildRecentReadings(),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Trends',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),

          // Chart placeholders for each vital
          ..._vitalsData.keys.map(
            (vital) => Column(
              children: [
                _buildTrendChart(vital),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Goals',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),

          _buildGoalCard(
            title: 'Blood Pressure Goal',
            target: 'Keep below 120/80 mmHg',
            current: '120/80 mmHg',
            progress: 0.9,
            color: Colors.green,
          ),
          SizedBox(height: 12.h),

          _buildGoalCard(
            title: 'Weight Goal',
            target: 'Maintain 68-72 kg',
            current: '70.2 kg',
            progress: 0.8,
            color: Colors.blue,
          ),
          SizedBox(height: 12.h),

          _buildGoalCard(
            title: 'Blood Sugar Goal',
            target: 'Keep below 100 mg/dL',
            current: '95 mg/dL',
            progress: 0.95,
            color: Colors.orange,
          ),
          SizedBox(height: 12.h),

          _buildGoalCard(
            title: 'Exercise Goal',
            target: '150 minutes per week',
            current: '120 minutes this week',
            progress: 0.8,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.white, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Health Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Overall Score', '85%', Colors.white),
                _buildSummaryItem('Last Updated', 'Today', Colors.white70),
                _buildSummaryItem('Trend', '↗ Improving', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.8), fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.add_circle_outline,
            label: 'Add Reading',
            onTap: _addVitalReading,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.calendar_today,
            label: 'Set Reminder',
            onTap: _setReminder,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.share,
            label: 'Share Report',
            onTap: _shareReport,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalsGrid() {
    final vitals = _vitalsData.keys.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: vitals.length,
      itemBuilder: (context, index) {
        final vitalName = vitals[index];
        final latestReading = _vitalsData[vitalName]!.first;
        return _buildVitalCard(vitalName, latestReading);
      },
    );
  }

  Widget _buildVitalCard(String name, VitalReading reading) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: () => _viewVitalDetails(name),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getVitalIcon(name),
                    color: _getStatusColor(reading.status),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                reading.value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                reading.unit,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(reading.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  reading.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(reading.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReadings() {
    final allReadings = <VitalReading>[];
    _vitalsData.forEach((name, readings) {
      for (final reading in readings) {
        allReadings.add(reading.copyWith(name: name));
      }
    });

    allReadings.sort((a, b) => b.date.compareTo(a.date));
    final recentReadings = allReadings.take(5).toList();

    return Column(
      children: recentReadings.map((reading) {
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(reading.status).withOpacity(0.1),
              child: Icon(
                _getVitalIcon(reading.name ?? ''),
                color: _getStatusColor(reading.status),
                size: 20.sp,
              ),
            ),
            title: Text(reading.name ?? ''),
            subtitle: Text(_formatDate(reading.date)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  reading.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  reading.unit,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendChart(String vitalName) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vitalName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Center(child: Text('Chart coming soon')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String target,
    required String current,
    required double progress,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text('Target: $target', style: TextStyle(color: Colors.grey[600])),
            Text(
              'Current: $current',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVitalIcon(String vitalName) {
    switch (vitalName) {
      case 'Blood Pressure':
        return Icons.favorite;
      case 'Heart Rate':
        return Icons.monitor_heart;
      case 'Weight':
        return Icons.scale;
      case 'Blood Sugar':
        return Icons.bloodtype;
      default:
        return Icons.health_and_safety;
    }
  }

  Color _getStatusColor(VitalStatus status) {
    switch (status) {
      case VitalStatus.normal:
        return Colors.green;
      case VitalStatus.elevated:
        return Colors.orange;
      case VitalStatus.high:
        return Colors.red;
      case VitalStatus.low:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${difference} days ago';
    }
  }

  void _addVitalReading() {
    // Navigate to add vitals screen
    Navigator.pushNamed(context, '/add-vitals');
  }

  void _setReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Set reminder functionality coming soon')),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share report functionality coming soon')),
    );
  }

  void _viewVitalDetails(String vitalName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Viewing details for $vitalName')));
  }
}

// Data Models
class VitalReading {
  final String value;
  final String unit;
  final DateTime date;
  final VitalStatus status;
  final String? name;

  VitalReading({
    required this.value,
    required this.unit,
    required this.date,
    required this.status,
    this.name,
  });

  VitalReading copyWith({
    String? value,
    String? unit,
    DateTime? date,
    VitalStatus? status,
    String? name,
  }) {
    return VitalReading(
      value: value ?? this.value,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      status: status ?? this.status,
      name: name ?? this.name,
    );
  }
}

enum VitalStatus { normal, elevated, high, low }
