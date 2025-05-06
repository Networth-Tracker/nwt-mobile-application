import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/key_pad.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/auth/pan_card_verification.dart';
import 'package:http/http.dart' as http;
import 'package:nwt_app/utils/api_helpers.dart';

class PhoneOTPVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneOTPVerifyScreen({
    Key? key, 
    required this.phoneNumber,
  }) : super(key: key);

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
  
  // API Helper
  final APIHelper _apiHelper = APIHelper();
  
  // Loading state
  bool _isLoading = false;

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

  // Verify OTP and proceed with API call
  Future<void> _verifyOTP() async {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit OTP'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare payload
      final Map<String, dynamic> payload = {
        "phoneNumber": widget.phoneNumber,
        "otp": _otpCode,
      };

      // Call API to verify OTP
      final http.Response? response = await _apiHelper.post(
        ApiURLs.verifyOTP,
        payload,
      );

      if (response != null) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Extract token if available
          if (responseData.containsKey('token')) {
            // Save token to storage
            // await StorageService.write(
            //   StorageKeys.AUTH_TOKEN, 
            //   responseData['token']
            // );
          }
          
          // Navigate to PAN Card verification
          Get.to(() => const PanCardVerification());
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Failed to verify OTP'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Handle null response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to server'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle resend OTP functionality with API call
  Future<void> _resendOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare payload
      final Map<String, dynamic> payload = {
        "phoneNumber": widget.phoneNumber,
      };

      // Call API to generate OTP again
      final http.Response? response = await _apiHelper.post(
        ApiURLs.generateOTP,
        payload,
      );

      if (response != null) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Reset OTP input fields
          for (var controller in _controllers) {
            controller.clear();
          }
          _currentIndex = 0;
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP resent successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Failed to resend OTP'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Handle null response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to server'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
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
                      Expanded(
                        child: AppText(
                          "Enter 6 digit verification code \nsent to ${widget.phoneNumber}",
                          variant: AppTextVariant.headline4,
                          lineHeight: 1.3,
                          colorType: AppTextColorType.secondary,
                          weight: AppTextWeight.bold,
                        ),
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
                        onTap: _isLoading ? null : _resendOTP,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: _isLoading ? 'Verifying...' : 'Continue',
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