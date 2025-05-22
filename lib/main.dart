import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/firebase_options.dart';
import 'package:nwt_app/notification/firebase_messaging.dart';
import 'package:nwt_app/screens/fetch-holdings/mf_fetching.dart';
import 'package:nwt_app/services/auth/auth_flow.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/network/network_sensitive.dart';

// Initialize the local notifications plugin at the top level
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLogger.info(
    "Handling background message: ${message.notification?.title}",
    tag: 'FirebaseMessaging',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintPointersEnabled = false;
  debugPaintLayerBordersEnabled = false;

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
  runApp(
    ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(432.0, 960.0),
      child: const MainEntry(),
    ),
  );
}

Future<void> setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ),
  );

  // await remoteConfig.setDefaults(<String, dynamic>{
  //   'welcome_message': 'Hello from default!',
  // });
  // await remoteConfig.fetchAndActivate();
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    StorageService.write(
      StorageKeys.AUTH_TOKEN_KEY,
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjMsInBob25lbnVtYmVyIjoiOTIzOTg3NDU2MCIsImd1aWQiOiJVXzE3NDcwMzkzNzE1OTUiLCJwYW5udW1iZXIiOiJBUVFQUzc1NzZSIiwiaWF0IjoxNzQ3OTA0MzU0LCJleHAiOjE3NDg1MDkxNTR9.eHENEahc2CH5YKU_Mb0iIwaAIpV2JNplELi5jNz9zh4",
    );
    return Obx(
      () => GetMaterialApp(
        title: 'pivot.money',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        home: const MutualFundHoldingsJourneyScreen(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: Column(
              children: [Expanded(child: child!), const NetworkStatusBanner()],
            ),
          );
        },
        initialBinding: BindingsBuilder(() {
          Get.put<UserController>(UserController());
          Get.put<AuthFlow>(AuthFlow());
        }),
      ),
    );
  }
}
