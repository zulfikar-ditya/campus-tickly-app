import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Thin HTTP wrapper around the Tickly backend.
///
/// It attaches the bearer token, encodes/decodes JSON, unwraps the standard
/// `{ status, success, message, data, errors }` envelope, and turns any
/// non-success response into an [ApiException]. Every method returns the
/// envelope's `data` payload.
class ApiClient {
  ApiClient(this._tokenStorage, {http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final TokenStorage _tokenStorage;
  final http.Client _http;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final Uri base = Uri.parse('${AppConfig.apiBaseUrl}$path');
    if (query == null || query.isEmpty) return base;
    final Map<String, String> params = <String, String>{};
    query.forEach((String key, dynamic value) {
      if (value != null) params[key] = value.toString();
    });
    return base.replace(queryParameters: params);
  }

  Future<Map<String, String>> _headers() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final String? token = await _tokenStorage.readToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    return _send(() async => _http.get(_uri(path, query), headers: await _headers()));
  }

  Future<dynamic> post(String path, {Object? body}) async {
    return _send(
      () async =>
          _http.post(_uri(path), headers: await _headers(), body: jsonEncode(body ?? <String, dynamic>{})),
    );
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    return _send(
      () async =>
          _http.patch(_uri(path), headers: await _headers(), body: jsonEncode(body ?? <String, dynamic>{})),
    );
  }

  Future<dynamic> delete(String path) async {
    return _send(() async => _http.delete(_uri(path), headers: await _headers()));
  }

  /// Runs [request], decodes the envelope, and either returns `data` or throws.
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request();
    } catch (error) {
      throw ApiException(
        'Could not reach the server. Check your connection and that the '
        'backend is running.',
      );
    }

    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = null;
      }
    }

    final bool ok = response.statusCode >= 200 && response.statusCode < 300;
    final bool success = decoded is Map<String, dynamic> && decoded['success'] == true;

    if (ok && success) {
      return decoded['data'];
    }

    throw _toException(response.statusCode, decoded);
  }

  ApiException _toException(int statusCode, dynamic decoded) {
    String message = 'Something went wrong. Please try again.';
    final Map<String, String> fieldErrors = <String, String>{};

    if (decoded is Map<String, dynamic>) {
      if (decoded['message'] is String && (decoded['message'] as String).isNotEmpty) {
        message = decoded['message'] as String;
      }
      final dynamic errors = decoded['errors'];
      if (errors is List) {
        for (final dynamic e in errors) {
          if (e is Map && e['field'] is String && e['message'] is String) {
            fieldErrors[e['field'] as String] = e['message'] as String;
          }
        }
      }
    }

    return ApiException(message, statusCode: statusCode, fieldErrors: fieldErrors);
  }
}
