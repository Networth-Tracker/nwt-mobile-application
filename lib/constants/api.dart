class ApiURLs {
  static const String baseUrl = "https://lab.networthtracker.in/api/v1";

  static const GENERATE_OTP = "$baseUrl/auth/send-otp";
  static const VERIFY_OTP = "$baseUrl/auth/verify-otp";
  static const PAN_CARD_VERIFICATION = "$baseUrl/pan-verification/verify";
  static const SET_SECURITY_PIN = "$baseUrl/auth/set-security-pin";
  static const LOGIN_WITH_PIN = "$baseUrl/auth/security-pin";
  static const GET_USER_PROFILE = "$baseUrl/userdetail/profile";
  static const USER_DASHBOARD_ASSETS = "$baseUrl/dashboard/assets";
  static const GET_USER_INVESTMENTS = "$baseUrl/dashboard/portfolio";
  static const GET_BANK_SUMMARY = "$baseUrl/bank/summary";
  static const GET_USER_HOLDINGS = "$baseUrl/dashboard/portfolio/all";
  static const GET_BANK_TRANSACTION = "$baseUrl/bank/transactions";
  static const GET_ZERODHA_CONNECTION = "$baseUrl/zerodha/login-url";
  static const GET_TOTAL_NETWORTH = "$baseUrl/dashboard/graph";
}
