import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/screens/fetch-holdings/layouts/layouts.dart';
import 'package:nwt_app/screens/fetch-holdings/types/mf_fetching.dart';
import 'package:nwt_app/services/assets/investments/investments.dart';
import 'package:nwt_app/services/global_storage.dart';
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

  // State variables
  DecryptedCASDetails? _casDetails;
  String _token = '';
  int _currentStep = 0;
  bool _isAnimating = false;
  String? _errorMessage;

  // OTP related
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<bool> _fieldFilled = List.generate(6, (index) => false);
  int _activeFieldIndex = 0;
  String get _otpCode => _controllers.map((c) => c.text).join();

  // Animation
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  // Timers
  Timer? _resendTimer;
  Timer? _startingJourneyTimer;
  Timer? _loadingMinimumTimer;

  // Timing control
  int _timeLeft = 60;
  bool _canResendOTP = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialJourney();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      6,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _scaleAnimations =
        _animationControllers
            .map(
              (controller) => Tween<double>(begin: 1.0, end: 1.2).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
            )
            .toList();
  }

  void _startInitialJourney() {
    // Show starting layout for 5 seconds
    _startingJourneyTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _navigateToStep(1); // Move to OTP layout
      }
    });
  }

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() {
    // Dispose all text editing controllers
    for (final controller in _controllers) {
      controller.dispose();
    }

    // Dispose all focus nodes
    for (final node in _focusNodes) {
      node.dispose();
    }

    // Dispose all animation controllers
    for (final controller in _animationControllers) {
      controller.dispose();
    }

    // Cancel all timers
    _resendTimer?.cancel();
    _startingJourneyTimer?.cancel();
    _loadingMinimumTimer?.cancel();

    // Cancel any pending auto-fill operations
    cancel();
  }

  // OTP Auto-fill
  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      _autoFillOtp(code!);
    }
  }

  void _autoFillOtp(String otp) {
    if (otp.length != 6) return;

    // Clear existing OTP
    for (int i = 0; i < 6; i++) {
      _controllers[i].clear();
      _fieldFilled[i] = false;
    }

    // Fill OTP with animation
    for (int i = 0; i < 6; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (!mounted) return;

        setState(() {
          _controllers[i].text = otp[i];
          _fieldFilled[i] = true;
          _activeFieldIndex = i;
          _animationControllers[i].forward().then(
            (_) => _animationControllers[i].reverse(),
          );
        });

        // Auto-submit when all fields are filled
        if (i == 5) {
          _verifyOTP(otp);
        }
      });
    }
  }

  // OTP Verification
  Future<void> _verifyOTP(String otp) async {
    if (_casDetails == null || otp.length != 6) return;

    setState(() => _errorMessage = null);

    try {
      final result = await _mfOnboardingService.verifyOTP(
        token: _token,
        casDetails: _casDetails!,
        otp: otp,
        onLoading: (_) {},
        onError: (message) => _handleVerificationError(message),
      );

      if (result?.success == true) {
        _handleVerificationSuccess(result!);
      } else {
        _handleVerificationError(result?.message);
      }
    } catch (e) {
      _handleVerificationError('An unexpected error occurred');
    }
  }

  Future<void> _handleVerificationSuccess(
    MfCentralVerifyOtpResponse result,
  ) async {
    if (!mounted) return;

    setState(() {
      _currentStep = 2; // Show loading layout
    });

    // Store savings data if available
    if (result.data != null) {
      StorageService.write(
        StorageKeys.MF_SAVINGS_KEY,
        result.data!.switchsavings ?? 0,
      );
    }

    // Start the minimum loading timer (7 seconds)
    await Future.delayed(const Duration(seconds: 7));

    if (mounted) {
      // Navigate to dashboard after minimum wait time
      Get.offAll(() => const Dashboard());
    }
  }

  void _handleVerificationError(String? message) {
    if (!mounted) return;

    setState(() {
      _errorMessage = message ?? 'Failed to verify OTP. Please try again.';
      _currentStep = 1; // Go back to OTP screen
    });
  }

  // Navigation
  void _navigateToStep(int step) {
    if (_isAnimating ||
        step == _currentStep ||
        step < 0 ||
        step > 2 ||
        !mounted) {
      return;
    }

    setState(() => _isAnimating = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        _currentStep = step;
        _isAnimating = false;
      });

      if (step == 1) {
        _setupSmsListener();
        _startResendTimer();
      }
    });
  }

  // SMS Listener
  Future<void> _setupSmsListener() async {
    try {
      await SmsAutoFill().getAppSignature;
      listenForCode();
    } catch (e) {
      debugPrint('SMS Listener Error: $e');
    }
  }

  // OTP Resend
  void _startResendTimer() {
    if (!mounted) return;

    setState(() {
      _timeLeft = 60;
      _canResendOTP = false;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

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

  Future<void> _resendOTP() async {
    if (!_canResendOTP || !mounted) return;

    setState(() => _errorMessage = null);

    try {
      final result = await _mfOnboardingService.sendOTP(
        onLoading: (_) {},
        onError: (message) => setState(() => _errorMessage = message),
      );

      if (mounted && result?.data.decryptedcasdetails != null) {
        setState(() {
          _casDetails = result!.data.decryptedcasdetails;
          _token = result.data.token ?? '';
        });
        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Failed to resend OTP');
      }
    }
  }

  // Step Navigation Helpers
  void _goToNextStep() {
    if (_currentStep < 2) _navigateToStep(_currentStep + 1);
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) _navigateToStep(_currentStep - 1);
  }

  void _skipToDashboard() => Get.offAll(() => const Dashboard());

  // UI Builders
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildCurrentStep()));
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return StartingJourneyLayout(
          isAnimating: _isAnimating,
          onNext: _goToNextStep,
          onSkip: _skipToDashboard,
          onCasDetailsReceived: (details, token) {
            if (details != null) {
              setState(() {
                _casDetails = details;
                _token = token;
              });
            }
          },
        );
      case 1:
        return OtpVerificationLayout(
          isAnimating: _isAnimating,
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
          errorMessage: _errorMessage,
          casDetails: _casDetails,
        );
      case 2:
        return LoadingLayout(onPrevious: _goToPreviousStep);
      default:
        return StartingJourneyLayout(
          isAnimating: _isAnimating,
          onNext: _goToNextStep,
          onSkip: _skipToDashboard,
          onCasDetailsReceived: (_, __) {},
        );
    }
  }
}
