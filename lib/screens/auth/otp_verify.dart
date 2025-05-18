import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/key_pad.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/constants/theme.dart';
import 'package:nwt_app/services/auth/auth.dart';
import 'package:nwt_app/services/auth/auth_flow.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneOTPVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneOTPVerifyScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneOTPVerifyScreen> createState() => _PhoneOTPVerifyScreenState();
}

class _PhoneOTPVerifyScreenState extends State<PhoneOTPVerifyScreen>
    with CodeAutoFill, TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  int _activeFieldIndex = 0;

  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  final List<bool> _fieldFilled = List.generate(6, (index) => false);

  Timer? _resendTimer;
  int _timeLeft = 60;
  bool _canResendOTP = false;

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
    _setupSmsListener();
  }

  void _setupSmsListener() async {
    try {
      await SmsAutoFill().getAppSignature;
      listenForCode();
    } catch (e) {
      AppLogger.error(
        'Error setting up SMS listener',
        error: e,
        tag: 'OTPVerifyScreen',
      );
    }
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      _autoFillOtp(code!);
    }
  }

  void _autoFillOtp(String otp) {
    if (otp.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].clear();
        _fieldFilled[i] = false;
      }

      for (int i = 0; i < 6; i++) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          setState(() {
            _controllers[i].text = otp[i];
            _fieldFilled[i] = true;
            _activeFieldIndex = i;

            _animationControllers[i].forward().then((_) {
              _animationControllers[i].reverse();
            });
          });

          if (i == 5) {
            Future.delayed(const Duration(milliseconds: 300), () {
              for (var controller in _animationControllers) {
                controller.forward().then((_) {
                  controller.reverse();
                });
              }

              Future.delayed(const Duration(milliseconds: 1000), () {
                _verifyOTP();
              });
            });
          }
        });
      }
    }
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
    cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResendOTP = false;
      _timeLeft = 60;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _canResendOTP = true;
          timer.cancel();
        }
      });
    });
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _verifyOTP() async {
    if (_otpCode.length != 6) {
      return;
    }

    _setLoading(true);

    final response = await _authService.verifyOTP(
      phoneNumber: widget.phoneNumber,
      otp: _otpCode,
      onLoading: (isLoading) {
        _setLoading(isLoading);
      },
    );

    if (response != null && response.success) {
      // Use the AuthFlow to handle post-OTP verification flow
      // This will check all verification statuses and redirect accordingly
      final authFlow = AuthFlow();
      await authFlow.handlePostOtpVerification();
    } else {
      // Show error
      Get.snackbar(
        'Error',
        response?.message ?? 'Failed to verify OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _onKeyPressed(int digit) {
    if (_activeFieldIndex >= 0 && _activeFieldIndex < 6) {
      setState(() {
        _controllers[_activeFieldIndex].text = digit.toString();
        _fieldFilled[_activeFieldIndex] = true;

        _animationControllers[_activeFieldIndex].forward().then((_) {
          _animationControllers[_activeFieldIndex].reverse();
        });

        if (_activeFieldIndex < 5) {
          _activeFieldIndex++;
        }

        if (_controllers.every((controller) => controller.text.isNotEmpty)) {
          for (var controller in _animationControllers) {
            controller.forward().then((_) {
              controller.reverse();
            });
          }
          Future.delayed(const Duration(milliseconds: 300), () {
            _verifyOTP();
          });
        }
      });
    }
  }

  void _onBackspace() {
    if (_activeFieldIndex >= 0 && _activeFieldIndex < 6) {
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

  Future<void> _resendOTP() async {
    if (!_canResendOTP) return;

    final response = await _authService.generateOTP(
      phoneNumber: widget.phoneNumber,
      onLoading: _setLoading,
    );

    if (response != null && response.success) {
      for (var controller in _controllers) {
        controller.clear();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _startResendTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?.message ?? 'Failed to resend OTP'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 12),
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText(
                          "Enter 6 digit verification code \nsent to ${widget.phoneNumber}",
                          variant: AppTextVariant.headline4,
                          lineHeight: 1.3,
                          colorType: AppTextColorType.secondary,
                          weight: AppTextWeight.bold,
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
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
                            (_canResendOTP && !_isLoading) ? _resendOTP : null,
                        child: AppText(
                          _canResendOTP
                              ? "Resend Code"
                              : "Resend in $_timeLeft s",
                          variant: AppTextVariant.bodyMedium,
                          lineHeight: 1.3,
                          colorType:
                              _canResendOTP
                                  ? AppTextColorType.secondary
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
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Continue',
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
                isDisabled: _otpCode.length != 6 || _isLoading,
                onPressed: () {
                  if (_otpCode.length == 6 && !_isLoading) {
                    _verifyOTP();
                  }
                },
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
