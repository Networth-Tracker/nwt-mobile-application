import 'package:get/get.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/screens/auth/pan_card_verification.dart';
import 'package:nwt_app/screens/auth/phone_number.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/screens/onboarding/onboarding.dart';
import 'package:nwt_app/services/auth/auth.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/types/auth/user.dart';
import 'package:nwt_app/utils/logger.dart';

class AuthFlow {
  final AuthService _authService = AuthService();
  final UserController _userController = Get.find<UserController>();

  /// Handles the flow after successful OTP verification
  /// Fetches the latest user profile and redirects based on verification status
  Future<void> handlePostOtpVerification() async {
    AppLogger.info('Handling post-OTP verification flow', tag: 'AuthFlow');

    // Fetch the latest user profile
    await _userController.fetchUserProfile(
      onLoading: (loading) {
        // Handle loading silently
      },
    );

    // Check if user data is available
    if (_userController.userData != null) {
      final user = _userController.userData!;

      // Check all verification statuses at once
      if (user.isverified && user.ispanverified) {
        // All verifications are complete, go directly to dashboard
        AppLogger.info(
          'User is fully verified, redirecting to dashboard',
          tag: 'AuthFlow',
        );
        _navigateToDashboard();
      } else {
        // Handle verification status normally
        _handleUserVerificationStatus(user);
      }
    } else {
      // If user data couldn't be fetched, redirect to onboarding
      AppLogger.info(
        'Failed to fetch user data after OTP verification, redirecting to onboarding',
        tag: 'AuthFlow',
      );
      _navigateToOnboarding();
    }
  }

  Future<void> initialize() async {
    final token = StorageService.read(StorageKeys.AUTH_TOKEN_KEY);
    AppLogger.info(token.toString(), tag: 'AuthFlow');
    if (token == null) {
      AppLogger.info(
        'No auth token found, redirecting to onboarding',
        tag: 'AuthFlow',
      );
      _navigateToOnboarding();
      return;
    }

    final userData = await _userController.fetchUserProfile(
      onLoading: (loading) {
        // Handle loading silently for initial fetch
      },
    );
    if (userData != null) {
      AppLogger.info(
        'User data found, handling verification status',
        tag: 'AuthFlow',
      );
      _handleUserVerificationStatus(userData.data.user);
    } else {
      AppLogger.info(
        'Failed to fetch user data, redirecting to onboarding',
        tag: 'AuthFlow',
      );
      _navigateToOnboarding();
    }
  }

  void _handleUserVerificationStatus(User user) {
    if (!user.isverified) {
      AppLogger.info(
        'User not verified, redirecting to phone verification',
        tag: 'AuthFlow',
      );
      _navigateToPhoneVerification();
      return;
    }

    if (!user.ispanverified) {
      AppLogger.info(
        'PAN not verified, redirecting to PAN verification',
        tag: 'AuthFlow',
      );
      _navigateToPanVerification();
      return;
    }

    // if (!user.isonboardingcompleted) {
    //   AppLogger.info(
    //     'Profile not completed, redirecting to user profile',
    //     tag: 'AuthFlow',
    //   );
    //   _navigateToUserProfile();
    //   return;
    // }

    AppLogger.info(
      'All verifications complete, redirecting to dashboard',
      tag: 'AuthFlow',
    );
    _navigateToDashboard();
  }

  void _navigateToOnboarding() {
    Get.offAll(
      () => const OnboardingScreen(),
      transition: Transition.rightToLeft,
    );
  }

  void _navigateToPhoneVerification() {
    Get.offAll(
      () => const PhoneNumberInputScreen(),
      transition: Transition.rightToLeft,
    );
  }

  void _navigateToPanVerification() {
    Get.offAll(
      () => const PanCardVerification(),
      transition: Transition.rightToLeft,
    );
  }

  // void _navigateToUserProfile() {
  //   Get.offAll(
  //     () => const UserProfileScreen(),
  //     transition: Transition.rightToLeft,
  //   );
  // }

  void _navigateToDashboard() {
    Get.offAll(() => const Dashboard(), transition: Transition.rightToLeft);
  }

  void logout() {
    _authService.logout();
    _navigateToOnboarding();
  }
}
