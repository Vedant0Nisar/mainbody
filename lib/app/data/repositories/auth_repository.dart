import '../providers/mock_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final MockApiService _apiService;

  AuthRepository(this._apiService);

  Future<bool> login(String username, String password) async {
    final success = await _apiService.login(username, password);
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'admin');
    }
    return success;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('role');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
