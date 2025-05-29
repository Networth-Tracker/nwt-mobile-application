import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/fetch-holdings/mf_fetching.dart';
import 'package:nwt_app/services/auth/auth.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/validators.dart';
import 'package:nwt_app/widgets/common/animated_error_message.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class PanCardVerification extends StatefulWidget {
  const PanCardVerification({super.key});

  @override
  State<PanCardVerification> createState() => _PanCardVerificationState();
}

class _PanCardVerificationState extends State<PanCardVerification> {
  final TextEditingController _panController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TextInputType _currentKeyboardType = TextInputType.text;
  bool _isLoading = false;
  String? _errorMessage;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _panController.addListener(() {
      final text = _panController.text;
      final newType =
          (text.length >= 5 && text.length < 9)
              ? TextInputType.number
              : TextInputType.text;

      if (_currentKeyboardType != newType) {
        setState(() {
          _currentKeyboardType = newType;
        });

        _focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 50), () {
          _focusNode.requestFocus();
        });
      }
    });
  }

  // Method to verify PAN card
  void _verifyPanCard() async {
    // Clear any previous error messages
    setState(() {
      _errorMessage = null;
    });

    // Validate PAN number format
    if (_panController.text.length != 10 ||
        !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(_panController.text)) {
      setState(() {
        _errorMessage = "Please enter a valid PAN number";
      });
      return;
    }

    // Call the PAN verification service
    try {
      final response = await _authService.verifyPanCard(
        panNumber: _panController.text,
        onLoading: (isLoading) {
          setState(() {
            _isLoading = isLoading;
          });
        },
      );

      // Check response
      if (response != null) {
        AppLogger.info(
          'PAN Verification completed: ${response.message}',
          tag: 'PanCardVerification',
        );

        if (response.success) {
          // Clear any error messages on success
          setState(() {
            _errorMessage = null;
          });

          // Navigate to dashboard immediately
          Get.to(
            () => const MutualFundHoldingsJourneyScreen(),
            transition: Transition.rightToLeft,
          );
        } else {
          // Show error message from the server
          setState(() {
            _errorMessage = response.message;
          });
        }
      } else {
        // Handle null response (service error)
        setState(() {
          _errorMessage = "Verification failed. Please try again.";
        });
      }
    } catch (e) {
      AppLogger.error(
        'PAN Verification Error',
        error: e,
        tag: 'PanCardVerification',
      );
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    }
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
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: 0,
              child: GestureDetector(
                // onTap: () => Navigator.pop(context),
                child: const Icon(Icons.chevron_left),
              ),
            ),
            AppText(
              "PAN Verification",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizing.scaffoldHorizontalPadding,
            right: AppSizing.scaffoldHorizontalPadding,
            // bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                        decoration: InputDecoration(
                          hintText: 'Enter your PAN number',
                        ),
                        focusNode: _focusNode,
                        keyboardType: _currentKeyboardType,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'[^A-Z0-9]'),
                          ),
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
                              if (!RegExp(
                                r'^[A-Z]{5}[0-9]{1,4}$',
                              ).hasMatch(text)) {
                                return oldValue;
                              }
                            } else {
                              // Last char must be letter
                              if (!RegExp(
                                r'^[A-Z]{5}[0-9]{4}[A-Z]$',
                              ).hasMatch(text)) {
                                return oldValue;
                              }
                            }
                            return newValue;
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedErrorMessage(errorMessage: _errorMessage),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizing.scaffoldHorizontalPadding,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Verify',
                variant: AppButtonVariant.primary,
                isLoading: _isLoading,
                size: AppButtonSize.large,
                isDisabled: _isLoading || _panController.text.length != 10,
                onPressed: _verifyPanCard,
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
