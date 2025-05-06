import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  AppText(
                    "Empowering Your Financial Growth",
                    variant: AppTextVariant.headline2,
                    lineHeight: 1.2,
                    weight: AppTextWeight.semiBold,
                    colorType: AppTextColorType.tertiary,
                  ),
                  SizedBox(height: 16),
                  AppText(
                    "Manage your money confidently using our intuitive tools and personalized insights.",
                    variant: AppTextVariant.bodyMedium,
                    lineHeight: 1.3,
                    weight: AppTextWeight.semiBold,
                    colorType: AppTextColorType.secondary,
                  ),
                ],
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Get Started',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      onPressed: () {},
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
