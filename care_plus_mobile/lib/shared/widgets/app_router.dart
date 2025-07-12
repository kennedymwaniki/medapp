import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/main_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/patient_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/doctor_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/caregiver_dashboard_screen.dart';
import '../../features/medication/presentation/screens/medication_list_screen.dart';
import '../../features/medication/presentation/screens/medication_detail_screen.dart';
import '../../features/medication/presentation/screens/add_medication_screen.dart';
import '../../features/health/presentation/screens/health_vitals_screen.dart';
import '../../features/health/presentation/screens/add_vitals_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash and Authentication Routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main Dashboard Routes
      GoRoute(
        path: '/dashboard',
        name: 'main-dashboard',
        builder: (context, state) => const MainDashboardScreen(),
        routes: [
          // Patient Dashboard
          GoRoute(
            path: '/patient',
            name: 'patient-dashboard',
            builder: (context, state) => const PatientDashboardScreen(),
          ),
          // Doctor Dashboard
          GoRoute(
            path: '/doctor',
            name: 'doctor-dashboard',
            builder: (context, state) => const DoctorDashboardScreen(),
          ),
          // Caregiver Dashboard
          GoRoute(
            path: '/caregiver',
            name: 'caregiver-dashboard',
            builder: (context, state) => const CaregiverDashboardScreen(),
          ),
        ],
      ),

      // Medication Routes
      GoRoute(
        path: '/medications',
        name: 'medications',
        builder: (context, state) => const MedicationListScreen(),
        routes: [
          GoRoute(
            path: '/add',
            name: 'add-medication',
            builder: (context, state) => const AddMedicationScreen(),
          ),
          GoRoute(
            path: '/:medicationId',
            name: 'medication-detail',
            builder: (context, state) {
              final medicationId = state.pathParameters['medicationId']!;
              return MedicationDetailScreen(medicationId: medicationId);
            },
          ),
        ],
      ),

      // Health Vitals Routes
      GoRoute(
        path: '/health',
        name: 'health-vitals',
        builder: (context, state) => const HealthVitalsScreen(),
        routes: [
          GoRoute(
            path: '/add-vitals',
            name: 'add-vitals',
            builder: (context, state) => const AddVitalsScreen(),
          ),
        ],
      ),

      // Profile Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: '/edit',
            name: 'edit-profile',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Notification Routes
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Help and Support Routes
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpScreen(),
        routes: [
          GoRoute(
            path: '/faq',
            name: 'faq',
            builder: (context, state) => const FAQScreen(),
          ),
          GoRoute(
            path: '/contact',
            name: 'contact-support',
            builder: (context, state) => const ContactSupportScreen(),
          ),
        ],
      ),

      // Emergency Routes
      GoRoute(
        path: '/emergency',
        name: 'emergency',
        builder: (context, state) => const EmergencyScreen(),
      ),
    ],

    // Global error handler
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Route redirect logic
    redirect: (context, state) {
      // Add authentication logic here
      // For now, we'll allow all routes
      return null;
    },
  );
}

// Placeholder screens that we'll implement later
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen - Coming Soon')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen - Coming Soon')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Screen - Coming Soon')),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(child: Text('Help Screen - Coming Soon')),
    );
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: const Center(child: Text('FAQ Screen - Coming Soon')),
    );
  }
}

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: const Center(child: Text('Contact Support Screen - Coming Soon')),
    );
  }
}

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Emergency Screen - Coming Soon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
