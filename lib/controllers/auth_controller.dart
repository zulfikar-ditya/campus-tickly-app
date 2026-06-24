import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../core/storage/token_storage.dart';
import '../data/auth_repository.dart';
import '../models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Owns authentication state for the app: the current session, in-flight status
/// for forms, and the actions that talk to [AuthRepository]. Views observe this
/// via Provider.
class AuthController extends ChangeNotifier {
  AuthController(this._repository, this._tokenStorage);

  final AuthRepository _repository;
  final TokenStorage _tokenStorage;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  User? _user;
  User? get user => _user;

  bool _busy = false;
  bool get busy => _busy;

  String? _error;
  String? get error => _error;

  /// Restore a persisted session on app start.
  Future<void> bootstrap() async {
    final String? token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) {
      _setStatus(AuthStatus.unauthenticated);
      return;
    }
    final String? userJson = await _tokenStorage.readUser();
    if (userJson != null) {
      try {
        _user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        _user = null;
      }
    }
    _setStatus(AuthStatus.authenticated);
  }

  Future<bool> login(String email, String password) async {
    return _run(() async {
      final AuthSession session = await _repository.login(email: email, password: password);
      await _tokenStorage.writeToken(session.token);
      await _tokenStorage.writeUser(jsonEncode(session.user.toJson()));
      _user = session.user;
      _setStatus(AuthStatus.authenticated);
    });
  }

  Future<bool> register(String name, String email, String password) async {
    return _run(() => _repository.register(name: name, email: email, password: password));
  }

  Future<bool> forgotPassword(String email) async {
    return _run(() => _repository.forgotPassword(email));
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    return _run(() => _repository.resetPassword(token: token, newPassword: newPassword));
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _user = null;
    _error = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  /// Runs an async action, tracking busy/error state and returning whether it
  /// succeeded. The error message (if any) is exposed via [error].
  Future<bool> _run(Future<void> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
