import '../core/network/api_client.dart';
import '../models/user.dart';

/// Result of a successful login: the user and their access token.
class AuthSession {
  const AuthSession({required this.user, required this.token});

  final User user;
  final String token;
}

/// Data access for the `/auth` endpoints.
class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final dynamic data = await _api.post(
      '/auth/login',
      body: <String, dynamic>{'email': email, 'password': password},
    );
    final Map<String, dynamic> map = data as Map<String, dynamic>;
    return AuthSession(
      user: User.fromJson(map['user'] as Map<String, dynamic>),
      token: map['accessToken'] as String,
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _api.post(
      '/auth/register',
      body: <String, dynamic>{'name': name, 'email': email, 'password': password},
    );
  }

  Future<void> forgotPassword(String email) async {
    await _api.post('/auth/forgot-password', body: <String, dynamic>{'email': email});
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _api.post(
      '/auth/reset-password',
      body: <String, dynamic>{'token': token, 'newPassword': newPassword},
    );
  }
}
