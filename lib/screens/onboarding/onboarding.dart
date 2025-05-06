import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/text_widget.dart';
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svgs/onboarding/onboarding_01.svg'),
                ],
              ),
              CustomTextWidget(
                text: "Empowering Your Financial Growth",
                fontSize: 28,
                fontWeight: FontWeight.w600,
                lineHeight: 1.3,
              ),
              SizedBox(height: 16),
              CustomTextWidget(
                text:
                    "Manage your money confidently using our intuitive tools and personalized insights.",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                lineHeight: 1.3,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Get Started',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.medium,
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
