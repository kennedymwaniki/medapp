import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';

/// Notification service for handling local and push notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging? _firebaseMessaging;

  /// Initialize notification service
  Future<void> init() async {
    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Initialize Firebase messaging (skip on web for now)
      if (!kIsWeb) {
        await _initializeFirebaseMessaging();
      }

      // Setup notification channels
      await _setupNotificationChannels();
    } catch (e) {
      throw NotificationException(
        message: 'Failed to initialize notification service: ${e.toString()}',
      );
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Skip local notifications on web as they're not fully supported
    if (kIsWeb) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Initialize Firebase messaging instance
    _firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions
    await _firebaseMessaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Get FCM token
    final token = await _firebaseMessaging!.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  /// Setup notification channels
  Future<void> _setupNotificationChannels() async {
    // Skip notification channels on web and iOS (only needed for Android)
    if (kIsWeb || Platform.isIOS) return;

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Medication reminders channel
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.medicationChannelId,
          AppConstants.medicationChannelName,
          description: AppConstants.medicationChannelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Appointments channel
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.appointmentChannelId,
          AppConstants.appointmentChannelName,
          description: AppConstants.appointmentChannelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Health alerts channel
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.healthChannelId,
          AppConstants.healthChannelName,
          description: AppConstants.healthChannelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
    }
  }

  /// Schedule medication reminder
  Future<void> scheduleMedicationReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.medicationChannelId,
            AppConstants.medicationChannelName,
            channelDescription: AppConstants.medicationChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
            actions: [
              AndroidNotificationAction('take_medication', 'Take Now'),
              AndroidNotificationAction('snooze_medication', 'Snooze'),
            ],
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'medication_reminder',
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      throw NotificationException(
        message: 'Failed to schedule medication reminder: ${e.toString()}',
      );
    }
  }

  /// Schedule recurring medication reminder
  Future<void> scheduleRecurringMedicationReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required RepeatInterval repeatInterval,
    String? payload,
  }) async {
    try {
      await _localNotifications.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.medicationChannelId,
            AppConstants.medicationChannelName,
            channelDescription: AppConstants.medicationChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'medication_reminder',
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      throw NotificationException(
        message:
            'Failed to schedule recurring medication reminder: ${e.toString()}',
      );
    }
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String channelId = AppConstants.medicationChannelId,
    String channelName = AppConstants.medicationChannelName,
    String? payload,
  }) async {
    try {
      await _localNotifications.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            interruptionLevel: InterruptionLevel.active,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      throw NotificationException(
        message: 'Failed to show notification: ${e.toString()}',
      );
    }
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
    } catch (e) {
      throw NotificationException(
        message: 'Failed to cancel notification: ${e.toString()}',
      );
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
    } catch (e) {
      throw NotificationException(
        message: 'Failed to cancel all notifications: ${e.toString()}',
      );
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      throw NotificationException(
        message: 'Failed to get pending notifications: ${e.toString()}',
      );
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      if (_firebaseMessaging == null) return null;
      return await _firebaseMessaging!.getToken();
    } catch (e) {
      throw NotificationException(
        message: 'Failed to get FCM token: ${e.toString()}',
      );
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      if (_firebaseMessaging == null) return;
      await _firebaseMessaging!.subscribeToTopic(topic);
    } catch (e) {
      throw NotificationException(
        message: 'Failed to subscribe to topic: ${e.toString()}',
      );
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      if (_firebaseMessaging == null) return;
      await _firebaseMessaging!.unsubscribeFromTopic(topic);
    } catch (e) {
      throw NotificationException(
        message: 'Failed to unsubscribe from topic: ${e.toString()}',
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }

    // Handle notification action
    switch (response.actionId) {
      case 'take_medication':
        _handleTakeMedicationAction(response.payload);
        break;
      case 'snooze_medication':
        _handleSnoozeMedicationAction(response.payload);
        break;
      default:
        _handleDefaultNotificationTap(response.payload);
    }
  }

  /// Handle take medication action
  void _handleTakeMedicationAction(String? payload) {
    // Navigate to medication confirmation screen
    // This would be handled by the navigation service
    if (kDebugMode) {
      print('Take medication action: $payload');
    }
  }

  /// Handle snooze medication action
  void _handleSnoozeMedicationAction(String? payload) {
    // Show snooze options dialog
    // This would be handled by the UI layer
    if (kDebugMode) {
      print('Snooze medication action: $payload');
    }
  }

  /// Handle default notification tap
  void _handleDefaultNotificationTap(String? payload) {
    // Navigate to appropriate screen based on payload
    if (kDebugMode) {
      print('Default notification tap: $payload');
    }
  }

  /// Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Background message: ${message.messageId}');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message: ${message.messageId}');
    }

    // Show local notification for foreground messages
    showNotification(
      id: message.messageId.hashCode,
      title: message.notification?.title ?? 'Care Plus',
      body: message.notification?.body ?? 'New notification',
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap from FCM
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('FCM notification tapped: ${message.messageId}');
    }

    // Navigate based on message data
    _handleDefaultNotificationTap(message.data.toString());
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin = _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await androidPlugin?.areNotificationsEnabled() ?? false;
      } else if (Platform.isIOS) {
        final iosPlugin = _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        return await iosPlugin?.requestPermissions() ?? false;
      }
      return false;
    } catch (e) {
      throw NotificationException(
        message: 'Failed to check notification permissions: ${e.toString()}',
      );
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin = _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await androidPlugin?.requestNotificationsPermission() ?? false;
      } else if (Platform.isIOS) {
        final iosPlugin = _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        return await iosPlugin?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
      return false;
    } catch (e) {
      throw NotificationException(
        message: 'Failed to request notification permissions: ${e.toString()}',
      );
    }
  }
}
