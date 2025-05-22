import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/screens/fetch-holdings/layouts/layouts.dart';
import 'package:nwt_app/screens/fetch-holdings/types/mf_fetching.dart';
import 'package:nwt_app/services/mf_onboarding/mf_onboarding_service.dart';
import 'package:sms_autofill/sms_autofill.dart';

class MutualFundHoldingsJourneyScreen extends StatefulWidget {
  const MutualFundHoldingsJourneyScreen({super.key});

  @override
  State<MutualFundHoldingsJourneyScreen> createState() =>
      _MutualFundHoldingsJourneyScreenState();
}

class _MutualFundHoldingsJourneyScreenState
    extends State<MutualFundHoldingsJourneyScreen>
    with CodeAutoFill, TickerProviderStateMixin {
  // Services
  final MFOnboardingService _mfOnboardingService = MFOnboardingService();

  // CAS details from API response
  DecryptedCASDetails? _casDetails;
  String _token = '';

  // Current step in the journey
  int _currentStep = 0;
  bool _isAnimating = false;
  bool _isLoading = false;

  // OTP related variables
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _activeFieldIndex = 0;
  final List<bool> _fieldFilled = List.generate(6, (index) => false);

  // Animation controllers for OTP fields
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  // Timer for resend OTP
  Timer? _resendTimer;
  int _timeLeft = 60;
  bool _canResendOTP = false;

  // Get the complete OTP code
  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers for OTP fields
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

    // Set up SMS listener for OTP step when it's shown
    if (_currentStep == 1) {
      _setupSmsListener();
      _startResendTimer();
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
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
    cancel(); // Cancel SMS auto-fill
    super.dispose();
  }

  // Method to set up SMS listener for OTP auto-fill
  void _setupSmsListener() async {
    try {
      await SmsAutoFill().getAppSignature;
      listenForCode();
    } catch (e) {
      debugPrint('Error setting up SMS listener: $e');
    }
  }

  // Called when SMS code is received
  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      _autoFillOtp(code!);
    }
  }

  // Auto-fill OTP fields with animation - without auto-verification
  void _autoFillOtp(String otp) {
    if (otp.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].clear();
        _fieldFilled[i] = false;
      }

      for (int i = 0; i < 6; i++) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          if (mounted) {
            setState(() {
              _controllers[i].text = otp[i];
              _fieldFilled[i] = true;
              _activeFieldIndex = i;

              _animationControllers[i].forward().then((_) {
                if (mounted) {
                  _animationControllers[i].reverse();
                }
              });
            });
          }

          if (i == 5) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                for (var controller in _animationControllers) {
                  controller.forward().then((_) {
                    if (mounted) {
                      controller.reverse();
                    }
                  });
                }
              }
              // Removed auto-verification
              // User must click the verify button manually
            });
          }
        });
      }
    }
  }

  // Start resend timer for OTP
  void _startResendTimer() {
    if (mounted) {
      setState(() {
        _canResendOTP = false;
        _timeLeft = 60;
      });
    }
    _resendTimer?.cancel();
    if (mounted) {
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
  }

  // Method to receive CAS details from StartingJourneyLayout
  void setCasDetails(DecryptedCASDetails? details, String token) {
    if (mounted) {
      setState(() {
        _casDetails = details;
        _token = token;
      });

      if (details != null) {
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 5000), () {
            if (mounted) {
              _goToNextStep();
            }
          });
        }
      }
    }
  }

  // Handle OTP verification
  Future<void> _verifyOTP(String otp) async {
    if (_isLoading || _casDetails == null) return;

    // Set loading state to true for the Continue button
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Verify OTP
    final success = await _mfOnboardingService.verifyOTP(
      token: _token,
      casDetails: _casDetails!,
      otp: otp,
      onLoading: (isLoading) {
        // Keep the loading state true during the entire verification process
        // We'll only update it when explicitly needed
      },
      onError: (message) {
        if (mounted) {
          Get.snackbar(
            'Error',
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        }
      },
    );

    // If verification failed, reset loading state and return
    if (!success) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      // Show success message
      Get.snackbar(
        'Success',
        'OTP verified successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );

      // Update user's mutual fund verification status
      // await _updateMutualFundVerificationStatus();

      // Move to loading layout (step 2)
      // We keep the loading state true during the transition
      _goToNextStep();

      // Wait for exactly 4 seconds and then navigate to dashboard
      // Future.delayed(const Duration(seconds: 4), () {
      //   if (mounted) {
      //     // Navigate to dashboard using Get.offAll
      //     Get.offAll(() => const Dashboard());
      //   }
      // });
    }
  }

  // Resend OTP
  void _resendOTP() {
    if (_canResendOTP && !_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });

      // Simulate OTP resend
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            // Reset OTP fields
            for (int i = 0; i < 6; i++) {
              _controllers[i].clear();
              _fieldFilled[i] = false;
            }
            _activeFieldIndex = 0;
          });
          _startResendTimer();
        }
      });
    }
  }

  // Navigate to a specific step with animation
  void _navigateToStep(int step) {
    if (_isAnimating ||
        step == _currentStep ||
        step < 0 ||
        step > 2 ||
        !mounted)
      return;

    if (mounted) {
      setState(() {
        _isAnimating = true;
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentStep = step;
          _isAnimating = false;
        });

        // If we're now on the OTP step, set up the SMS listener
        if (_currentStep == 1) {
          _setupSmsListener();
          _startResendTimer();
        }
      }
    });
  }

  // Go to next step with animation
  void _goToNextStep() {
    if (_currentStep < 2) {
      _navigateToStep(_currentStep + 1);
    }
  }

  // Go to previous step with animation
  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _navigateToStep(_currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildCurrentStep()));
  }

  // Build the current step based on _currentStep
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return StartingJourneyLayout(
          isAnimating: _isAnimating,
          onNext: _goToNextStep,
          onCasDetailsReceived: setCasDetails,
        );
      case 1:
        return OtpVerificationLayout(
          isAnimating: _isAnimating,
          isLoading: _isLoading,
          canResendOTP: _canResendOTP,
          timeLeft: _timeLeft,
          activeFieldIndex: _activeFieldIndex,
          fieldFilled: _fieldFilled,
          controllers: _controllers,
          focusNodes: _focusNodes,
          scaleAnimations: _scaleAnimations,
          otpCode: _otpCode,
          onVerifyOTP: _verifyOTP,
          onResendOTP: _resendOTP,
          onPrevious: _goToPreviousStep,
          onNext: _goToNextStep,
          casDetails:
              _casDetails, // Pass the CAS details to the OTP verification layout
        );
      case 2:
        return LoadingLayout(onPrevious: _goToPreviousStep);
      default:
        return StartingJourneyLayout(
          isAnimating: _isAnimating,
          onNext: _goToNextStep,
          onCasDetailsReceived: setCasDetails,
        );
    }
  }
}
