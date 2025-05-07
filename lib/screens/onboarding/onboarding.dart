import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/common/theme_toggle.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/auth/phone_number.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Your Screen'),
      //   actions: [
      //     ThemeToggle(),
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 160),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/onboarding/onboarding_01.svg',
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  AnimatedAppText(
                    "Empowering Your Financial Growth",
                    variant: AppTextVariant.headline2,
                    lineHeight: 1.2,
                    weight: AppTextWeight.semiBold,
                    colorType: AppTextColorType.tertiary,
                    beginOffset: Offset(0, 30),
                    duration: Duration(milliseconds: 1000),
                  ),
                  SizedBox(height: 16),
                  AnimatedAppText(
                    "Manage your money confidently using our intuitive tools and personalized insights.",
                    variant: AppTextVariant.bodyMedium,
                    lineHeight: 1.3,
                    weight: AppTextWeight.semiBold,
                    colorType: AppTextColorType.secondary,
                    duration: Duration(milliseconds: 1000),
                    delay: Duration(milliseconds: 0),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Get Started',
                      isLoading: false,
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      onPressed:
                          () => Get.to(() => const PhoneNumberInputScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
