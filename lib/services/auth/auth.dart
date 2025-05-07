import 'dart:convert';
import 'dart:developer' as developer;
import 'package:nwt_app/constants/api.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/types/auth/otp.dart';
import 'package:nwt_app/utils/api_helpers.dart';

class AuthService {
  final APIHelper _apiHelper = APIHelper();

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
          final verifyResponse = VerifyOtpResponse.fromJson(responseData);
          
          if (verifyResponse.data?.token != null) {
            StorageService.write(StorageKeys.AUTH_TOKEN, verifyResponse.data?.token);
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
    return StorageService.read(StorageKeys.AUTH_TOKEN);
  }
  
  bool isLoggedIn() {
    return StorageService.hasKey(StorageKeys.AUTH_TOKEN);
  }
  
  void logout() {
    StorageService.remove(StorageKeys.AUTH_TOKEN);
  }
}