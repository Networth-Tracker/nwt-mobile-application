import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/services/auth/auth_flow.dart';
import 'package:nwt_app/utils/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final appLinks = AppLinks();
  late final AuthFlow _authFlow;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers if not already initialized
    try {
      Get.find<UserController>();
    } catch (_) {
      Get.put(UserController());
    }
    
    _authFlow = AuthFlow();
    
    // Handle deep links
    appLinks.uriLinkStream.listen((uri) {
      AppLogger.info('Deep link received: $uri', tag: 'SplashScreen');
      // Handle deep link if needed
    });
    
    // Delay to show splash screen for a minimum time
    Future.delayed(const Duration(seconds: 2), () {
      _initializeApp();
    });
  }
  
  Future<void> _initializeApp() async {
    try {
      await _authFlow.initialize();
    } catch (e) {
      AppLogger.error('Error initializing app', error: e, tag: 'SplashScreen');
      // Handle initialization error - could navigate to an error screen
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/app/pivot.money.png', height: 200),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
