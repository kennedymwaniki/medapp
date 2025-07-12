import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddVitalsScreen extends ConsumerWidget {
  const AddVitalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vitals'), centerTitle: true),
      body: const Center(
        child: Text(
          'Add Vitals Screen - Coming Soon',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
