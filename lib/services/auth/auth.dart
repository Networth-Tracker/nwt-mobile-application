import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/controllers/user_controller.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/types/auth/otp.dart';
import 'package:nwt_app/types/auth/user.dart';
import 'package:nwt_app/utils/api_helpers.dart';

class AuthService {
  final APIHelper _apiHelper = APIHelper();

  Future<GenerateOtpResponse?> generateOTP({
    required String phoneNumber,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await _apiHelper.post(ApiURLs.GENERATE_OTP, {
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

  Future<VerifyOtpResponse?> verifyOTP({
    required String phoneNumber,
    required int otp,
    required Function(bool isLoading) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await _apiHelper.post(ApiURLs.VERIFY_OTP, {
        "phoneNumber": phoneNumber,
        "otp": otp,
      });
      
      if (response != null) {
        final responseData = jsonDecode(response.body);
        developer.log('Verify OTP Response: ${responseData.toString()}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          final verifyResponse = VerifyOtpResponse.fromJson(responseData);
          
          if (verifyResponse.data?.token != null) {
            StorageService.write(StorageKeys.AUTH_TOKEN_KEY, verifyResponse.data?.token);
          }
          
          return verifyResponse;
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

  Future<UserProfileUpdatedResponse?> updateProfile({
    required String firstName,
    required String lastName,
    required DateTime dob,
    required Function(bool) onLoading,
  }) async {
    onLoading(true);
    try {
      print({
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob.toIso8601String(),
      });
      final response = await _apiHelper.patch(ApiURLs.UPDATE_USER_PROFILE, {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob.toIso8601String(),
      });
      
      if (response != null) {
        final responseData = jsonDecode(response.body);
        developer.log('Update Profile Response: ${responseData.toString()}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Get updated user profile without showing loading state again
          final userProfile = await getUserProfile(onLoading: onLoading);
          // if (userProfile != null) {
          //   AuthFlowService.handleAuthFlow(userProfile);
          // }
          return UserProfileUpdatedResponse.fromJson(responseData);
        }
      }else{
        print('Update Profile Response failed');
      }
      return null;
    } catch (e, subTrace) {
      developer.log('Update Profile Error: ${e.toString()}');
      developer.log('Update Profile Error: ${subTrace.toString()}');
      return null;
    } finally {
      onLoading(false);
    }
  }

  Future<UserDataResponse?> getUserProfile({
    required Function(bool) onLoading,
  }) async {
    onLoading(true);
    try {
      final response = await APIHelper().get(ApiURLs.USER_PROFILE);
      if (response != null) {
        final responseData = jsonDecode(response.body);
        developer.log('Get User Profile Response: ${responseData.toString()}');
        
        if (response.statusCode == 200 && responseData['success'] == true) {
          return UserDataResponse.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (e, subTrace) {
      developer.log('Get User Profile Error: ${e.toString()}');
      developer.log('Get User Profile Error: ${subTrace.toString()}');
      return null;
    } finally {
      onLoading(false);
    }
  }
}