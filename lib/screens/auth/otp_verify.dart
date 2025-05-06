import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/key_pad.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/auth/phone_number.dart';

class PhoneOTPVerifyScreen extends StatefulWidget {
  const PhoneOTPVerifyScreen({super.key});

  @override
  State<PhoneOTPVerifyScreen> createState() => _PhoneOTPVerifyScreenState();
}

class _PhoneOTPVerifyScreenState extends State<PhoneOTPVerifyScreen> {
  // Controllers for each digit input
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Focus nodes to manage focus transition
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  // Current active input index
  int _currentIndex = 0;

  // Complete OTP code
  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  void initState() {
    super.initState();
    // Disable keyboard for all text fields
    for (var node in _focusNodes) {
      node.canRequestFocus = false;
    }
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Handle digit input from keypad
  void _handleKeyPressed(int digit) {
    if (_currentIndex < 6) {
      setState(() {
        _controllers[_currentIndex].text = digit.toString();
        if (_currentIndex < 5) {
          _currentIndex++;
        }
      });
    }
  }

  // Handle backspace from keypad
  void _handleBackspace() {
    if (_currentIndex >= 0) {
      setState(() {
        if (_controllers[_currentIndex].text.isNotEmpty) {
          _controllers[_currentIndex].clear();
        } else if (_currentIndex > 0) {
          _currentIndex--;
          _controllers[_currentIndex].clear();
        }
      });
    }
  }

  // Verify OTP and proceed
  void _verifyOTP() {
    if (_otpCode.length == 6) {
      // Here you would typically verify the OTP with your backend
      // For now, just proceed to the next screen
      Get.to(() => const PhoneNumberInputScreen());
    } else {
      // Show a snackbar or dialog indicating incomplete OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit OTP'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Handle resend OTP functionality
  void _resendOTP() {
    // Here you would implement the logic to resend OTP
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left),
            ),
            AppText("OTP Verification", variant: AppTextVariant.headline6),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Lottie.asset('assets/lottie/lock.json'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      AppText(
                        "Enter 6 digit verification code \nsent to your phone number",
                        variant: AppTextVariant.headline4,
                        lineHeight: 1.3,
                        colorType: AppTextColorType.secondary,
                        weight: AppTextWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            readOnly: true, // Prevent keyboard from showing
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.lightTheme['text']!['primary']!,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: primaryInputDecoration("", isOTP: true),
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      AppText(
                        "Didn't get a code?",
                        variant: AppTextVariant.bodyMedium,
                        lineHeight: 1.3,
                        colorType: AppTextColorType.muted,
                        weight: AppTextWeight.bold,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _resendOTP,
                        child: AppText(
                          "Resend Code",
                          variant: AppTextVariant.bodyMedium,
                          lineHeight: 1.3,
                          colorType: AppTextColorType.secondary,
                          weight: AppTextWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  KeyPad(
                    onKeyPressed: _handleKeyPressed,
                    onBackspace: _handleBackspace,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Continue',
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.large,
                          onPressed: _verifyOTP,
                        ),
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
