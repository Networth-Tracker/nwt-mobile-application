import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nwt_app/constants/storage_keys.dart';
import 'package:nwt_app/services/global_storage.dart';
import 'package:nwt_app/utils/logger.dart';

class APIHelper {
  void _logApiCall(
      String method, String url, dynamic data, http.Response? response) {
    AppLogger.info('API $method Request:', tag: 'API');
    AppLogger.info('URL: $url', tag: 'API');
    if (data != null) {
      AppLogger.info('Data: ${jsonEncode(data)}', tag: 'API');
    }
    if (response != null) {
      AppLogger.info('Status Code: ${response.statusCode}', tag: 'API');
      try {
        final decodedResponse = jsonDecode(response.body);
        AppLogger.info(
            'Message: ${decodedResponse['message'] ?? 'No message provided'}',
            tag: 'API');
      } catch (e) {
        AppLogger.error('Failed to decode response', error: e, tag: 'API');
        AppLogger.debug('Response body: ${response.body}', tag: 'API');
      }
    }
  }

  Future<http.Response?> get(
    String endpoint, {
    String? token,
  }) async {
    String localToken = "";
    if (token == null) {
      localToken = StorageService.read(StorageKeys.AUTH_TOKEN_KEY) ?? "";
    } else {
      localToken = token;
    }
    final url = Uri.parse(endpoint);
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $localToken",
      },
    );
    _logApiCall('GET', endpoint, null, response);
    return response;
  }

  Future<http.Response?> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    String localToken = "";
    if (token == null) {
      localToken = StorageService.read(StorageKeys.AUTH_TOKEN_KEY) ?? "";
    } else {
      localToken = token;
    }
    final url = Uri.parse(endpoint);
    final response = await http.post(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $localToken",
    });
    _logApiCall('POST', endpoint, body, response);
    return response;
  }

  Future<http.Response?> patch(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    String localToken = "";
    if (token == null) {
      localToken = StorageService.read(StorageKeys.AUTH_TOKEN_KEY) ?? "";
    } else {
      localToken = token;
    }
    final url = Uri.parse(endpoint);
    final response = await http.patch(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $localToken",
    });
    _logApiCall('PATCH', endpoint, body, response);
    return response;
  }

  Future<http.Response?> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    String localToken = "";
    if (token == null) {
      localToken = StorageService.read(StorageKeys.AUTH_TOKEN_KEY) ?? "";
    } else {
      localToken = token;
    }
    final url = Uri.parse(endpoint);
    final response = await http.put(url, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $localToken",
    });
    _logApiCall('PUT', endpoint, body, response);
    return response;
  }

  Future<http.Response?> delete(
    String endpoint, {
    String? token,
  }) async {
    String localToken = "";
    if (token == null) {
      localToken = StorageService.read(StorageKeys.AUTH_TOKEN_KEY) ?? "";
    } else {
      localToken = token;
    }
    final url = Uri.parse(endpoint);
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $localToken",
    });
    _logApiCall('DELETE', endpoint, null, response);
    return response;
  }
}