import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isBiometricsAvailable() async {
    try {
      // Check if biometrics or secure lock screen is available
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = await _localAuth.isDeviceSupported();
      
      return canAuthenticateWithBiometrics && canAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      // First check if the device supports biometric authentication
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) {
        print('Biometric authentication not supported on this device');
        return true; // Allow access if biometrics is not supported
      }

      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) {
        print('Cannot check biometrics on this device');
        return true; // Allow access if cannot check biometrics
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print('Biometric authentication error: ${e.code} - ${e.message}');
      if (e.code == auth_error.notAvailable || 
          e.code == auth_error.notEnrolled || 
          e.message?.contains('dlopen') == true) {
        // Handle various platform-specific errors gracefully
        return true; // Allow access if biometrics encounters platform issues
      }
      return false;
    } catch (e) {
      print('Unexpected error during biometric authentication: $e');
      return true; // Allow access in case of unexpected errors
    }
  }
}
