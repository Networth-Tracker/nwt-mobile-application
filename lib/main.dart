import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/firebase_options.dart';
import 'package:nwt_app/screens/splash.dart';
import 'package:nwt_app/services/app_notificationpermission/notification_permission.dart';
import 'package:nwt_app/services/auth/auth_flow.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/network/network_sensitive.dart';

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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // // Initialize Firebase Remote Config
  // await FirebaseRemoteConfig.instance.setConfigSettings(
  //   RemoteConfigSettings(
  //     fetchTimeout: const Duration(minutes: 1),
  //     minimumFetchInterval: const Duration(hours: 1),
  //   ),
  // );
  // await FirebaseRemoteConfig.instance.fetchAndActivate();

  await Get.putAsync(() => ConnectivityService().init());
  Get.put(ThemeController());
  Get.put(UserController());
  await Get.putAsync(() => NotificationPermissionService().init());
  await NotificationPermissionService.to.retryPendingTokens();
  // StorageService.remove(StorageKeys.AUTH_TOKEN_KEY);
  runApp(
    ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(432.0, 960.0),
      child: const MainEntry(),
    ),
  );
}

Future<void> setupRemoteConfig() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );

    await remoteConfig.setDefaults({
      'api_base_url': 'https://app.networthtracker.in/api/v1',
    });

    bool updated = await remoteConfig.fetchAndActivate();

    final baseUrl = remoteConfig.getString('api_base_url');
    AppLogger.info(
      'Remote Config updated: $updated, API Base URL: $baseUrl',
      tag: 'RemoteConfig',
    );

    if (baseUrl.isEmpty) {
      AppLogger.warning(
        'Remote Config API Base URL is empty, using default',
        tag: 'RemoteConfig',
      );
    }
  } catch (e) {
    AppLogger.error('Error setting up Remote Config: $e', tag: 'RemoteConfig');
  }
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return Obx(
      () => GetMaterialApp(
        title: 'Pivot.Money',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        home: SplashScreen(),
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
