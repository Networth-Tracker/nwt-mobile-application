import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/screens/auth/user_pofile.dart';
import 'package:nwt_app/utils/validators.dart';

class PanCardVerification extends StatefulWidget {
  const PanCardVerification({super.key});

  @override
  State<PanCardVerification> createState() => _PanCardVerificationState();
}

class _PanCardVerificationState extends State<PanCardVerification> {
  final TextEditingController _panController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TextInputType _currentKeyboardType = TextInputType.text;

  @override
  void initState() {
    super.initState();
    _panController.addListener(() {
      final text = _panController.text;
      final newType = (text.length >= 5 && text.length < 9)
          ? TextInputType.number
          : TextInputType.text;

      if (_currentKeyboardType != newType) {
        setState(() {
          _currentKeyboardType = newType;
        });
        // Force keyboard change
        _focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 50), () {
          _focusNode.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    _panController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                        "Enter your PAN number to verify",
                        variant: AppTextVariant.bodyLarge,
                        lineHeight: 1.3,
                        colorType: AppTextColorType.secondary,
                        weight: AppTextWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: AppValidators.validatePanCard,
                    controller: _panController,
                    focusNode: _focusNode,
                    keyboardType: _currentKeyboardType,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.deny(RegExp(r'[^A-Z0-9]')),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isEmpty) return newValue;
                        if (newValue.text.length > 10) return oldValue;

                        // Allow backspace
                        if (newValue.text.length < oldValue.text.length) {
                          return newValue;
                        }

                        final text = newValue.text;
                        final position = text.length;

                        // Validate based on position
                        if (position <= 5) {
                          // First 5 chars must be letters
                          if (!RegExp(r'^[A-Z]{1,5}$').hasMatch(text)) {
                            return oldValue;
                          }
                        } else if (position <= 9) {
                          // After first 5 letters, next 4 must be numbers
                          if (!RegExp(r'^[A-Z]{5}[0-9]{1,4}$').hasMatch(text)) {
                            return oldValue;
                          }
                        } else {
                          // Last char must be letter
                          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(text)) {
                            return oldValue;
                          }
                        }
                        return newValue;
                      }),
                    ],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: primaryInputDecoration(
                      "Enter your PAN number",
                    ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Verify',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      onPressed: () => Get.to(() => const UserProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
