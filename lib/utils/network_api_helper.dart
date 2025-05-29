import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/services/network/network_interceptor.dart';
import 'package:nwt_app/utils/logger.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class NetworkAPIHelper {
  final NetworkInterceptor _interceptor = NetworkInterceptor(
    timeout: const Duration(seconds: 30),
  );

  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

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

  Future<http.Response?> get(
    String url, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
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

  Future<http.Response?> post(
    String url,
    dynamic body, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
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
      AppLogger.info('POST Response: ${response.body}', tag: 'NetworkAPIHelper');
      AppLogger.info('POST Response Code: ${response.statusCode}', tag: 'NetworkAPIHelper');
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('POST Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  Future<http.Response?> put(
    String url,
    dynamic body, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
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
      AppLogger.info('PUT Response: ${response.body}', tag: 'NetworkAPIHelper');
      AppLogger.info('PUT Response Code: ${response.statusCode}', tag: 'NetworkAPIHelper');
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('PUT Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  Future<http.Response?> patch(
    String url,
    dynamic body, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      if (!_connectivityService.isConnected) {
        _handleNoConnectivity();
        return null;
      }

      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      AppLogger.info('PATCH Request: $url', tag: 'NetworkAPIHelper');
      AppLogger.info(
        'PATCH Body: ${jsonEncode(body)}',
        tag: 'NetworkAPIHelper',
      );

      final response = await _interceptor.patch(url, body, headers: headers);
      AppLogger.info('PATCH Response: ${response.body}', tag: 'NetworkAPIHelper');
      AppLogger.info('PATCH Response Code: ${response.statusCode}', tag: 'NetworkAPIHelper');
        return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('PATCH Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  Future<http.Response?> delete(
    String url, {
    bool requiresAuth = true,
    Map<String, String>? additionalHeaders,
    dynamic body,
  }) async {
    try {
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
      AppLogger.info('DELETE Response: ${response.body}', tag: 'NetworkAPIHelper');
      AppLogger.info('DELETE Response Code: ${response.statusCode}', tag: 'NetworkAPIHelper');
      return response;
    } on NetworkException catch (e) {
      _handleNetworkException(e);
      return null;
    } catch (e) {
      AppLogger.error('DELETE Request Error: $e', tag: 'NetworkAPIHelper');
      return null;
    }
  }

  void _handleNetworkException(NetworkException exception) {
    AppLogger.error(
      'Network Exception: ${exception.message}',
      tag: 'NetworkAPIHelper',
    );

    switch (exception.errorType) {
      case NetworkErrorType.noInternet:
        break;
      case NetworkErrorType.timeout:
        break;
      case NetworkErrorType.unauthorized:
        break;
      case NetworkErrorType.serverError:
        break;
      default:
    }
  }

  void _handleNoConnectivity() {
    AppLogger.warning('No internet connection', tag: 'NetworkAPIHelper');

    Get.snackbar(
      'No Internet Connection',
      'Please check your network settings and try again.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.8),
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
