import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/types/auth/otp.dart';
import 'package:nwt_app/types/auth/pan_verfication.dart';
import 'package:nwt_app/types/auth/user.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/utils/network_api_helper.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AuthService {

  Future<GenerateOtpResponse?> generateOTP({
    required String phoneNumber,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final appSignature = await SmsAutoFill().getAppSignature;
      final response = await NetworkAPIHelper().post(ApiURLs.GENERATE_OTP, {
        "phonenumber": phoneNumber,
        'apphash': kIsWeb ? 'nwt-app' : appSignature,
      }); 
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info('Generate OTP Response: ${responseData.toString()}', tag: 'AuthService');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return GenerateOtpResponse.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Generate OTP Error', error: e, tag: 'AuthService');
      return null;
    } finally {
      onLoading(false);
    }
  }

  Future<VerifyOtpResponse?> verifyOTP({
    required String phoneNumber,
    required String otp,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().post(ApiURLs.VERIFY_OTP, {
        "phonenumber": phoneNumber,
        "otp": otp,
      });

      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info('Verify OTP Response: ${responseData.toString()}', tag: 'AuthService');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final verifyResponse = VerifyOtpResponse.fromJson(responseData);

          if (verifyResponse.data?.token != null) {
            StorageService.write(
              StorageKeys.AUTH_TOKEN_KEY,
              verifyResponse.data?.token,
            );
          }
 
          return verifyResponse;
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Verify OTP Error', error: e, tag: 'AuthService');
      return null;
    } finally {
      onLoading(false);
    }
  }

  String? getAuthToken() {
    return StorageService.read(StorageKeys.AUTH_TOKEN_KEY);
  }

  bool isLoggedIn() {
    return StorageService.hasKey(StorageKeys.AUTH_TOKEN_KEY);
  }

  void logout() {
    StorageService.remove(StorageKeys.AUTH_TOKEN_KEY);
    final userController = Get.find<UserController>();
    userController.clearUserData();
  }

  Future<UserDataResponse?> getUserProfile({
    required Function(bool) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await NetworkAPIHelper().get(ApiURLs.GET_USER_PROFILE);
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info('Get User Profile Response: ${responseData.toString()}', tag: 'AuthService');

        // Check if the response status code is successful (200 or 201)
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Create and return the UserDataResponse object from the JSON
          return UserDataResponse.fromJson(responseData);
        }
      } else {
        AppLogger.info('Get User Profile Response: ${response?.body.toString()}', tag: 'AuthService');
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Get User Profile Error', error: e, stackTrace: stackTrace, tag: 'AuthService');
      return null;
    } finally {
      onLoading(false);
    }
  }
  
  Future<PanVerificationResponse?> verifyPanCard({
    required String panNumber,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      // Make a POST request to the PAN verification endpoint
      final response = await NetworkAPIHelper().post(ApiURLs.PAN_CARD_VERIFICATION, {
        "pannumber": panNumber,
      });
      
      if (response != null) {
        final responseData = jsonDecode(response.body);
        AppLogger.info('PAN Verification Response: ${responseData.toString()}', tag: 'AuthService');
        
        // Check if the response status code is successful (200 or 201)
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Create the PanVerificationResponse object from the JSON
          final verificationResponse = PanVerificationResponse.fromJson(responseData);
          
          // If verification was successful, refresh the user profile
          if (verificationResponse.success) {
            AppLogger.info('PAN verification successful, refreshing user profile', tag: 'AuthService');
            
            // Fetch updated user profile
            await getUserProfile(onLoading: (loading) {
              // Don't update the loading state here to avoid UI flicker
              // The parent loading state is still active
            });
          }
          
          return verificationResponse;
        }
      } else {
        AppLogger.info('PAN Verification Response: ${response?.body.toString()}', tag: 'AuthService');
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('PAN Verification Error', error: e, stackTrace: stackTrace, tag: 'AuthService');
      return null;
    } finally {
      onLoading(false);
    }
  }
}
