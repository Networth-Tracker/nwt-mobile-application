import 'package:firebase_remote_config/firebase_remote_config.dart';

class ApiURLs {
  // Get base URL from Firebase Remote Config, with fallback value
  static String get baseUrl {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final configBaseUrl = remoteConfig.getString('api_base_url');

      // If remote config has a value, use it, otherwise use the default
      return configBaseUrl.isNotEmpty
          ? configBaseUrl
          : "https://lab.networthtracker.in/api/v1";
    } catch (e) {
      // Fallback to default URL if remote config fails
      return "https://lab.networthtracker.in/api/v1";
    }
  }

  // Generate dynamic endpoint getters that use the current baseUrl
  static String get GENERATE_OTP => "$baseUrl/auth/send-otp";
  static String get VERIFY_OTP => "$baseUrl/auth/verify-otp";
  static String get PAN_CARD_VERIFICATION => "$baseUrl/pan-verification/verify";
  static String get SET_SECURITY_PIN => "$baseUrl/auth/set-security-pin";
  static String get LOGIN_WITH_PIN => "$baseUrl/auth/security-pin";
  static String get GET_USER_PROFILE => "$baseUrl/userdetail/profile";
  static String get USER_DASHBOARD_ASSETS => "$baseUrl/dashboard/assets";
  static String get GET_USER_INVESTMENTS => "$baseUrl/dashboard/portfolio";
  static String get GET_BANK_SUMMARY => "$baseUrl/bank/summary";
  static String get GET_USER_HOLDINGS => "$baseUrl/dashboard/portfolio/all";
  static String get GET_BANK_TRANSACTION => "$baseUrl/bank/transactions";
  static String get GET_ZERODHA_CONNECTION => "$baseUrl/zerodha/login-url";

  static String get MF_HOLDINGS_TOKEN => "$baseUrl/mfcentral/token";
  static String get MF_HOLDINGS_VERIFY => "$baseUrl/mfcentral/submit-otp";
  static String get GET_TOTAL_NETWORTH => "$baseUrl/dashboard/graph";

  // Mutual Fund Switch Advice endpoints
  static String get GET_MF_SWITCH_ADVICE => "$baseUrl/mfcentral/switch/details";

  static String get GET_NOTIFICATION_PERMISSION => "$baseUrl/userdetail/fcm";
}
