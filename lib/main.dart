import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/firebase_options.dart';
import 'package:nwt_app/notification/firebase_messaging.dart';
import 'package:nwt_app/screens/onboarding/onboarding.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:firebase_core/firebase_core.dart';

// Initialize the local notifications plugin at the top level
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need to do any initialization here, do it before any other Firebase operations
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling background message: ${message.notification?.title}");
  // Handle background message logic here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  final messagingAPI = FirebaseMessagingAPI();
  await messagingAPI.initPushNotifications();
  
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        title: 'Networth Tracker',
        theme: AppTheme.lightTheme.copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
        ),
        darkTheme: AppTheme.darkTheme.copyWith(
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
        ),
        themeMode: themeController.themeMode,
        home: const OnboardingScreen(),
      ),
    );
  }
}
