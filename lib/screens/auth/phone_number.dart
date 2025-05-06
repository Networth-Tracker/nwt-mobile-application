import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/key_pad.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/auth/otp_verify.dart';
import 'package:nwt_app/utils/api_helpers.dart';
import 'package:nwt_app/utils/validators.dart';
import 'package:http/http.dart' as http;

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final APIHelper _apiHelper = APIHelper(); // Create an instance of APIHelper
  bool _isLoading = false; // Loading state for the button

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

  // Function to generate OTP
  Future<void> _generateOTP() async {
    // Validate phone number
    final phoneValidator = AppValidators.validatePhone(_phoneController.text);
    if (phoneValidator != null) {
      // Show error message if phone number is invalid
      Get.snackbar(
        'Invalid Phone Number',
        phoneValidator,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare payload
      final Map<String, dynamic> payload = {
        "phoneNumber": _phoneController.text,
      };

      // Call API to generate OTP
      final http.Response? response = await _apiHelper.post(
        ApiURLs.generateOTP,
        payload,
      );
      log(response?.body ?? "");

      if (response != null) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Navigate to OTP verification screen
          Get.to(() => PhoneOTPVerifyScreen(
                phoneNumber: _phoneController.text,
              ));
        } else {
          // Show error message
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to generate OTP',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      } else {
        // Handle null response
        Get.snackbar(
          'Error',
          'Failed to connect to server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      // Handle exceptions
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
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
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: AppValidators.validatePhone,
                              controller: _phoneController,
                              keyboardType: TextInputType.none,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
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
                                  text: _isLoading ? 'Sending...' : 'Send OTP',
                                  variant: AppButtonVariant.primary,
                                  size: AppButtonSize.large,
                                  onPressed: _generateOTP, // Call _generateOTP when button is pressed
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