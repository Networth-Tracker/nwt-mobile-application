import 'package:flutter/material.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/key_pad.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Welcome to \nNetworth Tracker",
                    variant: AppTextVariant.headline1,
                    lineHeight: 1.3,
                    weight: AppTextWeight.bold,
                    colorType: AppTextColorType.tertiary,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    "Manage all your finances in one place.",
                    variant: AppTextVariant.bodyMedium,
                    lineHeight: 1.3,
                    weight: AppTextWeight.medium,
                    colorType: AppTextColorType.tertiary,
                  ),
                ],
              ),
              Column(
                children: [
                  AppText(
                    "Enter your phone number",
                    variant: AppTextVariant.headline4,
                    lineHeight: 1.3,
                    weight: AppTextWeight.bold,
                    colorType: AppTextColorType.secondary,
                  ),
                  SizedBox(height: 16),
                ],
              ),
              Column(
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: AppColors.lightTheme['text']!['primary']!,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: primaryInputDecoration(
                      "Enter your phone number",
                    ),
                  ),
                ],
              ),
            //  KeyPad(),
              ],
          ),
        ),
      ),
    );
  }
}
