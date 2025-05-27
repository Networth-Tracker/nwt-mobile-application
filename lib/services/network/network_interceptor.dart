import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nwt_app/services/network/connectivity_service.dart';
import 'package:nwt_app/utils/logger.dart';

/// Custom exception class for network errors
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? body;
  final NetworkErrorType errorType;

  NetworkException({
    required this.message,
    this.statusCode,
    this.body,
    required this.errorType,
  });

  @override
  String toString() =>
      'NetworkException: $message (Status: $statusCode, Type: $errorType)';
}

/// Types of network errors that can occur
enum NetworkErrorType {
  noInternet,
  timeout,
  serverError,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  unknown,
}

/// HTTP client with network interceptor functionality
class NetworkInterceptor {
  final ConnectivityService _connectivityService = ConnectivityService.to;
  final Duration _timeout;

  NetworkInterceptor({Duration? timeout})
    : _timeout = timeout ?? const Duration(seconds: 30);

  /// Perform a GET request with network interceptor
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _executeRequest(() => http.get(Uri.parse(url), headers: headers));
  }

  /// Perform a POST request with network interceptor
  Future<http.Response> post(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => http.post(
        Uri.parse(url),
        headers: headers,
        body: body is String ? body : jsonEncode(body),
      ),
    );
  }

  /// Perform a PUT request with network interceptor
  Future<http.Response> put(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => http.put(
        Uri.parse(url),
        headers: headers,
        body: body is String ? body : jsonEncode(body),
      ),
    );
  }

  /// Perform a DELETE request with network interceptor
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _executeRequest(
      () => http.delete(
        Uri.parse(url),
        headers: headers,
        body: body != null ? (body is String ? body : jsonEncode(body)) : null,
      ),
    );
  }

  /// Perform a PATCH request with network interceptor
  Future<http.Response> patch(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => http.patch(
        Uri.parse(url),
        headers: headers,
        body: body is String ? body : jsonEncode(body),
      ),
    );
  }

  /// Execute the HTTP request with error handling and connectivity check
  Future<http.Response> _executeRequest(
    Future<http.Response> Function() requestFunction,
  ) async {
    // Check network connectivity before making the request
    if (!_connectivityService.isConnected) {
      AppLogger.error('No internet connection', tag: 'NetworkInterceptor');
      throw NetworkException(
        message: 'No internet connection. Please check your network settings.',
        errorType: NetworkErrorType.noInternet,
      );
    }

    try {
      // Execute the request with timeout
      final response = await requestFunction().timeout(_timeout);

      // Log the response
      AppLogger.info(
        'Response: ${response.statusCode} - ${response.body.length} bytes',
        tag: 'NetworkInterceptor',
      );

      // Handle HTTP error status codes
      if (response.statusCode >= 400) {
        final errorType = _getErrorTypeFromStatusCode(response.statusCode);
        final errorMessage = _getErrorMessageFromStatusCode(
          response.statusCode,
        );

        throw NetworkException(
          message: errorMessage,
          statusCode: response.statusCode,
          body: response.body,
          errorType: errorType,
        );
      }

      return response;
    } on TimeoutException {
      AppLogger.error('Request timeout', tag: 'NetworkInterceptor');
      throw NetworkException(
        message: 'Request timed out. Please try again.',
        errorType: NetworkErrorType.timeout,
      );
    } on SocketException catch (e) {
      AppLogger.error(
        'Socket exception: ${e.message}',
        tag: 'NetworkInterceptor',
      );
      throw NetworkException(
        message:
            'Network connection error. Please check your internet connection.',
        errorType: NetworkErrorType.noInternet,
      );
    } on NetworkException {
      rethrow; // Re-throw already formatted network exceptions
    } catch (e) {
      AppLogger.error('Unknown error: $e', tag: 'NetworkInterceptor');
      throw NetworkException(
        message: 'An unexpected error occurred. Please try again.',
        errorType: NetworkErrorType.unknown,
      );
    }
  }

  /// Map HTTP status code to NetworkErrorType
  NetworkErrorType _getErrorTypeFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return NetworkErrorType.badRequest;
      case 401:
        return NetworkErrorType.unauthorized;
      case 403:
        return NetworkErrorType.forbidden;
      case 404:
        return NetworkErrorType.notFound;
      case >= 500 && < 600:
        return NetworkErrorType.serverError;
      default:
        return NetworkErrorType.unknown;
    }
  }

  /// Get user-friendly error message based on status code
  String _getErrorMessageFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case >= 500 && < 600:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
