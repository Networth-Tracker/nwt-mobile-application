import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/firebase_options.dart';
import 'package:nwt_app/notification/firebase_messaging.dart';
import 'package:nwt_app/screens/splash.dart';
import 'package:nwt_app/screens/transactions/banks/list.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/network/network_sensitive.dart';
import 'package:firebase_core/firebase_core.dart';

// Initialize the local notifications plugin at the top level
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLogger.info("Handling background message: ${message.notification?.title}", tag: 'FirebaseMessaging');
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
  
  // Initialize controllers and services
  await Get.putAsync(() => ConnectivityService().init());
  Get.put(ThemeController());
  Get.put(UserController());
  
  runApp(const MyApp());
}
// Future<void> setupRemoteConfig() async {
//   final remoteConfig = FirebaseRemoteConfig.instance;

//   await remoteConfig.setConfigSettings(
//     RemoteConfigSettings(
//       fetchTimeout: const Duration(seconds: 10),
//       minimumFetchInterval: const Duration(seconds: 10),
//     ),
//   );

//   await remoteConfig.setDefaults(<String, dynamic>{
//     'welcome_message': 'Hello from default!',
//   });
//   await remoteConfig.fetchAndActivate();
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        title: 'Networth Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        // home: const AuthWrapper(child: OnboardingScreen()),
        home: const BankTransactionListScreen(),
        builder: (context, child) {
          // Wrap the entire app with network status banner
          return Column(
            children: [
              const NetworkStatusBanner(),
              Expanded(child: child!),
            ],
          );
        },
      ),
    );
  }
}
