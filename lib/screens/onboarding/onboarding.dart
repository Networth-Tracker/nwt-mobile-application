import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/widgets/common/theme_toggle.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/notification/firebase_messaging.dart';
import 'package:nwt_app/screens/auth/phone_number.dart';
import 'package:animate_do/animate_do.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final remoteConfig = FirebaseRemoteConfig.instance;
  @override
  void initState() {
    super.initState();
    initNotifications();
    String message = remoteConfig.getString('welcome_message');
    print("message: $message");
  }

  Future<void> initNotifications() async {
    String? fcmtoken = await FirebaseMessagingAPI().initNotifications();
    print("fcmtoken: $fcmtoken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Your Screen'), actions: [ThemeToggle()]),
      body: GetBuilder<ThemeController>(
        builder: (themeController) {
          return SafeArea(
            bottom: false, // Don't pad the bottom with SafeArea
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 120),
                      FadeInDown(
                        curve: Curves.decelerate,
                        duration: Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: 1000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            themeController.isDarkMode
                                ? SvgPicture.asset(
                                  'assets/svgs/onboarding/onboarding_01_dark.svg',
                                )
                                : SvgPicture.asset(
                                  'assets/svgs/onboarding/onboarding_01.svg',
                                ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                      FadeInUp(
                        curve: Curves.decelerate,
                        duration: Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: 1500),
                        child: AppText(
                          "Empowering Your Financial Growth",
                          variant: AppTextVariant.headline2,
                          lineHeight: 1.2,
                          weight: AppTextWeight.semiBold,
                          colorType: AppTextColorType.tertiary,
                          // beginOffset: Offset(0, 30),
                          // duration: Duration(milliseconds: 1000),
                        ),
                      ),
                      SizedBox(height: 16),
                      FadeInUp(
                        curve: Curves.decelerate,
                        duration: Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: 2000),
                        child: AppText(
                          "Manage your money confidently using our intuitive tools and personalized insights.",
                          variant: AppTextVariant.bodyMedium,
                          lineHeight: 1.3,
                          weight: AppTextWeight.medium,
                          colorType: AppTextColorType.secondary,
                          // duration: Duration(milliseconds: 1000),
                          // delay: Duration(milliseconds: 0),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: FadeInUp(
                      curve: Curves.decelerate,
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 2500),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Get Started',
                              isLoading: false,
                              variant: AppButtonVariant.primary,
                              size: AppButtonSize.large,
                              onPressed:
                                  () => Get.to(
                                () => const PhoneNumberInputScreen(),
                                transition: Transition.rightToLeft,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
