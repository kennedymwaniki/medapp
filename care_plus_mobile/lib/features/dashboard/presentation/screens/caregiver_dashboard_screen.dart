import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_theme.dart';

class CaregiverDashboardScreen extends ConsumerWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Dashboard'),
        centerTitle: true,
        backgroundColor: AppColors.caregiverColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Caregiver Dashboard - Coming Soon',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
