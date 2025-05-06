import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/key_pad.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/auth/otp_verify.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _onKeyPressed(int digit) {
    if (_phoneController.text.length < 10) {
      setState(() {
        _phoneController.text += digit.toString();
      });
    }
  }

  void _onBackspace() {
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        _phoneController.text = _phoneController.text.substring(
          0,
          _phoneController.text.length - 1,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset('assets/svgs/onboarding/stars.svg'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 100),
                      AppText(
                        "Welcome to \nNetworth Tracker",
                        variant: AppTextVariant.headline1,
                        lineHeight: 1.3,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.tertiary,
                      ),
                      const SizedBox(height: 4),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          AppText(
                            "Enter your phone number",
                            variant: AppTextVariant.headline4,
                            lineHeight: 1.3,
                            weight: AppTextWeight.bold,
                            colorType: AppTextColorType.secondary,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        children: [
                          AbsorbPointer(
                            // prevents keyboard from opening
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.none,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              forceErrorText: "Invalid Number",
                              decoration: primaryInputDecoration(
                                "Enter your phone number",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Send OTP',
                                  variant: AppButtonVariant.primary,
                                  size: AppButtonSize.large,
                                  onPressed: () => Get.to(() => const PhoneOTPVerifyScreen()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          KeyPad(
                            onKeyPressed: _onKeyPressed,
                            onBackspace: _onBackspace,
                          ),
                        ],
                      ),
                    ],
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
