import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/theme_controller.dart';
import 'package:nwt_app/screens/auth/otp_verify.dart';
import 'package:nwt_app/services/auth/auth.dart';
import 'package:nwt_app/utils/validators.dart';
import 'package:nwt_app/widgets/common/animated_error_message.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/key_pad.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

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

  Future<void> _generateOTP() async {
    // Clear any previous error messages
    setState(() {
      _errorMessage = null;
    });

    // Validate phone number
    if (_phoneController.text.length != 10) {
      setState(() {
        _errorMessage = "Please enter a valid 10-digit phone number";
      });
      return;
    }

    final response = await AuthService().generateOTP(
      phoneNumber: _phoneController.text,
      onLoading: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
    );

    if (response != null) {
      if (response.success) {
        Get.to(
          () => PhoneOTPVerifyScreen(phoneNumber: _phoneController.text),
          transition: Transition.rightToLeft,
        );
      } else {
        // Show error message from the server
        setState(() {
          _errorMessage = response.message;
        });
      }
    } else {
      setState(() {
        _errorMessage = "Failed to connect to server. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ThemeController>(
        builder: (themeController) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/onboarding/stars.svg',
                        colorFilter: ColorFilter.mode(
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          AppText(
                            "Welcome to \npivot.money",
                            variant: AppTextVariant.headline1,
                            lineHeight: 1.3,
                            weight: AppTextWeight.bold,
                            colorType: AppTextColorType.primary,
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            "Manage all your finances in one place.",
                            variant: AppTextVariant.bodyMedium,
                            lineHeight: 1.3,
                            weight: AppTextWeight.medium,
                            colorType: AppTextColorType.secondary,
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
                                weight: AppTextWeight.semiBold,
                                colorType: AppTextColorType.primary,
                              ),
                              const SizedBox(height: 14),
                            ],
                          ),
                          Column(
                            children: [
                              AppInputField(
                                readOnly: false,
                                controller: _phoneController,
                                hintText: "Enter your phone number",
                                // labelText: "Phone Number",
                                validator: AppValidators.validatePhone,
                                keyboardType: TextInputType.none,
                                type: AppInputFieldType.phone,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 20),
                              AnimatedErrorMessage(errorMessage: _errorMessage),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      text: 'Send OTP',
                                      variant: AppButtonVariant.primary,
                                      size: AppButtonSize.large,
                                      onPressed: _generateOTP,
                                      isLoading: _isLoading,
                                      isDisabled:
                                          _isLoading ||
                                          _phoneController.text.length != 10,
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
                          Container(
                            margin: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 16,
                            ),
                          ),
                        ],
                      ),
                    ],
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
