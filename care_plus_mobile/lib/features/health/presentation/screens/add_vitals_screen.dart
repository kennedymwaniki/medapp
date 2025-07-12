import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_theme.dart';

class AddVitalsScreen extends ConsumerStatefulWidget {
  const AddVitalsScreen({super.key});

  @override
  ConsumerState<AddVitalsScreen> createState() => _AddVitalsScreenState();
}

class _AddVitalsScreenState extends ConsumerState<AddVitalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedVitalType = 'Blood Pressure';

  final List<String> _vitalTypes = [
    'Blood Pressure',
    'Heart Rate',
    'Weight',
    'Height',
    'Blood Sugar',
    'Temperature',
    'Oxygen Saturation',
    'BMI',
  ];

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodSugarController.dispose();
    _temperatureController.dispose();
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vitals'),
        centerTitle: true,
        actions: [
          if (_currentPage > 0)
            TextButton(onPressed: _previousPage, child: const Text('Back')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildVitalTypeSelection(),
                  _buildVitalInput(),
                  _buildDateTimeSelection(),
                  _buildReviewAndSubmit(),
                ],
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              height: 4.h,
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? AppColors.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVitalTypeSelection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What would you like to record?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Select the type of vital sign you want to add',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 24.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.2,
            ),
            itemCount: _vitalTypes.length,
            itemBuilder: (context, index) {
              final vitalType = _vitalTypes[index];
              final isSelected = _selectedVitalType == vitalType;

              return Card(
                elevation: isSelected ? 4 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedVitalType = vitalType;
                    });
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getVitalIcon(vitalType),
                          size: 32.sp,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[600],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          vitalType,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVitalInput() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter $_selectedVitalType Reading',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please enter your $_selectedVitalType measurement',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 32.h),

          // Dynamic input based on vital type
          _buildVitalInputFields(),

          SizedBox(height: 24.h),

          // Notes section
          Text(
            'Notes (Optional)',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any additional notes about this reading...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalInputFields() {
    switch (_selectedVitalType) {
      case 'Blood Pressure':
        return Row(
          children: [
            Expanded(
              child: _buildNumberField(
                controller: _systolicController,
                label: 'Systolic',
                suffix: 'mmHg',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  final num = int.tryParse(value!);
                  if (num == null || num < 70 || num > 200) {
                    return 'Invalid range';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              '/',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildNumberField(
                controller: _diastolicController,
                label: 'Diastolic',
                suffix: 'mmHg',
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  final num = int.tryParse(value!);
                  if (num == null || num < 40 || num > 120) {
                    return 'Invalid range';
                  }
                  return null;
                },
              ),
            ),
          ],
        );

      case 'Heart Rate':
        return _buildNumberField(
          controller: _heartRateController,
          label: 'Heart Rate',
          suffix: 'bpm',
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            final num = int.tryParse(value!);
            if (num == null || num < 40 || num > 200) {
              return 'Invalid range (40-200 bpm)';
            }
            return null;
          },
        );

      case 'Weight':
        return _buildNumberField(
          controller: _weightController,
          label: 'Weight',
          suffix: 'kg',
          isDecimal: true,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            final num = double.tryParse(value!);
            if (num == null || num < 20 || num > 300) {
              return 'Invalid range (20-300 kg)';
            }
            return null;
          },
        );

      case 'Height':
        return _buildNumberField(
          controller: _heightController,
          label: 'Height',
          suffix: 'cm',
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            final num = int.tryParse(value!);
            if (num == null || num < 100 || num > 250) {
              return 'Invalid range (100-250 cm)';
            }
            return null;
          },
        );

      case 'Blood Sugar':
        return _buildNumberField(
          controller: _bloodSugarController,
          label: 'Blood Sugar',
          suffix: 'mg/dL',
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            final num = int.tryParse(value!);
            if (num == null || num < 50 || num > 400) {
              return 'Invalid range (50-400 mg/dL)';
            }
            return null;
          },
        );

      case 'Temperature':
        return _buildNumberField(
          controller: _temperatureController,
          label: 'Temperature',
          suffix: '°C',
          isDecimal: true,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            final num = double.tryParse(value!);
            if (num == null || num < 35 || num > 42) {
              return 'Invalid range (35-42°C)';
            }
            return null;
          },
        );

      default:
        return _buildNumberField(
          controller: _heartRateController,
          label: _selectedVitalType,
          suffix: '',
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            return null;
          },
        );
    }
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    bool isDecimal = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
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

  Widget _buildDateTimeSelection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When was this reading taken?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Select the date and time for this vital reading',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 32.h),

          // Date Selection
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today, color: AppColors.primary),
              title: const Text('Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectDate,
            ),
          ),

          SizedBox(height: 12.h),

          // Time Selection
          Card(
            child: ListTile(
              leading: Icon(Icons.access_time, color: AppColors.primary),
              title: const Text('Time'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectTime,
            ),
          ),

          SizedBox(height: 24.h),

          // Quick Date Options
          Text(
            'Quick Options',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),

          Wrap(
            spacing: 8.w,
            children: [
              _buildQuickDateChip('Now', DateTime.now()),
              _buildQuickDateChip(
                '1 hour ago',
                DateTime.now().subtract(const Duration(hours: 1)),
              ),
              _buildQuickDateChip(
                'This morning',
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  8,
                  0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateChip(String label, DateTime dateTime) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          _selectedDate = dateTime;
          _selectedTime = TimeOfDay.fromDateTime(dateTime);
        });
      },
    );
  }

  Widget _buildReviewAndSubmit() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Reading',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please review the information before saving',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 32.h),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewItem('Vital Type', _selectedVitalType),
                  _buildReviewItem('Reading', _getReadingValue()),
                  _buildReviewItem(
                    'Date',
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  _buildReviewItem('Time', _selectedTime.format(context)),
                  if (_notesController.text.isNotEmpty)
                    _buildReviewItem('Notes', _notesController.text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (_currentPage > 0) SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentPage == 3 ? _submitReading : _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                _currentPage == 3 ? 'Save Reading' : 'Next',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getVitalIcon(String vitalType) {
    switch (vitalType) {
      case 'Blood Pressure':
        return Icons.favorite;
      case 'Heart Rate':
        return Icons.monitor_heart;
      case 'Weight':
        return Icons.scale;
      case 'Height':
        return Icons.height;
      case 'Blood Sugar':
        return Icons.bloodtype;
      case 'Temperature':
        return Icons.thermostat;
      case 'Oxygen Saturation':
        return Icons.air;
      case 'BMI':
        return Icons.accessibility;
      default:
        return Icons.health_and_safety;
    }
  }

  String _getReadingValue() {
    switch (_selectedVitalType) {
      case 'Blood Pressure':
        return '${_systolicController.text}/${_diastolicController.text} mmHg';
      case 'Heart Rate':
        return '${_heartRateController.text} bpm';
      case 'Weight':
        return '${_weightController.text} kg';
      case 'Height':
        return '${_heightController.text} cm';
      case 'Blood Sugar':
        return '${_bloodSugarController.text} mg/dL';
      case 'Temperature':
        return '${_temperatureController.text} °C';
      default:
        return 'N/A';
    }
  }

  void _nextPage() {
    if (_currentPage == 1 && !_validateCurrentInput()) {
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentInput() {
    switch (_selectedVitalType) {
      case 'Blood Pressure':
        return _systolicController.text.isNotEmpty &&
            _diastolicController.text.isNotEmpty;
      case 'Heart Rate':
        return _heartRateController.text.isNotEmpty;
      case 'Weight':
        return _weightController.text.isNotEmpty;
      case 'Height':
        return _heightController.text.isNotEmpty;
      case 'Blood Sugar':
        return _bloodSugarController.text.isNotEmpty;
      case 'Temperature':
        return _temperatureController.text.isNotEmpty;
      default:
        return true;
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _submitReading() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save the vital reading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_selectedVitalType reading saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
