import 'package:fp_ppb_expense_tracker/infrastructure/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/services/shared_preferences.dart';
import 'package:fp_ppb_expense_tracker/model/user.dart';

class AuthMethods {
  final String _baseurl = 'https://ppb-backend-urrztf2ada-as.a.run.app';
  // final String _baseurl = 'http://localhost:8080';
  final SecureStorage _secureStorage = SecureStorage();
  final String _loginPath = '/login';
  final String _registerPath = '/register';
  final String _profilePath = '/v1/me';
  final Dio _dio = Dio();

  Future<void> login(String email, String password) async {
    var formData = FormData.fromMap({
      'username': email,
      'password': password,
    });
    final Response response = await _dio.post(
      '$_baseurl$_loginPath',
      data: formData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login');
    }

    final String token = response.data['data'];
    await _secureStorage.writeSecureData('token', token);

    return;
  }

  Future<void> register(String email, String password) async {
    var formData = FormData.fromMap({
      'username': email,
      'password': password,
      'confirm_password': password,
    });
    final Response response = await _dio.post(
      '$_baseurl$_registerPath',
      data: formData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }

    return;
  }

  Future<void> getProfile() async {
    final String? token = await _secureStorage.readSecureData('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final Response response = await _dio.get(
      '$_baseurl$_profilePath',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get profile');
    }

    User user = User.fromJson(response.data['data'] as Map<String, dynamic>);
    await SharedPreference.saveUser(user);
  }

  Future<void> logout() async {
    await _secureStorage.deleteSecureData('token');
  }

  Future<bool> isUserLoggedIn() async {
    final String? token = await _secureStorage.readSecureData('token');
    return token != null;
  }

  Future<String?> getToken() async {
    return await _secureStorage.readSecureData('token');
  }
}
