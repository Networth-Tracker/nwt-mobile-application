import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/screens/onboarding/onboarding.dart';
import 'package:nwt_app/services/global_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  
  Get.put(ThemeController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    
    return Obx(() => GetMaterialApp(
      title: 'Networth Tracker',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      themeMode: themeController.themeMode,
      home: const OnboardingScreen(),
    ));
  }
}