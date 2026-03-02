import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiClient {
  static const String baseUrl =
      'http://164.52.211.208:8001/api'; // Replace with actual backend IP
  final _box = GetStorage();

  Future<Map<String, String>> _getHeaders(bool requiresAuth) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = _box.read('access_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(requiresAuth);
    print('======== API GET REQUEST ========');
    print('URL: $url');
    print('Headers: $headers');

    final response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 60));

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('=================================');
    return response;
  }

  Future<http.Response> post(String endpoint,
      {dynamic body, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(requiresAuth);
    final encodedBody = jsonEncode(body);

    print('======== API POST REQUEST ========');
    print('URL: $url');
    print('Headers: $headers');
    print('Body: $encodedBody');

    final response = await http
        .post(url, headers: headers, body: encodedBody)
        .timeout(const Duration(seconds: 60));

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('==================================');
    return response;
  }

  Future<http.Response> put(String endpoint,
      {dynamic body, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(requiresAuth);
    final encodedBody = body != null ? jsonEncode(body) : null;

    print('======== API PUT REQUEST ========');
    print('URL: $url');
    print('Headers: $headers');
    if (encodedBody != null) print('Body: $encodedBody');

    final response = await http
        .put(url, headers: headers, body: encodedBody)
        .timeout(const Duration(seconds: 60));

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('=================================');
    return response;
  }

  Future<http.Response> delete(String endpoint,
      {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(requiresAuth);

    print('======== API DELETE REQUEST ========');
    print('URL: $url');
    print('Headers: $headers');

    final response = await http
        .delete(url, headers: headers)
        .timeout(const Duration(seconds: 60));

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('====================================');
    return response;
  }
}
