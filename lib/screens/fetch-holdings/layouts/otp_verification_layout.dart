import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/screens/fetch-holdings/types/mf_fetching.dart';
import 'package:nwt_app/widgets/common/animated_error_message.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/key_pad.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationLayout extends StatefulWidget {
  final bool isAnimating;
  final bool canResendOTP;
  final int timeLeft;
  final int activeFieldIndex;
  final List<bool> fieldFilled;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final List<Animation<double>> scaleAnimations;
  final String otpCode;
  final Function(String) onVerifyOTP;
  final VoidCallback onResendOTP;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final DecryptedCASDetails? casDetails;
  final String? errorMessage;

  const OtpVerificationLayout({
    super.key,
    required this.isAnimating,
    required this.canResendOTP,
    required this.timeLeft,
    required this.activeFieldIndex,
    required this.fieldFilled,
    required this.controllers,
    required this.focusNodes,
    required this.scaleAnimations,
    required this.otpCode,
    required this.onVerifyOTP,
    required this.onResendOTP,
    required this.onPrevious,
    required this.onNext,
    this.casDetails,
    this.errorMessage,
  });

  @override
  State<OtpVerificationLayout> createState() => _OtpVerificationLayoutState();
}

class _OtpVerificationLayoutState extends State<OtpVerificationLayout>
    with TickerProviderStateMixin, CodeAutoFill {
  // Method to handle focus changes between OTP fields
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _activeFieldIndex = 0;

  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  final List<bool> _fieldFilled = List.generate(6, (index) => false);

  Timer? _resendTimer;
  int _timeLeft = 60;
  bool _canResendOTP = true;

  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  void initState() {
    super.initState();

    _animationControllers = List.generate(
      6,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _scaleAnimations =
        _animationControllers.map((controller) {
          return Tween<double>(begin: 1.0, end: 1.1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    _startResendTimer();

    // Initialize SMS listener for OTP auto-fill
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      print("SMS app signature: $signature");
    });
  }

  void _startResendTimer() {
    if (mounted) {
      setState(() {
        _canResendOTP = false;
        _timeLeft = 60;
      });
    }
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _canResendOTP = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onKeyPressed(int digit) {
    if (_activeFieldIndex >= 0 && _activeFieldIndex < 6 && mounted) {
      setState(() {
        _controllers[_activeFieldIndex].text = digit.toString();
        _fieldFilled[_activeFieldIndex] = true;

        _animationControllers[_activeFieldIndex].forward().then((_) {
          if (mounted) {
            _animationControllers[_activeFieldIndex].reverse();
          }
        });

        if (_activeFieldIndex < 5) {
          _activeFieldIndex++;
        }

        if (_controllers.every((controller) => controller.text.isNotEmpty)) {
          for (var controller in _animationControllers) {
            controller.forward().then((_) {
              if (mounted) {
                controller.reverse();
              }
            });
          }
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _verifyAndNavigate(_otpCode);
            }
          });
        }
      });
    }
  }

  void _onBackspace() {
    if (_activeFieldIndex >= 0 && _activeFieldIndex < 6 && mounted) {
      setState(() {
        if (_controllers[_activeFieldIndex].text.isNotEmpty) {
          _controllers[_activeFieldIndex].text = '';
          _fieldFilled[_activeFieldIndex] = false;
        } else if (_activeFieldIndex > 0) {
          _activeFieldIndex--;
          _controllers[_activeFieldIndex].text = '';
          _fieldFilled[_activeFieldIndex] = false;
        }
      });
    }
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6 && mounted) {
      setState(() {
        for (int i = 0; i < 6; i++) {
          if (i < code!.length) {
            _controllers[i].text = code![i];
            _fieldFilled[i] = true;
          }
        }

        // Animate all fields
        for (var controller in _animationControllers) {
          controller.forward().then((_) {
            if (mounted) {
              controller.reverse();
            }
          });
        }
      });

      // Auto verify after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _verifyAndNavigate(code!);
        }
      });
    }
  }

  // Handle verification and navigation
  void _verifyAndNavigate(String otpCode) {
    if (_isLoading) return; // Prevent multiple calls

    setState(() {
      _isLoading = true;
    });

    // Call the verification function and let the parent handle navigation
    // The parent will only navigate to the next screen on successful verification
    widget.onVerifyOTP(otpCode);

    // Set a timeout to reset loading state if no response after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _resendTimer?.cancel();
    cancel(); // Cancel SMS listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isAnimating
        ? FadeOutUp(
          duration: const Duration(milliseconds: 500),
          child: _buildContent(context),
        )
        : FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: _buildContent(context),
        );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizing.scaffoldHorizontalPadding,
            right: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Lottie.asset('assets/lottie/lock.json'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText(
                          "Enter 6 digit verification code \nsent to phone number",
                          variant: AppTextVariant.headline4,
                          lineHeight: 1.3,
                          colorType: AppTextColorType.secondary,
                          weight: AppTextWeight.bold,
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          // onTap: () {
                          //   Get.back();
                          // },
                          child: AppText(
                            "Edit Number",
                            variant: AppTextVariant.bodyMedium,
                            lineHeight: 1.3,
                            colorType: AppTextColorType.muted,
                            weight: AppTextWeight.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                for (var node in _focusNodes) {
                                  node.unfocus();
                                }
                                _activeFieldIndex = index;
                              });
                            },

                            child: AnimatedBuilder(
                              animation: _scaleAnimations[index],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimations[index].value,
                                  child: child,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: TextFormField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  readOnly: true,
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        _fieldFilled[index]
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : context
                                                .textThemeColors
                                                .primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    filled: true,
                                    fillColor:
                                        _fieldFilled[index]
                                            ? (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.1)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.05))
                                            : (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.darkInputBackground
                                                : AppColors
                                                    .lightInputPrimaryBackground),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.darkInputBorder
                                                : AppColors
                                                    .lightInputPrimaryBorder,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color:
                                            _fieldFilled[index]
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                                : (_activeFieldIndex == index
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : Theme.of(
                                                          context,
                                                        ).brightness ==
                                                        Brightness.dark
                                                    ? AppColors.darkInputBorder
                                                    : AppColors
                                                        .lightInputPrimaryBorder),
                                        width:
                                            (_activeFieldIndex == index ||
                                                    _fieldFilled[index])
                                                ? 1.5
                                                : 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                        onTap:
                            (_canResendOTP && !_isLoading)
                                ? widget.onResendOTP
                                : null,
                        child: AppText(
                          _canResendOTP
                              ? "Resend Code"
                              : "Resend in $_timeLeft s",
                          variant: AppTextVariant.bodyMedium,
                          lineHeight: 1.3,
                          colorType:
                              _canResendOTP
                                  ? AppTextColorType.primary
                                  : AppTextColorType.muted,
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
                    onKeyPressed: _onKeyPressed,
                    onBackspace: _onBackspace,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizing.scaffoldHorizontalPadding,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedErrorMessage(errorMessage: widget.errorMessage),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Continue',
                    variant: AppButtonVariant.primary,
                    size: AppButtonSize.large,
                    isDisabled: _otpCode.length != 6 || _isLoading,
                    onPressed: () {
                      if (_otpCode.length == 6 && !_isLoading) {
                        _verifyAndNavigate(_otpCode);
                      }
                    },
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
