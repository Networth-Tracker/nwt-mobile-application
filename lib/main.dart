import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/screens/onboarding/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Networth Tracker',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const OnboardingScreen(),
    );
  }
}
