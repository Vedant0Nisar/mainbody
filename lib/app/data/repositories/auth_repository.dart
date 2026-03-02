import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../data/providers/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final _box = GetStorage();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {'email': username, 'password': password},
        requiresAuth: false,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['access_token'] != null) {
          _box.write('access_token', data['access_token']);
          _box.write('role', data['role']);
          return true;
        }
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    _box.remove('access_token');
    _box.remove('role');
  }

  Future<bool> isLoggedIn() async {
    return _box.hasData('access_token');
  }
}
