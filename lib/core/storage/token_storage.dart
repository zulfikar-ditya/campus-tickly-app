import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT access token (and a cached copy of the signed-in user) in
/// the platform's encrypted keystore.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> readUser() => _storage.read(key: _userKey);

  Future<void> writeUser(String userJson) =>
      _storage.write(key: _userKey, value: userJson);

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
