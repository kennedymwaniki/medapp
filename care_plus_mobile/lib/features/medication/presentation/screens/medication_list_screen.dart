import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_theme.dart';

// Simple medication class for UI display
class SimpleMedication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String instructions;
  final String prescribedBy;
  final DateTime startDate;
  final DateTime? endDate;
  final List<TimeOfDay> reminderTimes;
  final bool isActive;

  const SimpleMedication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.prescribedBy,
    required this.startDate,
    this.endDate,
    required this.reminderTimes,
    required this.isActive,
  });
}

class MedicationListScreen extends ConsumerStatefulWidget {
  const MedicationListScreen({super.key});

  @override
  ConsumerState<MedicationListScreen> createState() =>
      _MedicationListScreenState();
}

class _MedicationListScreenState extends ConsumerState<MedicationListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Sample data - replace with actual data from providers
  final List<SimpleMedication> _activeMedications = [
    SimpleMedication(
      id: '1',
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      instructions: 'Take with food in the morning',
      prescribedBy: 'Dr. Smith',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      reminderTimes: [const TimeOfDay(hour: 8, minute: 0)],
      isActive: true,
    ),
    SimpleMedication(
      id: '2',
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      instructions: 'Take with meals',
      prescribedBy: 'Dr. Johnson',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 90)),
      reminderTimes: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ],
      isActive: true,
    ),
    SimpleMedication(
      id: '3',
      name: 'Vitamin D3',
      dosage: '1000 IU',
      frequency: 'Once daily',
      instructions: 'Take with breakfast',
      prescribedBy: 'Dr. Wilson',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: DateTime.now().add(const Duration(days: 180)),
      reminderTimes: [const TimeOfDay(hour: 9, minute: 0)],
      isActive: true,
    ),
  ];

  final List<SimpleMedication> _pastMedications = [
    SimpleMedication(
      id: '4',
      name: 'Amoxicillin',
      dosage: '500mg',
      frequency: 'Three times daily',
      instructions: 'Complete full course',
      prescribedBy: 'Dr. Brown',
      startDate: DateTime.now().subtract(const Duration(days: 120)),
      endDate: DateTime.now().subtract(const Duration(days: 110)),
      reminderTimes: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 14, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ],
      isActive: false,
    ),
  ];

  final List<SimpleMedication> _asNeededMedications = [
    SimpleMedication(
      id: '5',
      name: 'Ibuprofen',
      dosage: '200mg',
      frequency: 'As needed',
      instructions: 'For pain relief, max 3 per day',
      prescribedBy: 'Dr. Smith',
      startDate: DateTime.now().subtract(const Duration(days: 180)),
      endDate: DateTime.now().add(const Duration(days: 180)),
      reminderTimes: [],
      isActive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SimpleMedication> get _filteredActiveMedications {
    if (_searchQuery.isEmpty) return _activeMedications;
    return _activeMedications
        .where(
          (med) => med.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<SimpleMedication> get _filteredPastMedications {
    if (_searchQuery.isEmpty) return _pastMedications;
    return _pastMedications
        .where(
          (med) => med.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<SimpleMedication> get _filteredAsNeededMedications {
    if (_searchQuery.isEmpty) return _asNeededMedications;
    return _asNeededMedications
        .where(
          (med) => med.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortDialog),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120.h),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search medications...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: 'Active (${_filteredActiveMedications.length})'),
                  Tab(text: 'Past (${_filteredPastMedications.length})'),
                  Tab(
                    text: 'As Needed (${_filteredAsNeededMedications.length})',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicationList(_filteredActiveMedications, true),
          _buildMedicationList(_filteredPastMedications, false),
          _buildMedicationList(_filteredAsNeededMedications, true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMedication,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Medication',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMedicationList(
    List<SimpleMedication> medications,
    bool showActions,
  ) {
    if (medications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshMedications,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return _buildMedicationCard(medication, showActions);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined, size: 80.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No medications found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the + button to add your first medication',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(SimpleMedication medication, bool showActions) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: () => _viewMedicationDetails(medication),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.medication,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${medication.dosage} • ${medication.frequency}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  if (showActions)
                    PopupMenuButton<String>(
                      onSelected: (value) =>
                          _handleMenuAction(value, medication),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reminder',
                          child: Row(
                            children: [
                              Icon(Icons.alarm),
                              SizedBox(width: 8),
                              Text('Set Reminder'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'take',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle),
                              SizedBox(width: 8),
                              Text('Mark as Taken'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 12.h),

              // Instructions
              if (medication.instructions.isNotEmpty) ...[
                Text(
                  'Instructions:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  medication.instructions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 12.h),
              ],

              // Details Row
              Row(
                children: [
                  Expanded(
                    child: _buildDetailChip(
                      icon: Icons.person,
                      label: medication.prescribedBy,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (medication.reminderTimes.isNotEmpty)
                    Expanded(
                      child: _buildDetailChip(
                        icon: Icons.access_time,
                        label: '${medication.reminderTimes.length} reminder(s)',
                        color: Colors.orange,
                      ),
                    ),
                ],
              ),

              // Next Dose (for active medications)
              if (showActions && medication.reminderTimes.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.green, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Next dose: ${_formatNextDose(medication.reminderTimes.first)}',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNextDose(TimeOfDay time) {
    final now = DateTime.now();
    final nextDose = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (nextDose.isBefore(now)) {
      // If time has passed today, show tomorrow
      // final tomorrow = nextDose.add(const Duration(days: 1));
      return 'Tomorrow at ${time.format(context)}';
    } else {
      return 'Today at ${time.format(context)}';
    }
  }

  void _addMedication() {
    // Navigate to add medication screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add medication screen coming soon')),
    );
  }

  void _viewMedicationDetails(SimpleMedication medication) {
    // Navigate to medication details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${medication.name}')),
    );
  }

  void _handleMenuAction(String action, SimpleMedication medication) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Edit ${medication.name}')));
        break;
      case 'reminder':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Set reminder for ${medication.name}')),
        );
        break;
      case 'take':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marked ${medication.name} as taken')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(medication);
        break;
    }
  }

  void _showDeleteConfirmation(SimpleMedication medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text('Are you sure you want to delete ${medication.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${medication.name} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Medications'),
        content: const Text('Filter options coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Medications'),
        content: const Text('Sort options coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMedications() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Refresh data here
      });
    }
  }
}
