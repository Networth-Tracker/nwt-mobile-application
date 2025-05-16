import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/services/network/network_interceptor.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

/// Helper class for making API requests with network state management
class NetworkAPIHelper {
  final NetworkInterceptor _interceptor = NetworkInterceptor(
    timeout: const Duration(seconds: 30),
  );
  
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();

  /// Creates default headers for API requests
  Map<String, String> _getHeaders({bool requiresAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = StorageService.read(StorageKeys.AUTH_TOKEN_KEY);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Performs a GET request
  Future<http.Response?> get(
    String url, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isConnected) {
        _handleNoConnectivity();
        return null;
      }

      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      AppLogger.info('GET Request: $url', tag: 'NetworkAPIHelper');
      final response = await _interceptor.get(url, headers: headers);
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('GET Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  /// Performs a POST request
  Future<http.Response?> post(
    String url,
    dynamic body, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isConnected) {
        _handleNoConnectivity();
        return null;
      }

      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      AppLogger.info('POST Request: $url', tag: 'NetworkAPIHelper');
      AppLogger.info('POST Body: ${jsonEncode(body)}', tag: 'NetworkAPIHelper');
      
      final response = await _interceptor.post(url, body, headers: headers);
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('POST Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  /// Performs a PUT request
  Future<http.Response?> put(
    String url,
    dynamic body, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isConnected) {
        _handleNoConnectivity();
        return null;
      }

      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      AppLogger.info('PUT Request: $url', tag: 'NetworkAPIHelper');
      final response = await _interceptor.put(url, body, headers: headers);
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('PUT Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  /// Performs a DELETE request
  Future<http.Response?> delete(
    String url, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
    dynamic body,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isConnected) {
        _handleNoConnectivity();
        return null;
      }

      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      AppLogger.info('DELETE Request: $url', tag: 'NetworkAPIHelper');
      final response = await _interceptor.delete(
        url,
        headers: headers,
        body: body,
      );
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('DELETE Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  /// Handles network exceptions and shows appropriate UI feedback
  void _handleNetworkException(NetworkException exception) {
    AppLogger.error(
      'Network Exception: ${exception.message}',
      tag: 'NetworkAPIHelper',
    );

    String title;
    String message = exception.message;

    switch (exception.errorType) {
      case NetworkErrorType.noInternet:
        title = 'No Internet Connection';
        message = 'Please check your network settings and try again.';
        break;
      case NetworkErrorType.timeout:
        title = 'Request Timeout';
        message = 'The server took too long to respond. Please try again.';
        break;
      case NetworkErrorType.unauthorized:
        title = 'Authentication Error';
        message = 'Your session has expired. Please log in again.';
        // Handle token expiration/logout if needed
        break;
      case NetworkErrorType.serverError:
        title = 'Server Error';
        message = 'Something went wrong on our servers. Please try again later.';
        break;
      default:
        title = 'Error';
    }

    // Show error message to user
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onError,
    );
  }

  /// Handles no connectivity scenario
  void _handleNoConnectivity() {
    AppLogger.warning('No internet connection', tag: 'NetworkAPIHelper');
    
    Get.snackbar(
      'No Internet Connection',
      'Please check your network settings and try again.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
      colorText: Get.theme.colorScheme.onError,
      mainButton: TextButton(
        onPressed: () async {
          await _connectivityService.checkConnectivity();
        },
        child: const AppText(
          'Retry',
          variant: AppTextVariant.bodySmall,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
      ),
    );
  }
}
