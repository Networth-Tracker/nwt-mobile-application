import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nwt_app/firebase_options.dart';
import 'package:nwt_app/utils/logger.dart';

class FirebaseMessagingAPI {
  // Lazy initialize FirebaseMessaging to prevent automatic permission prompts
  late final FirebaseMessaging _firebaseMessaging;
  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
        "high_importance_channel",
        "High Importance Notifications",
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
  late DarwinNotificationDetails _iosNotificationDetails =
      const DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.critical,
      );

  // Using the plugin instance from main.dart
  late final FlutterLocalNotificationsPlugin _localNotifications;
  
  // Constructor to prevent automatic initialization
  FirebaseMessagingAPI() {
    // We'll initialize _localNotifications and _firebaseMessaging only when needed
  }

  void localNotificationsApp(RemoteNotification? notification) {
    if (notification != null) {
      // Ensure _localNotifications is initialized
      if (!_isLocalNotificationsInitialized()) {
        AppLogger.warning('Local notifications not initialized', tag: 'FirebaseMessaging');
        return;
      }
      
      _localNotifications.show(
        0,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            channelShowBadge: true,
          ),
          iOS: _iosNotificationDetails,
        ),
      );
    }
  }
  
  // Helper method to check if local notifications are initialized
  bool _isLocalNotificationsInitialized() {
    try {
      // Access a property to check if it throws
      var _ = _localNotifications.pendingNotificationRequests();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> initPushNotifications() async {
    try {
      // Initialize Firebase Messaging instance
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // Initialize local notifications plugin
      _localNotifications = FlutterLocalNotificationsPlugin();
      
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/ic_notification');
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );
      await _localNotifications.initialize(initializationSettings);
      
      // Request notification permissions
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Initialize service worker for web
      if (kIsWeb) {
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          
          // Register the service worker
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
          
          // Get the token
          String? token = await FirebaseMessaging.instance.getToken(
            vapidKey: "YOUR_VAPID_KEY" // Get this from Firebase Console > Project Settings > Cloud Messaging > Web configuration
          );
          debugPrint('FCM Token: $token');
          
        } catch (e) {
          debugPrint('Error initializing FCM: $e');
        }
      } else {
        // Mobile platforms
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // Only register the background message handler in non-web environments
      if (!kIsWeb) {
        // This needs to be called before any other Firebase Messaging methods
        // We need to move this to the main.dart file
        // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          localNotificationsApp(notification);
        }
      });

      FirebaseMessaging.instance.getInitialMessage().then((value) {
        AppLogger.info("Initial message: $value", tag: 'FirebaseMessaging');
      });
    } catch (e) {
      AppLogger.error("Error initializing push notifications: $e", tag: 'FirebaseMessaging');
    }
  }

  Future<void> setupNotificationChannels() async {
    // Ensure _localNotifications is initialized
    if (!_isLocalNotificationsInitialized()) {
      AppLogger.warning('Local notifications not initialized for channel setup', tag: 'FirebaseMessaging');
      return;
    }
    
    // Set up iOS notification details
    _iosNotificationDetails = const DarwinNotificationDetails();

    // Create Android notification channel
    final platform = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<String?> initNotifications() async {
    try {
      // Initialize local notifications plugin
      _localNotifications = FlutterLocalNotificationsPlugin();
      
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@drawable/ic_notification');
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );
      await _localNotifications.initialize(initializationSettings);
      
      // Set up notification channels
      await setupNotificationChannels();
      
      // Initialize Firebase Messaging instance
      _firebaseMessaging = FirebaseMessaging.instance;

      // Request permission
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get the token
      final fcmToken = await _firebaseMessaging.getToken();
      print("FCM Token: $fcmToken");
      return fcmToken;
    } catch (e) {
      print("Error initializing notifications: $e");
      return null;
    }
  }

  // Background message handler has been moved to main.dart as a top-level function
}
