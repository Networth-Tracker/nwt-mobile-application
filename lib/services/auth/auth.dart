import 'dart:convert';
import 'dart:developer' as developer;

import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/types/auth/otp.dart';
import 'package:nwt_app/utils/api_helpers.dart';

class AuthService {
  final APIHelper _apiHelper = APIHelper();

  // Generate OTP
  Future<GenerateOtpResponse?> generateOTP({
    required String phoneNumber,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await _apiHelper.post(ApiURLs.generateOTP, {
        "phoneNumber": phoneNumber,
      });
      if (response != null) {
        final responseData = jsonDecode(response.body);
        developer.log('Generate OTP Response: ${responseData.toString()}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          return GenerateOtpResponse.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      developer.log('Generate OTP Error: ${e.toString()}');
      return null;
    } finally {
      onLoading(false);
    }
  }

  // Verify OTP
  Future<VerifyOtpResponse?> verifyOTP({
    required String phoneNumber,
    required int otp,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await _apiHelper.post(ApiURLs.verifyOTP, {
        "phoneNumber": phoneNumber,
        "otp": otp,

      });
      if (response != null) {
        final responseData = jsonDecode(response.body);
        developer.log('Verify OTP Response: ${responseData.toString()}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          return VerifyOtpResponse.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      developer.log('Verify OTP Error: ${e.toString()}');
      return null;
    } finally {
      onLoading(false);
    }
  }
}