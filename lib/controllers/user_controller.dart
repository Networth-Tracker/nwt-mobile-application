import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/services/auth/auth.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/types/auth/user.dart';
import 'package:nwt_app/utils/logger.dart';

class UserController extends GetxController {
  User? _userData;
  User? get userData => _userData;
  
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    initializeUserData();
  }

  Future<void> initializeUserData() async {
    final token = StorageService.read(StorageKeys.AUTH_TOKEN_KEY);
    AppLogger.info(token.toString(), tag: 'UserController');
    if (token != null) {
      await fetchUserProfile(
        onLoading: (loading) {
          // Handle loading silently for initial fetch
        },
      );
    } else {
      developer.log('Access token not found. User needs to login.');
    }
  }

  Future<UserDataResponse?> fetchUserProfile({
    required Function(bool) onLoading,
  }) async {
    final response = await _authService.getUserProfile(onLoading: onLoading);
    AppLogger.info(response.toString(), tag: 'UserController');
    if (response != null) {
      _userData = response.data.user;
      update();
      return response;
    }
    return null;
  }

  void clearUserData() {
    _userData = null;
    update();
  }
}
