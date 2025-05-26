import 'dart:convert';

import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/screens/fetch-holdings/types/mf_fetching.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';

class MFOnboardingService {
  Future<MfCentralOtpResponse?> sendOTP({
    required Function(bool isLoading) onLoading,
    required Function(String message) onError,
  }) async {
    onLoading(true);

    try {
      final response = await NetworkAPIHelper().post(
        ApiURLs.MF_HOLDINGS_TOKEN,
        {},
      );
      AppLogger.info(
        'MF OTP Response: ${response?.body.toString()}',
        tag: 'MFOnboardingService',
      );
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'MF OTP Response: ${responseData.toString()}',
          tag: 'MFOnboardingService',
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return MfCentralOtpResponse.fromJson(responseData);
        } else {
          final errorMessage = responseData['message'] ?? 'Failed to send OTP';
          onError(errorMessage);
          return null;
        }
      }

      onError('Network error occurred');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'MF OTP Error',
        error: e,
        stackTrace: stackTrace,
        tag: 'MFOnboardingService',
      );
      onError('An unexpected error occurred');
      return null;
    } finally {
      onLoading(false);
    }
  }

  Future<MfCentralVerifyOtpResponse?> verifyOTP({
    required String token,
    required DecryptedCASDetails casDetails,
    required String otp,
    required Function(bool isLoading) onLoading,
    required Function(String message) onError,
  }) async {
    onLoading(true);

    try {
      final body = {
        "reqId": casDetails.reqId,
        "otpRef": casDetails.otpRef,
        "userSubjectReference": "",
        "clientRefNo": casDetails.clientRefNo,
        "enteredOtp": otp,
        "token": token,
      };

      AppLogger.info('Verifying MF OTP: $body', tag: 'MFOnboardingService');

      final response = await NetworkAPIHelper().post(
        ApiURLs.MF_HOLDINGS_VERIFY,
        body,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info(
          'MF OTP Verification Response: ${responseData.toString()}',
          tag: 'MFOnboardingService',
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return MfCentralVerifyOtpResponse.fromJson(responseData);
        } else {
          final errorMessage =
              responseData['message'] ?? 'Failed to verify OTP';
          onError(errorMessage);
          return MfCentralVerifyOtpResponse(status: 0, message: errorMessage);
        }
      }

      onError('Network error occurred');
      return MfCentralVerifyOtpResponse(
        status: 0,
        message: 'Network error occurred',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'MF OTP Verification Error',
        error: e,
        stackTrace: stackTrace,
        tag: 'MFOnboardingService',
      );
      onError('An unexpected error occurred');
      return MfCentralVerifyOtpResponse(
        status: 0,
        message: 'An unexpected error occurred',
      );
    } finally {
      onLoading(false);
    }
  }
}
